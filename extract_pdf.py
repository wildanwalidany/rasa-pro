import PyPDF2

pdf_path = "Tugas-2-RASA Customization.pdf"

with open(pdf_path, 'rb') as file:
    pdf_reader = PyPDF2.PdfReader(file)
    text = ""
    
    for page_num in range(len(pdf_reader.pages)):
        page = pdf_reader.pages[page_num]
        text += f"\n--- Page {page_num + 1} ---\n"
        text += page.extract_text()
    
    print(text)
