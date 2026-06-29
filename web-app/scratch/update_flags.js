const fs = require('fs');
const path = require('path');
const https = require('https');

async function updateCountries() {
    https.get('https://restcountries.com/v3.1/all?fields=name,flag', (res) => {
        let body = '';
        res.on('data', chunk => body += chunk);
        res.on('end', () => {
            try {
                const data = JSON.parse(body);
                if (!Array.isArray(data)) {
                    console.error('Data is not an array:', data);
                    return;
                }
                
                data.sort((a, b) => a.name.common.localeCompare(b.name.common));
                
                const countryStrings = data.map(c => `'${c.flag} ${c.name.common.replace(/'/g, "\\'")}'`);
                
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
            } catch (e) {
                console.error('Error parsing JSON:', e);
            }
        });
    }).on('error', (e) => {
        console.error('Request Error:', e);
    });
}

updateCountries();
