REVOKE ALL ON public.profiles FROM authenticated, anon, public;

GRANT SELECT ON TABLE public.profiles TO authenticated;



-- GRANT
-- SELECT
--   (email) on table public.users to authenticated;
--
-- GRANT
-- UPDATE
--   (name) on table public.users to authenticated;
--
-- GRANT DELETE ON TABLE public.users TO authenticated;
