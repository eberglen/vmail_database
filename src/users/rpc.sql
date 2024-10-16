CREATE OR REPLACE FUNCTION get_user_info()
RETURNS TABLE (
    id INTEGER,
    auth_id UUID,
    display_name TEXT,
    tokens JSONB,
    auth_email TEXT,
    role_id TEXT,
    role_display_name TEXT
)
LANGUAGE sql
SECURITY DEFINER
AS $$
    SELECT
        p.id AS id,
        p.user_id AS auth_id,
        p.display_name,
        -- Aggregate user token details into an array of JSON objects
        COALESCE(
            jsonb_agg(
                jsonb_build_object(
                    'token_name', t.name,
                    'token_email', t.email,
                    'token_id', t.id
                )
            ) FILTER (WHERE t.id IS NOT NULL), '[]'::jsonb
        ) AS tokens,
        p.email AS auth_email,
        p.role_id,
        MAX(r.display_name) as role_display_name
    FROM
        profiles p
    LEFT JOIN
        user_tokens ut ON p.id = ut.profile_id
    LEFT JOIN
        tokens t ON ut.token_id = t.id
    LEFT JOIN
        roles r ON p.role_id = r.id
    WHERE
        (
            SELECT authorize('users.select.company')
            AND p.company_id = (auth.jwt() ->> 'company_id')::UUID
        )
    GROUP BY
        p.id
    ORDER BY
        p.id ASC;
$$;

CREATE OR REPLACE FUNCTION fetch_role_options()
RETURNS TABLE (
    value TEXT,
    label TEXT
)
LANGUAGE sql
SECURITY DEFINER
AS $$
    SELECT
        r.id::TEXT AS value,
        r.display_name AS label
    FROM
        roles r
    WHERE (SELECT authorize('users.select.company'))
    ORDER BY
        r.id ASC;
$$;

CREATE OR REPLACE FUNCTION update_user(
    p_profile_id INTEGER,
    p_token_ids UUID[],  -- Token IDs array
    p_role_id INTEGER    -- Role ID
) RETURNS VOID AS $$
BEGIN
    IF NOT authorize('users.update.company') THEN
        RAISE EXCEPTION 'Unauthorized to update user account';
    END IF;

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
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;