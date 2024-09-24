-- Create or replace the custom access token hook function
CREATE OR REPLACE FUNCTION public.custom_access_token_hook(event jsonb)
RETURNS jsonb
LANGUAGE plpgsql
STABLE
AS $$
DECLARE
    claims jsonb;
    user_record RECORD;
BEGIN
    -- Fetch the user's role, company_id, and profile_id from the profiles table
    SELECT r.role_name AS role, p.company_id, p.id AS profile_id
    INTO user_record
    FROM public.profiles p, public.roles r
    WHERE p.role_id = r.id
    AND p.user_id = (event->>'user_id')::uuid;  -- Use user_id here

    claims := event->'claims';

    -- Set the role, company_id, and profile_id claims
    claims := jsonb_set(claims, '{user_role}', to_jsonb(user_record.role));
    claims := jsonb_set(claims, '{company_id}', to_jsonb(user_record.company_id));
    claims := jsonb_set(claims, '{profile_id}', to_jsonb(user_record.profile_id));

    -- Update the 'claims' object in the original event
    event := jsonb_set(event, '{claims}', claims);

    -- Return the modified or original event
    RETURN event;
END;
$$;
