const fs = require('fs');
const path = require('path');

const targetDir = path.join(__dirname, '../src');

function removeDarkModeClasses(dir) {
    let modifiedCount = 0;
    const files = fs.readdirSync(dir);

    for (const file of files) {
        const fullPath = path.join(dir, file);
        const stat = fs.statSync(fullPath);

        if (stat.isDirectory()) {
            modifiedCount += removeDarkModeClasses(fullPath);
        } else if (stat.isFile() && (fullPath.endsWith('.tsx') || fullPath.endsWith('.ts'))) {
            let content = fs.readFileSync(fullPath, 'utf8');
            // Regex to find and remove 'dark:some-class'
            // It matches 'dark:' followed by any valid tailwind class characters until a space, quote, or backtick
            const darkRegex = /\bdark:[a-zA-Z0-9\-\/\[\]_:]+\s?/g;
            
            if (darkRegex.test(content)) {
                content = content.replace(darkRegex, '');
                // Cleanup double spaces that might result from removal
                content = content.replace(/\s{2,}(["'`])/g, ' $1');
                content = content.replace(/(["'`])\s{2,}/g, '$1 ');
                
                fs.writeFileSync(fullPath, content, 'utf8');
                modifiedCount++;
                console.log(`Updated: ${fullPath}`);
            }
        }
    }
    return modifiedCount;
}

console.log('Starting dark mode removal...');
const count = removeDarkModeClasses(targetDir);
console.log(`\nComplete! Modified ${count} files.`);
