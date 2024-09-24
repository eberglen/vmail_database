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
    -- Fetch the user's role and company_id from the profiles table
    SELECT p.role, p.company_id
    INTO user_record
    FROM public.profiles p
    WHERE p.user_id = (event->>'user_id')::uuid;  -- Use user_id here

    claims := event->'claims';

    -- Set the role and company_id claims
    claims := jsonb_set(claims, '{user_role}', to_jsonb(user_record.role));
    claims := jsonb_set(claims, '{company_id}', to_jsonb(user_record.company_id));

    -- Update the 'claims' object in the original event
    event := jsonb_set(event, '{claims}', claims);

    -- Return the modified or original event
    RETURN event;
END;
$$;
