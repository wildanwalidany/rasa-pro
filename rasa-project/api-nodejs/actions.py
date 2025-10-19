from typing import Any, Text, Dict, List
from rasa_sdk import Action, Tracker
from rasa_sdk.executor import CollectingDispatcher
import requests
import logging

# Setup logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Configuration
NODE_API_BASE_URL = "http://localhost:3000/api/gizi"

class ActionCariInfoGizi(Action):
    
    def name(self) -> Text:
        return "action_cari_info_gizi"
    
    def extract_product_name(self, user_message):
        """Extract product name from user message"""
        known_products = [
            'teh botol sosro', 'ultra milk strawberry', 'ultra milk', 'aqua',
            'pop mie ayam', 'pop mie', 'indomie goreng', 'indomie', 'coca cola',
            'silverqueen', 'oreo', 'nutrisari jeruk', 'nutrisari', 'yakult',
            'chitato', 'good day cappuccino', 'good day', 'fruit tea apel',
            'fruit tea lemon', 'fruit tea', 'frestea green tea', 'frestea',
            'kfc chicken', 'kfc', 'mcd burger', 'mcd', 'pizza kecil', 'pizza',
            'popcorn manis', 'popcorn', 'sari roti coklat', 'sari roti',
            'dancow fortigro', 'dancow', 'teh pucuk', 'fanta', 'sprite',
            'yakult light', 'beng beng', 'energen', 'biskuat', 'pringles',
            'pocari sweat', 'pocari', 'teh gelas', 'teh kotak', 'bear brand',
            'milo', 'nutriboost', 'cimory yogurt', 'cimory', 'mizone',
            'floridina', 'indomilk kids', 'indomilk', 'cheetos', 'tango',
            'sari gandum', 'koko krunch', 'milo sachet', 'good time',
            'taro net', 'twister', 'prenagen velvety choco', 'prenagen'
        ]
        
        # Sort by length (longest first) for better matching
        known_products.sort(key=len, reverse=True)
        
        for product in known_products:
            if product in user_message.lower():
                logger.info(f"Found product keyword: {product}")
                return product
        
        # If no keyword found, try to extract from cleaned message
        words_to_remove = [
            'berapa', 'kalori', 'dalam', 'info', 'gizi', 'kandungan', 
            'nutrisi', 'dari', 'untuk', 'tentang', 'mengenai', '?', 
            ',', '.', 'apa', 'bagaimana', 'gimana'
        ]
        
        cleaned = user_message.lower()
        for word in words_to_remove:
            cleaned = cleaned.replace(word, ' ')
        
        cleaned = ' '.join(cleaned.split())  # Remove extra spaces
        
        if len(cleaned) > 2:
            logger.info(f"Extracted product name: {cleaned}")
            return cleaned
        
        return None
    
    def call_nodejs_api(self, product_name):
        """Call Node.js API to get product information"""
        try:
            url = f"{NODE_API_BASE_URL}/produk"
            payload = {"nama_produk": product_name}
            
            logger.info(f"Calling Node.js API: {url} with payload: {payload}")
            
            response = requests.post(url, json=payload, timeout=10)
            
            if response.status_code == 200:
                data = response.json()
                logger.info(f"API response: {data}")
                return data.get('data')
            elif response.status_code == 404:
                logger.info(f"Product '{product_name}' not found in database")
                return None
            else:
                logger.error(f"API error: {response.status_code} - {response.text}")
                return None
                
        except requests.exceptions.RequestException as e:
            logger.error(f"Failed to call Node.js API: {e}")
            return None
    
    def format_nutrition_info(self, product):
        """Format nutrition information for display"""
        response = f"🍎 **{product['nama_produk']}**"
        
        if product.get('takaran_saji'):
            response += f" ({product['takaran_saji']})"
        
        response += f"\n📊 **{product['kalori']} kkal**"
        
        # Add nutritional details
        nutrition_details = []
        
        if product.get('protein') and float(product['protein']) > 0:
            nutrition_details.append(f"🥩 Protein: {product['protein']}g")
        
        if product.get('lemak') and float(product['lemak']) > 0:
            nutrition_details.append(f"🧈 Lemak: {product['lemak']}g")
        
        if product.get('karbohidrat') and float(product['karbohidrat']) > 0:
            nutrition_details.append(f"🍞 Karbohidrat: {product['karbohidrat']}g")
        
        if product.get('gula') and float(product['gula']) > 0:
            nutrition_details.append(f"🍯 Gula: {product['gula']}g")
        
        if product.get('natrium') and float(product['natrium']) > 0:
            nutrition_details.append(f"🧂 Natrium: {product['natrium']}mg")
        
        if product.get('serat') and float(product['serat']) > 0:
            nutrition_details.append(f"🌾 Serat: {product['serat']}g")
        
        if nutrition_details:
            response += "\n\n" + "\n".join(nutrition_details)
        
        # Add category info
        if product.get('kategori'):
            kategori_emoji = {
                'minuman': '🥤',
                'makanan': '🍽️',
                'snack': '🍿',
                'suplemen': '💊'
            }
            emoji = kategori_emoji.get(product['kategori'], '🍽️')
            response += f"\n\n{emoji} Kategori: {product['kategori'].title()}"
        
        response += f"\n\n🔗 *Data dari Node.js API + MySQL Database*"
        
        return response
    
    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        
        user_message = tracker.latest_message.get('text', '')
        logger.info(f"Received user message: '{user_message}'")
        
        # Extract product name
        product_name = self.extract_product_name(user_message)
        
        if not product_name:
            response = ("🤔 Mohon sebutkan nama produk yang ingin dicek.\n\n"
                       "💡 Contoh produk yang tersedia:\n"
                       "• Teh Botol Sosro\n• Good Day Cappuccino\n• Indomie Goreng\n"
                       "• Coca Cola\n• Silverqueen\n• Yakult\n\n"
                       "Silakan coba lagi dengan menyebutkan nama produk yang spesifik! 😊")
            dispatcher.utter_message(text=response)
            return []
        
        # Call Node.js API
        found_product = self.call_nodejs_api(product_name)
        
        if found_product:
            response = self.format_nutrition_info(found_product)
        else:
            response = (f"❌ Maaf, informasi gizi untuk '{product_name}' belum tersedia dalam database.\n\n"
                       "🔍 **Produk yang tersedia:**\n"
                       "• Minuman: Teh Botol Sosro, Coca Cola, Ultra Milk, Yakult\n"
                       "• Makanan: Indomie, Pop Mie, KFC Chicken, Pizza\n"
                       "• Snack: Silverqueen, Oreo, Chitato, Pringles\n\n"
                       "Silakan coba dengan nama produk yang lebih spesifik! 😊")
        
        dispatcher.utter_message(text=response)
        return []

class ActionCariKaloriHarian(Action):
    
    def name(self) -> Text:
        return "action_cari_kalori_harian"
    
    def extract_kategori_dan_gender(self, user_message):
        """Extract kategori usia dan jenis kelamin dari pesan user"""
        message = user_message.lower()
        
        kategori_mapping = {
            'dewasa': ['dewasa', 'adult'],
            'remaja': ['remaja', 'teenager', 'abg'],
            'anak': ['anak', 'anak-anak', 'child', 'balita'],
            'lansia': ['lansia', 'elderly', 'orang tua', 'manula'],
            'ibu_hamil': ['ibu hamil', 'bumil', 'pregnant', 'hamil'],
            'ibu_menyusui': ['ibu menyusui', 'busui', 'menyusui'],
            'atlet': ['atlet', 'athlete', 'olahragawan']
        }
        
        gender_mapping = {
            'pria': ['pria', 'laki-laki', 'cowok', 'man', 'male'],
            'wanita': ['wanita', 'perempuan', 'cewek', 'woman', 'female']
        }
        
        found_kategori = None
        found_gender = None
        
        for kategori, keywords in kategori_mapping.items():
            if any(keyword in message for keyword in keywords):
                found_kategori = kategori
                break
        
        for gender, keywords in gender_mapping.items():
            if any(keyword in message for keyword in keywords):
                found_gender = gender
                break
        
        return found_kategori, found_gender
    
    def call_nodejs_api(self, kategori, gender=None):
        """Call Node.js API to get kalori harian"""
        try:
            url = f"{NODE_API_BASE_URL}/kalori-harian"
            payload = {"kategori_usia": kategori}
            if gender:
                payload["jenis_kelamin"] = gender
            
            logger.info(f"Calling Node.js API: {url} with payload: {payload}")
            
            response = requests.post(url, json=payload, timeout=10)
            
            if response.status_code == 200:
                data = response.json()
                logger.info(f"API response: {data}")
                return data.get('data')
            elif response.status_code == 404:
                logger.info(f"Kalori data for '{kategori}' not found")
                return None
            else:
                logger.error(f"API error: {response.status_code} - {response.text}")
                return None
                
        except requests.exceptions.RequestException as e:
            logger.error(f"Failed to call Node.js API: {e}")
            return None
    
    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        
        user_message = tracker.latest_message.get('text', '')
        logger.info(f"Received kalori harian query: '{user_message}'")
        
        kategori, gender = self.extract_kategori_dan_gender(user_message)
        
        if not kategori:
            response = ("❓ Mohon sebutkan kategori yang lebih spesifik:\n\n"
                       "👨👩 **Dewasa** (pria/wanita)\n"
                       "👦👧 **Remaja** (pria/wanita)\n"
                       "👶 **Anak-anak**\n"
                       "👴👵 **Lansia** (pria/wanita)\n"
                       "🤱 **Ibu hamil**\n"
                       "🤱 **Ibu menyusui**\n"
                       "🏃 **Atlet** (pria/wanita)")
            dispatcher.utter_message(text=response)
            return []
        
        # Call Node.js API
        result = self.call_nodejs_api(kategori, gender)
        
        if result:
            kategori_display = result['kategori_usia'].replace('_', ' ').title()
            gender_display = result['jenis_kelamin'].title() if result['jenis_kelamin'] != 'umum' else ''
            
            if result['min_kalori'] == result['max_kalori']:
                kalori_range = f"{result['min_kalori']} kkal"
            else:
                kalori_range = f"{result['min_kalori']}-{result['max_kalori']} kkal"
            
            response = f"📊 **Kebutuhan Kalori Harian**\n\n"
            response += f"👤 **{kategori_display}"
            if gender_display:
                response += f" {gender_display}"
            response += "**\n"
            response += f"🔥 **{kalori_range} per hari**\n"
            response += f"⚡ Aktivitas: {result['aktivitas_level'].title()}\n\n"
            response += "🔗 *Data dari Node.js API + MySQL Database*"
            
        else:
            response = (f"❌ Data kebutuhan kalori untuk kategori tersebut tidak ditemukan.\n\n"
                       "📋 **Kategori yang tersedia:**\n"
                       "• Dewasa (Pria/Wanita) • Remaja (Pria/Wanita)\n• Anak-anak • Lansia (Pria/Wanita)\n"
                       "• Ibu Hamil • Ibu Menyusui • Atlet (Pria/Wanita)")
        
        dispatcher.utter_message(text=response)
        return []