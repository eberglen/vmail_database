CREATE OR REPLACE FUNCTION upsert_token(
  p_access_token TEXT,
  p_refresh_token TEXT,
  p_expires_in INTEGER,
  p_token_type TEXT,
  p_email TEXT,
  p_name TEXT,
  p_company_id UUID
)
RETURNS UUID AS $$  -- Change return type to UUID
DECLARE
  v_truncated_name TEXT;
  v_id UUID;
BEGIN
  -- Truncate name to 36 characters if it's longer
  v_truncated_name := LEFT(p_name, 36);

  -- Insert or update the token data
  INSERT INTO tokens (access_token, refresh_token, expires_in, token_type, email, name, company_id)
  VALUES (p_access_token, p_refresh_token, p_expires_in, p_token_type, p_email, v_truncated_name, p_company_id)
  ON CONFLICT (email, company_id)
  DO UPDATE SET
    access_token = EXCLUDED.access_token,
    refresh_token = EXCLUDED.refresh_token,
    expires_in = EXCLUDED.expires_in,
    token_type = EXCLUDED.token_type,
    -- Only update name if it is currently null
    name = COALESCE(NULLIF(tokens.name, ''), v_truncated_name)
  RETURNING id INTO v_id;  -- Return only the id of the upserted token

  RETURN v_id;  -- Return the id
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION get_email_accounts()
RETURNS TABLE (
    id UUID,
    name TEXT,
    email TEXT
)
LANGUAGE sql
SECURITY DEFINER
AS $$
    SELECT
        t.id,
        t.name,
        t.email
    FROM
        tokens t
    WHERE
        -- If the user is authorized for selecting by company, show all tokens in the same company
        (
            (SELECT authorize('tokens.select.company'))
            AND (auth.jwt() ->> 'company_id')::UUID = t.company_id
        )
    ORDER BY t.created_at DESC; -- Include all selected columns in GROUP BY
$$;

CREATE OR REPLACE FUNCTION update_email_account_name(
    p_token_id UUID,
    p_name TEXT
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    -- Check if the user is authorized to update the name column
    IF NOT authorize('tokens.update.company') THEN
        RAISE EXCEPTION 'Unauthorized to update email account';
    END IF;

    -- Update the token's name where the ID matches
    UPDATE tokens
    SET name = p_name
    WHERE id = p_token_id
    AND (auth.jwt() ->> 'company_id')::UUID = tokens.company_id;

    -- Optionally raise an exception if no rows are affected
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Token with ID % not found or you are not authorized', token_id;
    END IF;
END;
$$;

CREATE OR REPLACE FUNCTION delete_email_account(p_token_id UUID)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    ref_count INT;
BEGIN
    -- Check if the user is authorized to delete tokens
    IF NOT authorize('tokens.delete.company') THEN
        RAISE EXCEPTION 'Unauthorized to delete email account';
    END IF;

    -- Count the number of references in sales_threads
    SELECT COUNT(*)
    INTO ref_count
    FROM sales_threads
    WHERE token_id = p_token_id;

    -- If there are references, raise an exception
    IF ref_count > 0 THEN
        RAISE EXCEPTION 'Cannot delete token with ID % because it is referenced in % sales_threads', p_token_id, ref_count;
    END IF;

    -- Delete the token where the ID matches
    DELETE FROM tokens
    WHERE id = p_token_id
    AND (auth.jwt() ->> 'company_id')::UUID = tokens.company_id;

    -- Optionally raise an exception if no rows are affected
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Token with ID % not found or you are not authorized', p_token_id;
    END IF;
END;
$$;

