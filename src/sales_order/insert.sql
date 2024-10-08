ALTER TYPE public.app_permission ADD VALUE 'sales_orders.insert.company';

INSERT INTO public.role_permissions (role_id, permission)
VALUES
   ((SELECT id FROM roles WHERE role_name = 'admin'), 'sales_orders.insert.company');
