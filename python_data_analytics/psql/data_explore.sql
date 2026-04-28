-- Show table schema 
\d+ retail;

-- Show first 10 rows
SELECT
    *
FROM
    retail
LIMIT
    10;

-- Check # of records
SELECT
    COUNT(invoice_no) AS '# of records'
FROM retail;

-- number of clients (e.g. unique client ID)
SELECT
    COUNT(DISTINCT customer_id)
FROM
    retail;

-- invoice of clients (e.g. unique client ID)
SELECT
    MAX(invoice_date) AS max,
    MIN(invoice_date) AS min
FROM
    retail;

-- number of SKU/merchants (e.g. unique stock code)
SELECT
    COUNT(DISTINCT stock_code)
FROM
    retail;

-- Calculate average invoice amount excluding invoices with a negative amount (e.g. canceled orders have negative amount)
SELECT
    AVG(invoice_amount) AS avg_invoice_amount
FROM
    (
        SELECT
            SUM(quantity * unit_price) AS invoice_amount
        FROM
            retail
        GROUP BY
            invoice_no
        HAVING
            SUM(quantity * unit_price) > 0
    ) t;

-- Calculate total revenue (e.g. sum of unit_price * quantity)
SELECT
    SUM(invoice_amount) AS avg_invoice_amount
FROM
    (
        SELECT
            SUM(quantity * unit_price) AS invoice_amount
        FROM
            retail
        GROUP BY
            invoice_no
    ) t;

-- Calculate total revenue by YYYYMM
SELECT
    TO_CHAR(invoice_date, 'YYYYMM') AS yyyymm,
    SUM(total_avenue)
FROM
    (
        SELECT
            invoice_date,
            SUM(unit_price * quantity) AS total_avenue
        FROM
            retail
        GROUP BY
            invoice_date
    ) t
GROUP BY
    TO_CHAR(invoice_date, 'YYYYMM')
ORDER BY
    yyyymm;

-- method 2: using EXTRACT()
SELECT
    (
        EXTRACT(
                YEAR
                FROM
                invoice_date
        ) * 100 + EXTRACT(
                MONTH
                FROM
                invoice_date
                  )
        ) AS yyyymm,
    SUM(total_avenue)
FROM
    (
        SELECT
            invoice_date,
            SUM(unit_price * quantity) AS total_avenue
        FROM
            retail
        GROUP BY
            invoice_date
    ) t
GROUP BY
    (
        EXTRACT(
                YEAR
                FROM
                invoice_date
        ) * 100 + EXTRACT(
                MONTH
                FROM
                invoice_date
                  )
        )
ORDER BY
    yyyymm;
