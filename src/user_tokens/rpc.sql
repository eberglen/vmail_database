CREATE OR REPLACE FUNCTION update_user(
    p_profile_id INTEGER,
    p_token_ids UUID[],  -- Token IDs array
    p_role_id INTEGER    -- Role ID
) RETURNS VOID AS $$
BEGIN
    -- Insert new tokens only if p_token_ids is not NULL
    IF p_token_ids IS NOT NULL THEN
        INSERT INTO user_tokens (profile_id, token_id)
        SELECT p_profile_id, unnest(p_token_ids)
        ON CONFLICT (profile_id, token_id) DO NOTHING;

        -- Delete tokens that are not in the provided list
        DELETE FROM user_tokens
        WHERE profile_id = p_profile_id
          AND token_id NOT IN (SELECT unnest(p_token_ids));
    END IF;

    -- Update the role_id in profiles table only if p_role_id is not NULL
    IF p_role_id IS NOT NULL THEN
        UPDATE profiles
        SET role_id = p_role_id
        WHERE id = p_profile_id;
    END IF;

EXCEPTION
    -- Rollback the transaction if any error occurs
    WHEN OTHERS THEN
        RAISE;  -- Re-raise the error to inform the caller
END;
$$ LANGUAGE plpgsql;
