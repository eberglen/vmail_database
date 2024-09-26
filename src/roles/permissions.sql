REVOKE ALL ON public.roles FROM authenticated, anon, public;

GRANT SELECT ON TABLE public.roles TO authenticated;