CREATE OR REPLACE FUNCTION sync_user_tokens(
    p_user_id UUID,
    p_token_ids UUID[]
) RETURNS VOID AS $$
BEGIN
    -- Insert new tokens
    INSERT INTO user_tokens (user_id, token_id)
    SELECT p_user_id, unnest(p_token_ids)
    ON CONFLICT (user_id, token_id) DO NOTHING;

    -- Delete tokens that are not in the provided list
    DELETE FROM user_tokens
    WHERE user_id = p_user_id
      AND token_id NOT IN (SELECT unnest(p_token_ids));
END;
$$ LANGUAGE plpgsql;
