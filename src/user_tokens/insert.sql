insert into public.role_permissions (role_id, permission)
values
   ((SELECT id FROM roles WHERE role_name = 'admin'), 'user_tokens.select.company'),
   ((SELECT id FROM roles WHERE role_name = 'admin'), 'user_tokens.update.company'),
   ((SELECT id FROM roles WHERE role_name = 'admin'), 'user_tokens.delete.company'),
   ((SELECT id FROM roles WHERE role_name = 'admin'), 'user_tokens.insert.company'),
   ((SELECT id FROM roles WHERE role_name = 'moderator'), 'user_tokens.select.own');