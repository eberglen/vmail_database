REVOKE ALL ON public.user_tokens FROM authenticated, anon, public;

GRANT SELECT ON TABLE public.user_tokens TO authenticated;