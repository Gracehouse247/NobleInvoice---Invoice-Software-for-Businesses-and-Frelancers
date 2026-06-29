const fs = require('fs');
const path = require('path');

function createBarrel(dirPath, outputFile) {
  const files = fs.readdirSync(dirPath).filter(f => f.endsWith('.dart') && f !== 'index.dart');
  let exports = [];
  
  files.forEach(file => {
    exports.push("export '../../../core/pdf/components/" + path.basename(dirPath) + "/" + file + "';");
  });
  
  fs.writeFileSync(outputFile, exports.join('\n'));
  console.log('Created barrel:', outputFile);
}

createBarrel('lib/core/pdf/components/colorful', 'lib/features/invoicing/widgets/colorful_invoice_templates.dart');
createBarrel('lib/core/pdf/components/premium', 'lib/features/invoicing/widgets/premium_simple_templates.dart');
