DROP FUNCTION get_user_info();
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
        -- If the user is an admin, show all users in the same company
        (
            SELECT authorize('profiles.select.company')
            AND p.company_id = (auth.jwt() ->> 'company_id')::UUID
        )
--         OR
--         -- If the user is not an admin, show only their own user data
--         (
--             (auth.jwt() ->> 'user_role')::TEXT != 'admin'
--             AND p.user_id = auth.uid()
--         )
    GROUP BY
        p.id
    ORDER BY
        p.id ASC;
$$;
