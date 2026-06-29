const fs = require('fs');
const path = require('path');
const emoji = require('country-flag-emoji');

const list = emoji.list.map(c => `{ code: '${c.code}', name: '${c.name.replace(/'/g, "\\'")}' }`);
const newCountriesCode = `const COUNTRIES = [\n  ${list.join(',\n  ')}\n];`;

const filePath = path.join(__dirname, '../src/components/onboarding/IdentityForm.tsx');
let content = fs.readFileSync(filePath, 'utf8');

// replace COUNTRIES
const regex = /const COUNTRIES = \[[^\]]+\];/s;
content = content.replace(regex, newCountriesCode);

// replace <select> block for country
const oldSelectRegex = /<select[\s\S]*?<\/select>/s;
// We actually need to inject a CustomCountrySelect component at the top, and replace the select with it.

fs.writeFileSync(filePath, content);
console.log('updated countries payload');
