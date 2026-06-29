const fs = require('fs');
const path = require('path');

function walkAndReplace(dir) {
    const files = fs.readdirSync(dir);
    for (const file of files) {
        const fullPath = path.join(dir, file);
        if (fs.statSync(fullPath).isDirectory()) {
            walkAndReplace(fullPath);
        } else if (fullPath.endsWith('.tsx') || fullPath.endsWith('.ts') || fullPath.endsWith('.jsx') || fullPath.endsWith('.js')) {
            let content = fs.readFileSync(fullPath, 'utf8');
            if (content.includes('/images/logo.png?v=')) {
                content = content.replace(/\/images\/logo\.png\?v=\d+/g, '/images/logo.png');
                fs.writeFileSync(fullPath, content);
                console.log('Reverted', fullPath);
            }
        }
    }
}
walkAndReplace(path.join(__dirname, '../src'));
