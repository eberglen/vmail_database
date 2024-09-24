insert into public.role_permissions (role_id, permission)
values
   ((SELECT id FROM roles WHERE role_name = 'admin'), 'user_tokens.select');