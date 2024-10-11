ALTER TYPE public.app_permission ADD VALUE 'sales_orders.insert.company';
ALTER TYPE public.app_permission ADD VALUE 'sales_orders.select.company';
ALTER TYPE public.app_permission ADD VALUE 'sales_orders.update.company';
ALTER TYPE public.app_permission ADD VALUE 'sales_orders.delete.company';

INSERT INTO public.role_permissions (role_id, permission)
VALUES
   ((SELECT id FROM roles WHERE role_name = 'admin'), 'sales_orders.insert.company'),
   ((SELECT id FROM roles WHERE role_name = 'admin'), 'sales_orders.select.company'),
   ((SELECT id FROM roles WHERE role_name = 'admin'), 'sales_orders.update.company');
   ((SELECT id FROM roles WHERE role_name = 'admin'), 'sales_orders.delete.company');


