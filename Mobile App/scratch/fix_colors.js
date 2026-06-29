const fs = require('fs');
const path = require('path');

function walk(dir) {
    let results = [];
    const list = fs.readdirSync(dir);
    list.forEach(file => {
        file = path.resolve(dir, file);
        const stat = fs.statSync(file);
        if (stat && stat.isDirectory()) {
            results = results.concat(walk(file));
        } else {
            if (file.endsWith('.dart')) results.push(file);
        }
    });
    return results;
}

const files = walk('lib');
files.forEach(file => {
    let content = fs.readFileSync(file, 'utf8');
    const pattern = /withValues\(alpha:\s*([^)]+)\)/g;
    const newContent = content.replace(pattern, 'withOpacity($1)');
    if (content !== newContent) {
        fs.writeFileSync(file, newContent);
        console.log(`Fixed: ${file}`);
    }
});
