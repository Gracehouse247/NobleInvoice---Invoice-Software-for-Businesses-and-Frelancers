const fs = require('fs');
const path = require('path');

function toSnakeCase(str) {
  return str.replace(/[A-Z]/g, function(letter) { return '_' + letter.toLowerCase(); }).replace(/^_/, '');
}

function splitFile(sourcePath, targetDir) {
  if (!fs.existsSync(sourcePath)) {
    console.log('File not found:', sourcePath);
    return;
  }
  
  const content = fs.readFileSync(sourcePath, 'utf8');
  const lines = content.split('\n');
  
  let imports = [];
  let lineIndex = 0;
  
  // Read imports
  while (lineIndex < lines.length) {
    let line = lines[lineIndex];
    if (line.startsWith('import ') || line.trim() === '' || line.startsWith('//')) {
      imports.push(line);
      lineIndex++;
    } else {
      break;
    }
  }
  
  let currentClass = '';
  let currentClassLines = [];
  let inClass = false;

  for (let i = lineIndex; i < lines.length; i++) {
    let line = lines[i];
    
    if (line.startsWith('class ') && line.includes('Template ')) {
      if (inClass && currentClass !== '') {
        saveClass(currentClass, currentClassLines, imports, targetDir);
      }
      inClass = true;
      currentClass = line.split(' ')[1];
      currentClassLines = [line];
    } else if (inClass) {
      currentClassLines.push(line);
    }
  }
  
  if (inClass && currentClass !== '') {
    saveClass(currentClass, currentClassLines, imports, targetDir);
  }
}

function saveClass(className, lines, imports, targetDir) {
  const fileName = toSnakeCase(className) + '.dart';
  const filePath = path.join(targetDir, fileName);
  
  const fileContent = imports.join('\n') + '\n\n' + lines.join('\n');
  fs.writeFileSync(filePath, fileContent);
  console.log('Saved', fileName);
}

splitFile('lib/features/invoicing/widgets/colorful_invoice_templates.dart', 'lib/core/pdf/components/colorful');
splitFile('lib/features/invoicing/widgets/premium_simple_templates.dart', 'lib/core/pdf/components/premium');
