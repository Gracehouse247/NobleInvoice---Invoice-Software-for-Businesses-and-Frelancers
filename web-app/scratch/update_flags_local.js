const emoji = require('country-flag-emoji');
const fs = require('fs');
const path = require('path');

const list = emoji.list;
// Filter out non-countries if necessary or just use the list
// The 'country-flag-emoji' returns an array of objects
const countryStrings = list.map(c => `'${c.emoji} ${c.name.replace(/'/g, "\\'")}'`);

const newCountriesCode = `const COUNTRIES = [\n  ${countryStrings.join(',\n  ')}\n];`;

const filePath = path.join(__dirname, '../src/components/onboarding/IdentityForm.tsx');
let content = fs.readFileSync(filePath, 'utf8');

const regex = /const COUNTRIES = \[[^\]]+\];/s;
if(regex.test(content)) {
    content = content.replace(regex, newCountriesCode);
    fs.writeFileSync(filePath, content);
    console.log('Updated countries with flags!');
} else {
    console.log('Regex did not match COUNTRIES array.');
}
