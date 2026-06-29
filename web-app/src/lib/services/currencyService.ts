// Free, no-auth exchange rate API (supports 160+ currencies including NGN)
const API_BASE_URL = 'https://open.er-api.com/v6/latest';

export interface ExchangeRates {
    [currencyCode: string]: number;
}

export const currencyService = {
    /**
     * Fetches exchange rates relative to the given base currency.
     * @param baseCurrency The 3-letter currency code (e.g. 'USD', 'NGN', 'EUR')
     * @returns A map of currency codes to their exchange rates relative to the base currency
     */
    async getExchangeRates(baseCurrency: string): Promise<ExchangeRates | null> {
        if (!baseCurrency) return null;
        
        try {
            // Added simple cache mechanism using sessionStorage to avoid rate limiting
            const cacheKey = `exchange_rates_${baseCurrency}`;
            const cached = typeof window !== 'undefined' ? sessionStorage.getItem(cacheKey) : null;
            
            if (cached) {
                const parsedCache = JSON.parse(cached);
                // Cache valid for 1 hour
                if (Date.now() - parsedCache.timestamp < 3600000) {
                    return parsedCache.rates;
                }
            }

            const response = await fetch(`${API_BASE_URL}/${baseCurrency.toUpperCase()}`);
            if (!response.ok) {
                throw new Error(`Failed to fetch rates: ${response.statusText}`);
            }

            const data = await response.json();
            
            if (data && data.rates) {
                if (typeof window !== 'undefined') {
                    sessionStorage.setItem(cacheKey, JSON.stringify({
                        timestamp: Date.now(),
                        rates: data.rates
                    }));
                }
                return data.rates;
            }
            return null;
        } catch (error) {
            console.error('[currencyService] Failed to fetch exchange rates:', error);
            return null;
        }
    },

    /**
     * Converts an amount from a foreign currency to the base currency using the provided rates.
     * @param amount The numerical amount
     * @param fromCurrency The currency code of the amount
     * @param baseCurrency The target currency code to convert to
     * @param rates The exchange rate map fetched via getExchangeRates
     */
    convert(amount: number, fromCurrency: string, baseCurrency: string, rates: ExchangeRates | null): number {
        if (!amount) return 0;
        
        const from = fromCurrency?.toUpperCase() || 'USD';
        const base = baseCurrency?.toUpperCase() || 'USD';
        
        if (from === base) return amount;
        if (!rates || !rates[from]) return amount; // Fallback to original if rates unavailable

        // getExchangeRates fetches rates relative to the baseCurrency
        // That means 1 baseCurrency = rates[from] fromCurrency
        // To get amount in baseCurrency, we divide the amount by rates[from]
        return amount / rates[from];
    },

    /**
     * Convert amount from one currency to another using exchange rates relative to a base currency.
     * @param amount The amount in the source currency
     * @param fromCurrency Source currency code
     * @param toCurrency Target currency code
     * @param rates Exchange rates object where each key is a currency code and value is the rate relative to the base currency (i.e., 1 base = rates[code] target)
     */
    convertBetween(amount: number, fromCurrency: string, toCurrency: string, rates: ExchangeRates | null): number {
        if (!rates) return amount;
        const from = fromCurrency?.toUpperCase();
        const to = toCurrency?.toUpperCase();
        if (from === to) return amount;
        const fromRate = rates[from];
        const toRate = rates[to];
        if (!fromRate || !toRate) return amount;
        // Convert to base currency first, then to target
        const amountInBase = amount / fromRate;
        return amountInBase * toRate;
    },

    /**
     * Returns the best locale string for a given currency code,
     * so that Intl.NumberFormat renders the native symbol (₦, $, £, €, ¥, etc.)
     * instead of the raw ISO code.
     */
    getLocaleForCurrency(code: string): string {
        const map: Record<string, string> = {
            NGN: 'en-NG', USD: 'en-US', GBP: 'en-GB', EUR: 'de-DE',
            CAD: 'en-CA', AUD: 'en-AU', INR: 'en-IN', JPY: 'ja-JP',
            ZAR: 'en-ZA', KES: 'en-KE', GHS: 'en-GH', UGX: 'en-UG',
            RWF: 'en-RW', TZS: 'en-TZ', XAF: 'fr-CM', XOF: 'fr-SN',
            EGP: 'ar-EG', MAD: 'ar-MA', BRL: 'pt-BR', CNY: 'zh-CN',
            KRW: 'ko-KR', MXN: 'es-MX', PHP: 'en-PH', SGD: 'en-SG',
            THB: 'th-TH', AED: 'ar-AE', SAR: 'ar-SA', CHF: 'de-CH',
            SEK: 'sv-SE', NOK: 'nb-NO', DKK: 'da-DK', PLN: 'pl-PL',
            CZK: 'cs-CZ', HUF: 'hu-HU', TRY: 'tr-TR', NZD: 'en-NZ',
            IDR: 'id-ID', MYR: 'ms-MY', COP: 'es-CO', ARS: 'es-AR',
            CLP: 'es-CL', PEN: 'es-PE', TWD: 'zh-TW', HKD: 'zh-HK',
        };
        return map[code?.toUpperCase()] || 'en-US';
    },

    /**
     * Extracts just the currency symbol from a currency code.
     * e.g. 'NGN' → '₦', 'USD' → '$', 'GBP' → '£', 'EUR' → '€'
     */
    getCurrencySymbol(code: string): string {
        const locale = currencyService.getLocaleForCurrency(code);
        try {
            return new Intl.NumberFormat(locale, {
                style: 'currency',
                currency: code?.toUpperCase() || 'USD',
                minimumFractionDigits: 0,
                maximumFractionDigits: 0,
            })
                .formatToParts(0)
                .find(part => part.type === 'currency')?.value || code;
        } catch {
            return code;
        }
    },

    /**
     * Locale-aware currency formatter.
     * Uses the correct locale for the currency so the native symbol is rendered.
     */
    format(amount: number, currencyCode: string, opts?: { compact?: boolean; decimals?: number }): string {
        try {
            const locale = currencyService.getLocaleForCurrency(currencyCode);
            const decimals = opts?.decimals ?? 0;
            if (opts?.compact) {
                return new Intl.NumberFormat(locale, {
                    style: 'currency',
                    currency: currencyCode?.toUpperCase() || 'USD',
                    notation: 'compact',
                    minimumFractionDigits: 0,
                    maximumFractionDigits: 1,
                }).format(amount);
            }
            return new Intl.NumberFormat(locale, {
                style: 'currency',
                currency: currencyCode?.toUpperCase() || 'USD',
                minimumFractionDigits: decimals,
                maximumFractionDigits: decimals,
            }).format(amount);
        } catch (e) {
            // Fallback for invalid currency codes
            return `${currencyCode || 'USD'} ${amount}`;
        }
    },
};
