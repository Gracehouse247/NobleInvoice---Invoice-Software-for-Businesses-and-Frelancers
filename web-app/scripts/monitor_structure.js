const fs = require('fs');
const path = require('path');

const MAX_LINES = 600;
const IGNORE_DIRS = ['node_modules', '.next', '.git', 'dist', 'build'];
const EXTENSIONS = ['.ts', '.tsx', '.js', '.jsx'];

let totalFiles = 0;
let errors = 0;

function checkDir(dir) {
    const files = fs.readdirSync(dir);

    files.forEach(file => {
        const fullPath = path.join(dir, file);
        const stats = fs.statSync(fullPath);

        if (stats.isDirectory()) {
            if (!IGNORE_DIRS.includes(file)) {
                checkDir(fullPath);
            }
        } else if (EXTENSIONS.includes(path.extname(file))) {
            totalFiles++;
            const content = fs.readFileSync(fullPath, 'utf8');
            const lines = content.split('\n').length;

            if (lines > MAX_LINES) {
                console.error(`❌ [FAILURE] ${fullPath} is too large: ${lines} lines (Max: ${MAX_LINES})`);
                errors++;
            }
        }
    });
}

console.log('--- NOBLEMIND MODULAR STRUCTURE AUDIT ---');
console.log('Scanning src/ directory...');

try {
    checkDir(path.join(__dirname, '../src'));
    console.log(`\nScan complete. Checked ${totalFiles} files.`);
    
    if (errors > 0) {
        console.error(`\n🚨 Found ${errors} files exceeding the 600-line limit. Refactor required!`);
        process.exit(1);
    } else {
        console.log('\n✅ Quality Audit Passed. All files are modular and maintainable.');
        process.exit(0);
    }
} catch (err) {
    console.error('Audit failed to run:', err.message);
    process.exit(1);
}
