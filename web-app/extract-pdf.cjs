const fs = require('fs');
const pdf = require('pdf-parse');

const dataBuffer = fs.readFileSync('C:\\Projects\\NobleInvoice Web App Project\\SEO_Content_Strategy_Blueprint.pdf');
pdf(dataBuffer).then(function(data) {
    fs.writeFileSync('C:\\Projects\\NobleInvoice Web App Project\\SEO_Blueprint_content.txt', data.text, 'utf8');
}).catch(console.error);
