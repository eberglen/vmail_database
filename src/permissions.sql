revoke execute on all functions in schema public from public, anon, authenticated;

GRANT EXECUTE ON FUNCTION public.authorize to authenticated;

GRANT EXECUTE ON FUNCTION public.get_user_info to authenticated;

GRANT EXECUTE ON FUNCTION public.update_user to authenticated;

GRANT EXECUTE ON FUNCTION public.get_contacts to authenticated;

GRANT EXECUTE ON FUNCTION public.fetch_role_options to authenticated;

GRANT EXECUTE ON FUNCTION public.insert_sales_order_and_threads to authenticated;

GRANT EXECUTE ON FUNCTION public.get_sales_orders to authenticated;

GRANT EXECUTE ON FUNCTION public.update_sales_order to authenticated;

GRANT EXECUTE ON FUNCTION public.delete_sales_order to authenticated;

GRANT EXECUTE ON FUNCTION public.get_email_accounts to authenticated;

GRANT EXECUTE ON FUNCTION public.update_email_account_name to authenticated;

GRANT EXECUTE ON FUNCTION public.delete_email_account to authenticated;

