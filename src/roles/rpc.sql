CREATE OR REPLACE FUNCTION fetch_role_options()
RETURNS TABLE (
    value TEXT,
    label TEXT
)
LANGUAGE sql
AS $$
    SELECT
        r.id::TEXT AS value,
        r.display_name AS label
    FROM
        roles r
    ORDER BY
        r.id ASC;
$$;
