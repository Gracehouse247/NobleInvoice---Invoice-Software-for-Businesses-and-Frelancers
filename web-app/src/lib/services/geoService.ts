// Service to fetch client geolocation and currency based on IP
// Free IP API: https://ipwhois.app/json/
export interface GeoInfo {
    ip: string;
    success: boolean;
    type: string;
    continent: string;
    continent_code: string;
    country: string;
    country_code: string;
    region: string;
    city: string;
    latitude: string;
    longitude: string;
    isp: string;
    org: string;
    as: string;
    currency: string; // e.g., "CAD"
    timezone: string;
    timezone_name: string;
    timezone_dst: string;
    timezone_gmt: string;
    currency_code: string; // duplicate
    currency_symbol: string;
    currency_rates: { [key: string]: number };
}

export const geoService = {
    async getClientGeo(): Promise<GeoInfo | null> {
        try {
            const resp = await fetch('https://ipwhois.app/json/');
            if (!resp.ok) return null;
            const data = await resp.json();
            if (data && data.success) return data as GeoInfo;
            return null;
        } catch (e) {
            console.error('Geo fetch error', e);
            return null;
        }
    }
};
