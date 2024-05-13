-- variabel Profits_calculated digunakan sebagai CTE (Common Table Expression)
-- dalam hal ini CTE akan memudahkan untuk membantu agar query SQL mudah untuk dipahami dan dapat membantu untuk mengurangi pengulangan kode
-- beberapa atribut/variabel yang digunakan adalah variabel yang mandatory table

-- Membuat Tabel Analisis
CREATE TABLE kimia_farma.analytics_table AS (
    WITH profits_calculated AS (
      SELECT
      ft.transaction_id,
      ft.date,
      ft.branch_id,
      kc.branch_name,
      kc.kota,
      kc.provinsi,
      kc.rating AS rating_cabang,
      ft.customer_name,
      ft.product_id,
      pr.product_name,
      pr.price AS actual_price,
      ft.discount_percentage,

      -- Menghitung Persentase Laba yang Diperoleh
      CASE
        WHEN pr.price <= 50000 THEN 0.10
        WHEN pr.price <= 100000 THEN 0.15
        WHEN pr.price <= 300000 THEN 0.20
        WHEN pr.price <= 500000 THEN 0.25
        ELSE 0.30
      END AS persentase_gross_laba,

      -- Menghitung Harga Setelah Memperoleh Diskon
      (pr.price - (pr.price * ft.discount_percentage)) AS nett_sales,

      -- Menghitung Keuntungan yang Diperoleh
      (pr.price * (1 - ft.discount_percentage)) *
      CASE
        WHEN pr.price <= 50000 THEN 0.10
        WHEN pr.price <= 100000 THEN 0.15
        WHEN pr.price <= 300000 THEN 0.20
        WHEN pr.price <= 500000 THEN 0.25
        ELSE 0.30
        END AS nett_profit,
        ft.rating AS rating_transaksi
        FROM
        kimia_farma.kf_final_transaction AS ft
        LEFT JOIN
        kimia_farma.kf_kantor_cabang AS kc ON ft.branch_id = kc.branch_id
        LEFT JOIN
        kimia_farma.kf_product AS pr ON ft.product_id = pr.product_id
    )
    SELECT *
    FROM profits_calculated
);

SELECT * 
FROM kimia_farma.analytics_table;