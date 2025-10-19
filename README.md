# Nutrition Chatbot - Indonesian Language

Chatbot asisten gizi berbahasa Indonesia menggunakan RASA dengan external NLU (BERT multilingual).

## Dataset

Dataset: `dataset_gizi.csv` berisi 650+ pasangan pertanyaan-jawaban dengan 13 intent:

1. **greeting** - Sapaan (Hai, Halo, Selamat pagi, dll)
2. **goodbye** - Perpisahan (Bye, Dadah, Sampai jumpa, dll)
3. **tanya_info_gizi_produk** - Info gizi produk tertentu
4. **tanya_kalori_harian** - Kebutuhan kalori harian
5. **tanya_rekomendasi_makanan** - Rekomendasi makanan sehat
6. **tanya_kandungan_zat** - Kandungan zat gizi (protein, gula, dll)
7. **tanya_porsi_makan** - Porsi makan yang tepat
8. **tanya_label_gizi** - Cara baca label gizi
9. **tanya_makanan_diet** - Makanan untuk diet tertentu
10. **tanya_efek_kesehatan** - Efek kesehatan dari makanan
11. **tanya_alternatif_makanan** - Alternatif makanan sehat
12. **tanya_waktu_makan** - Waktu makan yang tepat
13. **tanya_tips_hidup_sehat** - Tips hidup sehat

## Arsitektur

```
User Input (Indonesian)
    ↓
RASA Chatbot
    ↓
NLUCommandAdapter → External NLU Service (Port 3000)
                    - BERT Multilingual Model
                    - Intent Classification
                    - Response from dataset_gizi.csv
    ↓
Response to User
```

## Setup dan Instalasi

### 1. Train NLU Model

```bash
cd external-nlu-service
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
python train_nutrition_nlu_model.py
```

Model akan disimpan di folder `nutrition_nlu_model/`

### 2. Start External NLU Service

```bash
cd external-nlu-service
venv\Scripts\activate
python nutrition_nlu_interpreter.py
```

Service akan berjalan di `http://localhost:3000`

### 3. Train RASA Model

```bash
cd rasa-project
python -m venv venv
venv\Scripts\activate
pip install rasa==3.6.13

# Train dengan config nutrition
rasa train --config config_nutrition.yml --domain domain_nutrition.yml --data data/nlu_nutrition.yml data/stories_nutrition.yml data/rules_nutrition.yml
```

### 4. Test Chatbot

```bash
cd rasa-project
venv\Scripts\activate
rasa shell
```

## Contoh Percakapan

```
Your input -> Halo
Bot: Halo! Ada yang bisa saya bantu terkait informasi gizi?

Your input -> Berapa kalori Teh Botol Sosro?
Bot: Teh Botol Sosro 350 ml mengandung ±140 kkal.

Your input -> Apa rekomendasi sarapan sehat?
Bot: Oatmeal dengan buah segar sangat bagus.

Your input -> Bye
Bot: Sampai jumpa! Tetap jaga kesehatan ya.
```

## File Penting

- `dataset_gizi.csv` - Dataset utama
- `external-nlu-service/train_nutrition_nlu_model.py` - Training script
- `external-nlu-service/nutrition_nlu_interpreter.py` - NLU service
- `rasa-project/domain_nutrition.yml` - Domain configuration
- `rasa-project/config_nutrition.yml` - Pipeline configuration
- `rasa-project/data/nlu_nutrition.yml` - NLU training data
- `rasa-project/data/stories_nutrition.yml` - Conversation flows
- `rasa-project/data/rules_nutrition.yml` - Rules

## Teknologi

- **RASA 3.6.13** - Chatbot framework
- **BERT Multilingual** - Intent classification
- **Python 3.10+** - Programming language
- **Flask** - Web framework for NLU service
- **PyTorch + Transformers** - Deep learning

## Catatan

- Model menggunakan BERT multilingual untuk mendukung Bahasa Indonesia
- Responses diambil langsung dari dataset_gizi.csv berdasarkan intent
- Tidak memerlukan database eksternal
- Tidak memerlukan custom actions RASA (responses dari NLU service)

## Author

Created for Tugas-2 RASA Customization
