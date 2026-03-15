-- =============================================
-- Amazon Sales Analytics
-- =============================================

-- 1. Products by Category
SELECT 
    LEFT(category, CHARINDEX('|', category + '|') - 1) AS MainCategory,
    COUNT(*) AS TotalProducts,
    AVG(rating) AS AvgRating,
    AVG(discounted_price) AS AvgPrice
FROM dbo.amazon_sales
GROUP BY LEFT(category, CHARINDEX('|', category + '|') - 1)
ORDER BY TotalProducts DESC;

-- 2. Top 10 Rated Products
SELECT TOP 10
    product_name,
    rating,
    rating_count,
    actual_price,
    discounted_price
FROM dbo.amazon_sales
WHERE rating IS NOT NULL
ORDER BY rating DESC;

-- 3. Discount Analysis
SELECT 
    product_name,
    actual_price,
    discounted_price,
    ROUND((actual_price - discounted_price) / actual_price * 100, 0) AS DiscountPercent
FROM dbo.amazon_sales
WHERE actual_price IS NOT NULL 
  AND discounted_price IS NOT NULL
ORDER BY DiscountPercent DESC;

-- =============================================
-- Views for Power BI
-- =============================================

-- 1. Category Analysis
CREATE VIEW vw_CategoryAnalysis AS
SELECT 
    LEFT(category, CHARINDEX('|', category + '|') - 1) AS MainCategory,
    COUNT(*) AS TotalProducts,
    AVG(rating) AS AvgRating,
    AVG(discounted_price) AS AvgDiscountedPrice,
    AVG(actual_price) AS AvgActualPrice
FROM dbo.amazon_sales
GROUP BY LEFT(category, CHARINDEX('|', category + '|') - 1);

-- 2. Top Products
CREATE VIEW vw_TopProducts AS
SELECT 
    product_name,
    LEFT(category, CHARINDEX('|', category + '|') - 1) AS MainCategory,
    actual_price,
    discounted_price,
    rating,
    rating_count
FROM dbo.amazon_sales
WHERE rating IS NOT NULL;

-- 3. Discount Analysis
CREATE VIEW vw_DiscountAnalysis AS
SELECT 
    product_name,
    LEFT(category, CHARINDEX('|', category + '|') - 1) AS MainCategory,
    actual_price,
    discounted_price,
    ROUND((actual_price - discounted_price) / actual_price * 100, 0) AS DiscountPercent
FROM dbo.amazon_sales
WHERE actual_price IS NOT NULL 
  AND discounted_price IS NOT NULL;
