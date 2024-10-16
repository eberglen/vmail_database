-- CREATE OR REPLACE FUNCTION update_user(
--     p_profile_id INTEGER,
--     p_token_ids UUID[],  -- Token IDs array
--     p_role_id INTEGER    -- Role ID
-- ) RETURNS VOID AS $$
-- BEGIN
--     IF NOT authorize('user_tokens.update.company') THEN
--         RAISE EXCEPTION 'Unauthorized to update user account';
--     END IF;
--
--     -- Insert new tokens only if p_token_ids is not NULL
--     IF p_token_ids IS NOT NULL THEN
--         INSERT INTO user_tokens (profile_id, token_id)
--         SELECT p_profile_id, unnest(p_token_ids)
--         ON CONFLICT (profile_id, token_id) DO NOTHING;
--
--         -- Delete tokens that are not in the provided list
--         DELETE FROM user_tokens
--         WHERE profile_id = p_profile_id
--           AND token_id NOT IN (SELECT unnest(p_token_ids));
--     END IF;
--
--     -- Update the role_id in profiles table only if p_role_id is not NULL
--     IF p_role_id IS NOT NULL THEN
--         UPDATE profiles
--         SET role_id = p_role_id
--         WHERE id = p_profile_id;
--     END IF;
-- END;
-- $$ LANGUAGE plpgsql SECURITY DEFINER;

DROP FUNCTION get_user_tokens();
CREATE OR REPLACE FUNCTION get_user_tokens()
RETURNS TABLE (
    value UUID,
    label TEXT
)
LANGUAGE sql
-- for now, allow security definer here, so  we can access t.name
SECURITY DEFINER
AS $$
    SELECT
        t.id as value,
        t.name as label
    FROM
        tokens t
    LEFT JOIN
        user_tokens ut ON ut.token_id = t.id
    WHERE
        -- If the user is an admin, show all users in the same company
        (
            (SELECT authorize('user_tokens.select.company'))
            AND (auth.jwt() ->> 'company_id')::UUID = t.company_id
        )
        OR
        -- If the user is not an admin, show only their own user data
        (
            (SELECT authorize('user_tokens.select.own'))
            AND (auth.jwt() ->> 'profile_id')::INTEGER = ut.profile_id
        )
    GROUP BY t.id;
$$;

