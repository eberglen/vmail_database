CREATE OR REPLACE FUNCTION sync_user_tokens(
    p_profile_id INTEGER,
    p_token_ids UUID[]
) RETURNS VOID AS $$
BEGIN
    -- Insert new tokens
    INSERT INTO user_tokens (profile_id, token_id)
    SELECT p_profile_id, unnest(p_token_ids)
    ON CONFLICT (profile_id, token_id) DO NOTHING;

    -- Delete tokens that are not in the provided list
    DELETE FROM user_tokens
    WHERE profile_id = p_profile_id
      AND token_id NOT IN (SELECT unnest(p_token_ids));
END;
$$ LANGUAGE plpgsql;
