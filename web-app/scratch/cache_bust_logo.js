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
            if (content.includes('/images/logo.png')) {
                // replace /images/logo.png but avoid doubling up if it already has ?v=
                content = content.replace(/\/images\/logo\.png(\?v=\d+)?/g, '/images/logo.png?v=' + Date.now());
                fs.writeFileSync(fullPath, content);
                console.log('Updated', fullPath);
            }
        }
    }
}
walkAndReplace(path.join(__dirname, '../src'));
