INSERT INTO public.role_permissions (role_id, permission)
VALUES
   ((SELECT id FROM roles WHERE role_name = 'admin'), 'profiles.select.company');
   ((SELECT id FROM roles WHERE role_name = 'admin'), 'profiles.update.company');
