import useSWR, { SWRConfiguration } from 'swr';
import { supabase } from '@/lib/supabase';

// Generic fetcher for Supabase queries
export const supabaseFetcher = async (queryFn: () => Promise<{ data: any; error: any }>) => {
  const { data, error } = await queryFn();
  if (error) {
    throw error;
  }
  return data;
};

/**
 * A custom hook to fetch data from Supabase using SWR for caching and revalidation.
 * 
 * @param key A unique string or array key for the query (e.g. ['invoices', userId])
 * @param queryFn A function that returns a Supabase query promise
 * @param options SWR configuration options
 */
export function useSupabaseQuery<T>(
  key: any,
  queryFn: (() => Promise<{ data: T | null; error: any }>) | null,
  options?: SWRConfiguration
) {
  // If queryFn is null, it won't fetch (useful for dependent fetching)
  const fetcher = queryFn ? () => supabaseFetcher(queryFn) : null;
  
  return useSWR<T>(key, fetcher, {
    revalidateOnFocus: true,
    revalidateIfStale: true,
    dedupingInterval: 5000,
    ...options
  });
}
