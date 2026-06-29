const fs = require('fs');
const path = require('path');

const targetDirs = [
    'src/app/(user)',
    'src/app/admin',
    'src/components/features',
    'src/components/layout',
];

const replacements = [
    // We must use regex with word boundaries to only match exact Tailwind classes
    // (?<!dark:)\b ensures we don't accidentally replace a class that already has a dark: prefix.
    { regex: /(?<!dark:|hover:|focus:)\btext-white\b(?!(\/|\]|-))/g, replacement: 'text-foreground dark:text-white' },
    { regex: /(?<!dark:|hover:|focus:)\btext-slate-300\b/g, replacement: 'text-slate-700 dark:text-slate-300' },
    { regex: /(?<!dark:|hover:|focus:)\btext-slate-400\b/g, replacement: 'text-slate-600 dark:text-slate-400' },
    { regex: /(?<!dark:|hover:|focus:)\bbg-white\/5\b/g, replacement: 'bg-black/5 dark:bg-white/5' },
    { regex: /(?<!dark:|hover:|focus:)\bborder-white\/5\b/g, replacement: 'border-black/5 dark:border-white/5' },
    { regex: /(?<!dark:|hover:|focus:)\bbg-white\/10\b/g, replacement: 'bg-black/10 dark:bg-white/10' },
    { regex: /(?<!dark:|hover:|focus:)\bborder-white\/10\b/g, replacement: 'border-black/10 dark:border-white/10' },
    { regex: /(?<!dark:|hover:|focus:)\bshadow-white\/5\b/g, replacement: 'shadow-black/5 dark:shadow-white/5' },
    // Handle specific hover cases to maintain interaction logic identically in dark, but adapt in light:
    { regex: /\bhover:text-white\b/g, replacement: 'hover:text-slate-900 dark:hover:text-white' },
    { regex: /\bhover:border-white\/50\b/g, replacement: 'hover:border-slate-800/50 dark:hover:border-white/50' },
    { regex: /\bhover:bg-white\/5\b/g, replacement: 'hover:bg-black/5 dark:hover:bg-white/5' },
    { regex: /\bhover:bg-white\/10\b/g, replacement: 'hover:bg-black/10 dark:hover:bg-white/10' },
];

function processDirectory(dir) {
    if (!fs.existsSync(dir)) return;
    const files = fs.readdirSync(dir);
    for (const file of files) {
        const fullPath = path.join(dir, file);
        const stat = fs.statSync(fullPath);
        if (stat.isDirectory()) {
            processDirectory(fullPath);
        } else if (fullPath.endsWith('.tsx') || fullPath.endsWith('.ts')) {
            processFile(fullPath);
        }
    }
}

function processFile(filePath) {
    let content = fs.readFileSync(filePath, 'utf8');
    let modified = false;

    for (const rule of replacements) {
        if (rule.regex.test(content)) {
            // reset regex state
            rule.regex.lastIndex = 0;
            content = content.replace(rule.regex, rule.replacement);
            modified = true;
        }
    }

    if (modified) {
        fs.writeFileSync(filePath, content, 'utf8');
        console.log(`Updated: ${filePath}`);
    }
}

console.log('Starting theme application...');
targetDirs.forEach(dir => processDirectory(path.join(process.cwd(), dir)));
console.log('Theme application complete!');
