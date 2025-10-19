"""
Custom Actions for Nutrition Chatbot
Integrates with External NLU Service (port 3000) and Node.js API (port 3001)
"""

from typing import Any, Text, Dict, List
from rasa_sdk import Action, Tracker
from rasa_sdk.executor import CollectingDispatcher
import requests
import logging
import json

# Setup logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Configuration
NODE_API_BASE_URL = "http://localhost:3001/api/gizi"  # Node.js API
NLU_API_BASE_URL = "http://localhost:3000"            # External NLU Service

class ActionCariInfoGizi(Action):
    """Action untuk mencari informasi gizi produk"""
    
    def name(self) -> Text:
        return "action_cari_info_gizi"
    
    def extract_product_name(self, user_message):
        """Extract product name from user message"""
        known_products = [
            'teh botol sosro', 'teh botol', 'sosro',
            'good day cappuccino', 'good day', 'cappuccino',
            'indomie goreng', 'indomie', 'mie goreng',
            'coca cola', 'coca-cola', 'coke', 'cola',
            'silverqueen', 'silver queen', 'coklat silverqueen',
            'yakult', 'nutrisari', 'chitato', 'fruit tea',
            'oreo', 'beng beng', 'tango', 'pocari sweat',
            'aqua', 'floridina', 'mizone', 'frestea',
            'ultra milk', 'bear brand', 'dancow', 'milo',
            'kfc chicken', 'kfc', 'mcd burger', 'pizza',
            'pop mie', 'energen', 'biskuat', 'pringles'
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
            ',', '.', 'apa', 'bagaimana', 'gimana', 'mau', 'tahu'
        ]
        
        cleaned = user_message.lower()
        for word in words_to_remove:
            cleaned = cleaned.replace(word, ' ')
        
        cleaned = ' '.join(cleaned.split())  # Remove extra spaces
        
        if len(cleaned) > 2:
            logger.info(f"Extracted product name: {cleaned}")
            return cleaned
        
        return None
    
    def get_nlu_response(self, user_message):
        """Get response from External NLU Service if available"""
        try:
            url = f"{NLU_API_BASE_URL}/interpret"
            payload = {"text": user_message}
            
            logger.info(f"Calling External NLU: {url}")
            
            response = requests.post(url, json=payload, timeout=5)
            
            if response.status_code == 200:
                data = response.json()
                nlu_response = data.get('response_text')
                intent = data.get('intent', {})
                
                logger.info(f"NLU Response - Intent: {intent.get('name')}, Confidence: {intent.get('confidence')}")
                
                return nlu_response, intent
            else:
                logger.warning(f"External NLU returned status: {response.status_code}")
                
        except Exception as e:
            logger.error(f"External NLU Service error: {e}")
        
        return None, None
    
    def call_nodejs_api(self, product_name):
        """Call Node.js API for detailed nutrition data"""
        try:
            url = f"{NODE_API_BASE_URL}/produk"
            payload = {"nama_produk": product_name}
            
            logger.info(f"Calling Node.js API: {url} with payload: {payload}")
            
            response = requests.post(url, json=payload, timeout=10)
            
            if response.status_code == 200:
                data = response.json()
                logger.info(f"Node.js API response: {data.get('status')}")
                return data.get('data')
            elif response.status_code == 404:
                logger.info(f"Product '{product_name}' not found in database")
                return None
            else:
                logger.error(f"Node.js API error: {response.status_code} - {response.text}")
                return None
                
        except requests.exceptions.RequestException as e:
            logger.error(f"Failed to call Node.js API: {e}")
            return None
    
    def format_nutrition_info(self, product):
        """Format nutrition information for display"""
        if not product:
            return None
        
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
        
        return response
    
    def get_simple_responses(self):
        """Simple fallback responses for common products"""
        return {
            'teh botol sosro': "🥤 **Teh Botol Sosro** (350ml)\n📊 **140 kkal**\n🍞 Karbohidrat: 35g\n🍯 Gula: 32g\n🧂 Natrium: 10mg",
            'good day cappuccino': "☕ **Good Day Cappuccino**\n📊 **110 kkal**\n🍞 Karbohidrat: 20g\n🍯 Gula: 18g\n🧈 Lemak: 3g",
            'indomie goreng': "🍜 **Indomie Goreng**\n📊 **390 kkal**\n🍞 Karbohidrat: 58g\n🧈 Lemak: 14g\n🥩 Protein: 8g",
            'coca cola': "🥤 **Coca Cola** (250ml)\n📊 **105 kkal**\n🍯 Gula: 26g",
            'silverqueen': "🍫 **Silverqueen** (25g)\n📊 **140 kkal**\n🍞 Karbohidrat: 15g\n🧈 Lemak: 8g\n🍯 Gula: 12g",
            'yakult': "🥛 **Yakult** (65ml)\n📊 **50 kkal**\n🍯 Gula: 10g\n🥩 Protein: 1g",
            'oreo': "🍪 **Oreo** (28g)\n📊 **140 kkal**\n🍞 Karbohidrat: 20g\n🍯 Gula: 12g\n🧈 Lemak: 6g"
        }
    
    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        
        user_message = tracker.latest_message.get('text', '')
        logger.info(f"Processing nutrition request: '{user_message}'")
        
        # Strategy 1: Try External NLU Service first
        nlu_response_text, intent = self.get_nlu_response(user_message)
        
        if nlu_response_text and intent and intent.get('confidence', 0) > 0.6:
            logger.info("Using response from External NLU Service")
            dispatcher.utter_message(text=f"🧠 {nlu_response_text}")
            return []
        
        # Strategy 2: Extract product name and try Node.js API
        product_name = self.extract_product_name(user_message)
        
        if product_name:
            logger.info(f"Extracted product: {product_name}")
            
            # Try Node.js API for detailed data
            found_product = self.call_nodejs_api(product_name)
            
            if found_product:
                response = self.format_nutrition_info(found_product)
                if response:
                    response += f"\n\n🔗 *Data dari MySQL Database via Node.js API*"
                    dispatcher.utter_message(text=response)
                    return []
        
        # Strategy 3: Simple fallback responses
        simple_responses = self.get_simple_responses()
        
        for product, response in simple_responses.items():
            if product in user_message.lower():
                logger.info(f"Using simple response for: {product}")
                response += f"\n\n💡 *Data sederhana - untuk info detail coba lagi nanti*"
                dispatcher.utter_message(text=response)
                return []
        
        # Strategy 4: Default fallback
        dispatcher.utter_message(
            text="🔍 Maaf, informasi gizi untuk produk tersebut belum tersedia.\n\n"
                 "💡 **Produk yang bisa dicek:**\n"
                 "• Minuman: Teh Botol Sosro, Coca Cola, Yakult, Ultra Milk\n"
                 "• Makanan: Indomie Goreng, Pop Mie, KFC Chicken\n"
                 "• Snack: Silverqueen, Oreo, Chitato, Pringles\n\n"
                 "Contoh: 'berapa kalori teh botol sosro?'"
        )
        return []

class ActionCariKaloriHarian(Action):
    """Action untuk mencari kebutuhan kalori harian"""
    
    def name(self) -> Text:
        return "action_cari_kalori_harian"
    
    def extract_kategori_dan_gender(self, user_message):
        """Extract kategori usia dan jenis kelamin dari pesan user"""
        message = user_message.lower()
        
        # Mapping kategori
        kategori_mapping = {
            'dewasa': ['dewasa', 'adult', 'orang dewasa'],
            'remaja': ['remaja', 'teenager', 'abg', 'anak remaja'],
            'anak': ['anak', 'anak-anak', 'child', 'balita', 'anak kecil'],
            'lansia': ['lansia', 'elderly', 'orang tua', 'manula', 'kakek', 'nenek'],
            'ibu_hamil': ['ibu hamil', 'bumil', 'pregnant', 'hamil', 'mengandung'],
            'ibu_menyusui': ['ibu menyusui', 'busui', 'menyusui', 'asi'],
            'atlet': ['atlet', 'athlete', 'olahragawan', 'sporty']
        }
        
        # Mapping jenis kelamin
        gender_mapping = {
            'pria': ['pria', 'laki-laki', 'cowok', 'man', 'male', 'lelaki'],
            'wanita': ['wanita', 'perempuan', 'cewek', 'woman', 'female', 'cewe']
        }
        
        found_kategori = None
        found_gender = None
        
        # Cari kategori
        for kategori, keywords in kategori_mapping.items():
            if any(keyword in message for keyword in keywords):
                found_kategori = kategori
                break
        
        # Cari gender
        for gender, keywords in gender_mapping.items():
            if any(keyword in message for keyword in keywords):
                found_gender = gender
                break
        
        return found_kategori, found_gender
    
    def call_kalori_api(self, kategori, gender=None):
        """Call Node.js API for daily calorie requirements"""
        try:
            url = f"{NODE_API_BASE_URL}/kalori-harian"
            payload = {"kategori_usia": kategori}
            if gender:
                payload["jenis_kelamin"] = gender
            
            logger.info(f"Calling Node.js API for kalori: {url} with payload: {payload}")
            
            response = requests.post(url, json=payload, timeout=10)
            
            if response.status_code == 200:
                data = response.json()
                logger.info(f"Kalori API response: {data.get('status')}")
                return data.get('data')
            elif response.status_code == 404:
                logger.info(f"Kalori data for '{kategori}' not found")
                return None
            else:
                logger.error(f"Kalori API error: {response.status_code}")
                return None
                
        except Exception as e:
            logger.error(f"Failed to call kalori API: {e}")
            return None
    
    def get_simple_kalori_responses(self):
        """Simple fallback responses for daily calories"""
        return {
            'wanita dewasa': "👩 **Wanita Dewasa**: 1800-2000 kkal per hari\n⚡ Aktivitas sedang",
            'pria dewasa': "👨 **Pria Dewasa**: 2200-2500 kkal per hari\n⚡ Aktivitas sedang", 
            'anak': "👶 **Anak-anak**: 1400-2000 kkal per hari\n⚡ Tergantung usia dan aktivitas",
            'remaja': "👦👧 **Remaja**: 2000-2400 kkal per hari\n⚡ Masa pertumbuhan aktif",
            'lansia': "👴👵 **Lansia**: 1600-2200 kkal per hari\n⚡ Aktivitas ringan-sedang",
            'ibu hamil': "🤱 **Ibu Hamil**: 2200-2500 kkal per hari\n⚡ Tambahan 300-500 kkal",
            'ibu menyusui': "🤱 **Ibu Menyusui**: 2300-2700 kkal per hari\n⚡ Tambahan 500-700 kkal"
        }
    
    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        
        user_message = tracker.latest_message.get('text', '')
        logger.info(f"Processing kalori harian request: '{user_message}'")
        
        kategori, gender = self.extract_kategori_dan_gender(user_message)
        
        if not kategori:
            dispatcher.utter_message(
                text="❓ Mohon sebutkan kategori yang lebih spesifik:\n\n"
                     "👨👩 **Dewasa** (pria/wanita)\n"
                     "👦👧 **Remaja** (pria/wanita)\n"
                     "👶 **Anak-anak**\n"
                     "👴👵 **Lansia** (pria/wanita)\n"
                     "🤱 **Ibu hamil**\n"
                     "🤱 **Ibu menyusui**\n"
                     "🏃 **Atlet** (pria/wanita)\n\n"
                     "Contoh: 'kalori harian wanita dewasa'"
            )
            return []
        
        # Try Node.js API first
        result = self.call_kalori_api(kategori, gender)
        
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
            response += "💡 *Kebutuhan dapat bervariasi berdasarkan tinggi, berat, dan aktivitas fisik*\n"
            response += "🔗 *Data dari MySQL Database via Node.js API*"
            
            dispatcher.utter_message(text=response)
            return []
        
        # Fallback to simple responses
        simple_responses = self.get_simple_kalori_responses()
        
        # Try to match with simple responses
        search_key = f"{gender} {kategori}" if gender else kategori
        search_key = search_key.replace('_', ' ')
        
        for key, simple_response in simple_responses.items():
            if any(word in search_key for word in key.split()):
                response = f"📊 **Kebutuhan Kalori Harian**\n\n{simple_response}\n\n"
                response += "💡 *Data perkiraan - untuk konsultasi detail hubungi ahli gizi*"
                dispatcher.utter_message(text=response)
                return []
        
        # Default fallback
        dispatcher.utter_message(
            text="❌ Data kebutuhan kalori untuk kategori tersebut tidak ditemukan.\n\n"
                 "📋 **Kategori yang tersedia:**\n"
                 "• Dewasa (Pria/Wanita) • Remaja (Pria/Wanita)\n"
                 "• Anak-anak • Lansia (Pria/Wanita)\n"
                 "• Ibu Hamil • Ibu Menyusui • Atlet\n\n"
                 "Coba dengan: 'kebutuhan kalori wanita dewasa'"
        )
        return []

class ActionFallback(Action):
    """Default fallback action"""
    
    def name(self) -> Text:
        return "action_default_fallback"
    
    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        
        dispatcher.utter_message(
            text="🤖 **Halo! Saya NutriBot** 🍎\n\n"
                 "Saya bisa membantu dengan:\n\n"
                 "🍎 **Informasi gizi produk**\n"
                 "   *Contoh: 'berapa kalori teh botol sosro?'*\n\n"
                 "📊 **Kebutuhan kalori harian**\n"
                 "   *Contoh: 'kalori harian wanita dewasa'*\n\n"
                 "💡 **Tips hidup sehat**\n"
                 "🥗 **Rekomendasi makanan sehat**\n\n"
                 "Silakan tanya dengan lebih spesifik! 😊"
        )
        return []

class ActionGreeting(Action):
    """Custom greeting action"""
    
    def name(self) -> Text:
        return "action_greeting"
    
    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        
        dispatcher.utter_message(
            text="🤖 **Halo! Selamat datang di NutriBot!** 🍎\n\n"
                 "Saya siap membantu Anda dengan informasi nutrisi dan kesehatan.\n\n"
                 "🔍 **Yang bisa saya bantu:**\n"
                 "• Info gizi produk makanan/minuman\n"
                 "• Kebutuhan kalori harian\n"
                 "• Tips hidup sehat\n\n"
                 "Apa yang ingin Anda tanyakan? 😊"
        )
        return []