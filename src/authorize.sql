create or replace function public.authorize(
  requested_permission app_permission
)
returns boolean as $$
declare
  bind_permissions int;
  user_role text;
begin
  -- Fetch user role once and store it to reduce number of calls
  select (auth.jwt() ->> 'user_role') into user_role;

  select count(*)
  into bind_permissions
  from public.role_permissions rp, public.roles r
  where rp.role_id = r.id
  and rp.permission = requested_permission
    and r.role_name = user_role;

  return bind_permissions > 0;
end;
$$ language plpgsql stable security definer set search_path = '';

