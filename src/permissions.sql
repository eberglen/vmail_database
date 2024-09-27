revoke execute on all functions in schema public from public, anon, authenticated;

GRANT EXECUTE ON FUNCTION public.authorize to authenticated;

GRANT EXECUTE ON FUNCTION public.upsert_token to authenticated;

GRANT EXECUTE ON FUNCTION public.get_user_info to authenticated;

GRANT EXECUTE ON FUNCTION public.update_user to authenticated;

GRANT EXECUTE ON FUNCTION public.get_user_tokens to authenticated;