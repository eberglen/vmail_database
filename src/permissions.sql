revoke execute on all functions in schema public from public, anon, authenticated;

GRANT EXECUTE ON FUNCTION public.authorize to authenticated;

GRANT EXECUTE ON FUNCTION public.upsert_token to authenticated;