REVOKE ALL ON public.tokens FROM authenticated, anon, public;

GRANT SELECT ON TABLE public.tokens TO authenticated;

GRANT UPDATE ON TABLE public.tokens TO authenticated;

GRANT DELETE ON TABLE public.tokens TO authenticated;

GRANT INSERT ON TABLE public.tokens TO authenticated;
