REVOKE ALL ON public.tokens FROM authenticated, anon, public;

-- GRANT
-- SELECT
--   (id, name, email, company_id, created_at) on table public.tokens to authenticated;
--
-- GRANT
-- UPDATE
--   (name) on table public.tokens to authenticated;
--
-- GRANT DELETE ON TABLE public.tokens TO authenticated;
