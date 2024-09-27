REVOKE ALL ON public.profiles FROM authenticated, anon, public;

GRANT SELECT ON TABLE public.profiles TO authenticated;

GRANT UPDATE (role_id) ON TABLE public.profiles TO authenticated;


-- NO need for this for now, since we dont allow insert and delete from any user, insertion and deletion happens on trigger
-- theres no permission as well

-- GRANT
-- SELECT
--   (email) on table public.users to authenticated;
--
-- GRANT
-- UPDATE
--   (name) on table public.users to authenticated;
--
-- GRANT DELETE ON TABLE public.users TO authenticated;
