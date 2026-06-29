import fs from 'fs';
import pdf from 'pdf-parse/lib/pdf-parse.js';

async function extractPDF() {
  try {
    const dataBuffer = fs.readFileSync('C:\\Projects\\NobleInvoice Web App Project\\SEO_Content_Strategy_Blueprint.pdf');
    const data = await pdf(dataBuffer);
    fs.writeFileSync('C:\\Projects\\NobleInvoice Web App Project\\SEO_Blueprint_content.txt', data.text, 'utf8');
    console.log('Extracted', data.text.length, 'characters');
  } catch(e) {
    console.error('Error:', e.message);
  }
}
extractPDF();
