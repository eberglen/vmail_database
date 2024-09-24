INSERT INTO public.role_permissions (role_id, permission)
VALUES
   ((SELECT id FROM roles WHERE role_name = 'admin'), 'tokens.insert'),
   ((SELECT id FROM roles WHERE role_name = 'admin'), 'tokens.select'),
   ((SELECT id FROM roles WHERE role_name = 'admin'), 'tokens.update'),
   ((SELECT id FROM roles WHERE role_name = 'admin'), 'tokens.delete');
