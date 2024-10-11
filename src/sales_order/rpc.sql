CREATE OR REPLACE FUNCTION insert_sales_order_and_threads(
    p_name TEXT,
    p_order_number TEXT,
    p_status TEXT,
    p_total_amount DECIMAL,
    p_order_date DATE,
    p_notes TEXT,
    p_sales_threads JSONB, -- JSON array containing thread information
    p_assigned_to INTEGER -- Added assigned_to as an integer
)
RETURNS INTEGER AS $$
DECLARE
    v_sales_order_id INTEGER; -- Variable to store the newly inserted sales_order ID
    v_thread JSONB; -- Change to JSONB for direct handling
BEGIN
    -- Authorization check
    IF NOT authorize('sales_orders.insert.company') THEN
        RAISE EXCEPTION 'Unauthorized access';
    END IF;

    -- Insert into sales_orders table
    INSERT INTO sales_orders (company_id, name, order_number, status, total_amount, order_date, notes, assigned_to) -- Added assigned_to
    VALUES (
        (auth.jwt() ->> 'company_id')::UUID, -- Source company_id from JWT token
        p_name,
        p_order_number,
        p_status,
        p_total_amount,
        p_order_date,
        p_notes,
        p_assigned_to -- Include assigned_to in the insert
    )
    RETURNING id INTO v_sales_order_id;

    -- Loop through each thread in the JSONB array and insert into sales_threads table
    FOR v_thread IN SELECT * FROM jsonb_array_elements(p_sales_threads) LOOP
        INSERT INTO sales_threads (
            sales_order_id,
            thread_id,
            token_id,
            type,
            subject
        )
        VALUES (
            v_sales_order_id,
            (v_thread->>'thread_id')::TEXT,
            (v_thread->>'token_id')::UUID,    -- Cast to UUID
            (v_thread->>'type')::sales_thread_type, -- Ensure this matches the enum type
            v_thread->>'subject'::TEXT         -- Cast to TEXT
        );
    END LOOP;

    -- Return the sales_order_id
    RETURN v_sales_order_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;



CREATE OR REPLACE FUNCTION get_sales_orders(p_last_id INTEGER)
RETURNS TABLE (
    id INTEGER,
    order_number TEXT,
    name TEXT,
    status TEXT,
    total_amount DECIMAL,
    order_date DATE,
    notes TEXT,
    assigned_to INTEGER, -- Added assigned_to field
    sales_threads JSONB -- Added sales_threads as an aggregated JSON array
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    -- Authorization check
    IF NOT authorize('sales_orders.select.company') THEN
        RAISE EXCEPTION 'Unauthorized access';
    END IF;

    RETURN QUERY
    SELECT
        so.id,
        so.order_number,
        so.name,
        so.status,
        so.total_amount,
        so.order_date,
        so.notes,
        so.assigned_to,
        COALESCE(
            (
                SELECT jsonb_agg(jsonb_build_object(
                    'id', st.id,
                    'thread_id', st.thread_id,
                    'token_id', st.token_id,
                    'type', st.type,
                    'subject', st.subject
                ))
                FROM sales_threads st
                WHERE st.sales_order_id = so.id
            ), '[]'::jsonb
        ) AS sales_threads
    FROM
        sales_orders so
    WHERE
        (auth.jwt() ->> 'company_id')::UUID = so.company_id
        -- Add condition to fetch records greater than the last fetched id for pagination
        AND (p_last_id IS NULL OR so.id < p_last_id)
    ORDER BY so.id DESC -- Fetch newer records based on serial id
    LIMIT 10; -- Fixed limit of 10 records
END;
$$;



CREATE OR REPLACE FUNCTION update_sales_order(
    order_id INTEGER,
    updated_fields JSONB,
    added_sales_thread JSONB, -- JSONB for the added sales thread
    removed_sales_thread INTEGER[] -- INTEGER[] for the removed sales thread
) RETURNS INTEGER[] AS $$
DECLARE
    field_name TEXT;
    field_value TEXT;
    allowed_fields TEXT[] := ARRAY['name', 'order_number', 'status', 'total_amount', 'notes', 'assigned_to', 'order_date']; -- Fields to allow for updates
    field_types JSONB := '{
        "name": "TEXT",
        "order_number": "TEXT",
        "status": "TEXT",
        "total_amount": "NUMERIC",
        "notes": "TEXT",
        "assigned_to": "INTEGER",
        "order_date": "DATE"
    }'::JSONB; -- Mapping of fields to their types
    v_thread JSONB; -- To hold each thread for insertion
    v_added_thread_id INTEGER; -- To hold the ID of the inserted sales thread
    added_thread_ids INTEGER[] := ARRAY[]::INTEGER[]; -- Initialize an empty array to collect added thread IDs
BEGIN
    -- Authorization check
    IF NOT authorize('sales_orders.update.company') THEN
        RAISE EXCEPTION 'Unauthorized access';
    END IF;

    -- Handle added sales threads
    IF added_sales_thread IS NOT NULL THEN
        FOR v_thread IN SELECT * FROM jsonb_array_elements(added_sales_thread) LOOP
            INSERT INTO sales_threads (
                sales_order_id,
                thread_id,
                token_id,
                type,
                subject
            )
            VALUES (
                order_id,
                (v_thread->>'thread_id')::TEXT,
                (v_thread->>'token_id')::UUID,
                (v_thread->>'type')::sales_thread_type,
                v_thread->>'subject'::TEXT
            )
            RETURNING id INTO v_added_thread_id; -- Get the ID of the inserted thread

            -- Append the added thread ID to the array
            added_thread_ids := array_append(added_thread_ids, v_added_thread_id);
        END LOOP;
    END IF;

    -- Handle removed sales threads
    IF removed_sales_thread IS NOT NULL THEN
        FOREACH field_value IN ARRAY removed_sales_thread LOOP
            DELETE FROM sales_threads
            WHERE id = field_value::integer AND sales_order_id = order_id
            AND (auth.jwt() ->> 'company_id')::UUID = (SELECT company_id FROM sales_orders WHERE id = order_id);
        END LOOP;
    END IF;

    -- Iterate over each key-value pair in the JSONB object for updating other fields
    FOR field_name, field_value IN SELECT * FROM jsonb_each_text(updated_fields) LOOP
        -- Check if the field is in the allowed fields list
        IF field_name = ANY(allowed_fields) THEN
            -- Determine the type to cast based on the field, default to TEXT if not specified
            EXECUTE format('
                UPDATE sales_orders AS so
                SET %I = $1::%s
                WHERE id = $2
                  AND (auth.jwt() ->> ''company_id'')::UUID = so.company_id',
                field_name, COALESCE(field_types->>field_name, 'TEXT')) -- Default to TEXT if not specified
            USING field_value, order_id;
        ELSE
            RAISE EXCEPTION 'Field % is not allowed for update', field_name;
        END IF;
    END LOOP;

    -- Return the added thread IDs as an array
    RETURN added_thread_ids; -- Return the array of added thread IDs
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


CREATE OR REPLACE FUNCTION delete_sales_order(order_id INTEGER)
RETURNS VOID AS $$
BEGIN
    -- Authorization check
    IF NOT authorize('sales_orders.delete.company') THEN
        RAISE EXCEPTION 'Unauthorized access';
    END IF;

    -- Delete the sales order (associated sales_threads will be deleted automatically due to ON DELETE CASCADE)
    DELETE FROM sales_orders
    WHERE id = order_id
    AND (auth.jwt() ->> 'company_id')::UUID = company_id;

    -- You could also add some logging or additional actions here if needed
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;





