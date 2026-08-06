--1.Which market segment generates the highest
--revenue?
SELECT
    market_segment,
    SUM(adr) AS TotalRevenue
FROM
    [Hotel Bookings - Edikan Onyekachukwu]
GROUP BY
    market_segment
ORDER BY
    TotalRevenue DESC;

    --2.What is the average lead time for bookings?--
SELECT
    AVG(CAST(DATEDIFF(DAY, booking_changes, arrival_date_week_number) AS FLOAT)) AS AverageLeadTime
FROM
    [Hotel Bookings - Edikan Onyekachukwu];

--3.Which room types have the highest cancellation rates?--
SELECT 
  room_type,
  COUNT(*) AS total_bookings,
  SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) AS cancelled_bookings,
  (SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS cancellation_rate
FROM ([Hotel Bookings - Edikan Onyekachukwu],
  SELECT reserved_room_type AS room_type, is_canceled FROM [Hotel Bookings - Edikan Onyekachukwu]
  UNION ALL
  SELECT assigned_room_type AS room_type, is_canceled FROM [Hotel Bookings - Edikan Onyekachukwu]
) AS room_types
GROUP BY room_type
ORDER BY cancellation_rate DESC;

--4.How many bookings were made per market segment?--
SELECT 
    market_segment,
COUNT (*) AS total_bookings 
FROM
    [Hotel Bookings - Edikan Onyekachukwu]
GROUP BY 
    market_segment
ORDER BY 
    total_bookings DESC;
    
--5.What is the distribution of bookings across customer types?--
SELECT
    customer_type,
COUNT (*) AS distribution_of_bookings
FROM 
    [Hotel Bookings - Edikan Onyekachukwu]
GROUP BY 
    customer_type
ORDER BY 
    distribution_of_bookings DESC;

--6.Which room types generate the highest revenue?-
SELECT 
  reserved_room_type AS room_type,
  SUM(adr * (stays_in_weekend_nights + stays_in_week_nights)) AS total_revenue
FROM 
    [Hotel Bookings - Edikan Onyekachukwu]
GROUP BY 
    reserved_room_type
UNION ALL
SELECT 
    assigned_room_type AS assigned_room_type,
  SUM(adr * (stays_in_weekend_nights + stays_in_week_nights)) AS total_revenue
FROM 
    [Hotel Bookings - Edikan Onyekachukwu]
GROUP BY 
    assigned_room_type, reserved_room_type
ORDER BY 
    total_revenue DESC;

    --7.During which seasons is the revenue highest?--
SELECT 
  CASE 
    WHEN [arrival_date_month] IN ('December', 'January', 'February') THEN 'Winter'
    WHEN [arrival_date_month] IN ('March', 'April', 'May') THEN 'Spring'
    WHEN [arrival_date_month] IN ('June', 'July', 'August') THEN 'Summer'
    ELSE 'Autumn'
  END AS season,
  SUM(adr * (stays_in_weekend_nights + stays_in_week_nights)) AS total_revenue
FROM [Hotel Bookings - Edikan Onyekachukwu]
WHERE is_canceled = 0
GROUP BY 
  CASE 
    WHEN [arrival_date_month] IN ('December', 'January', 'February') THEN 'Winter'
    WHEN [arrival_date_month] IN ('March', 'April', 'May') THEN 'Spring'
    WHEN [arrival_date_month] IN ('June', 'July', 'August') THEN 'Summer'
    ELSE 'Autumn'
  END
ORDER BY total_revenue DESC;

--8.Which countries have the most bookings?--
SELECT country,
COUNT (*) as total_bookings
FROM [Hotel Bookings - Edikan Onyekachukwu]
GROUP BY country
ORDER BY total_bookings DESC;

--9.What is the ratio of repeat customers versus new customers?--
--Update the table first--
UPDATE [Hotel Bookings - Edikan Onyekachukwu]
SET is_repeated_guest = CASE 
    WHEN market_segment = 'Barchavaluno' THEN 1 
    ELSE 0 
END

SELECT 
  SUM(CASE WHEN is_repeated_guest = 1 THEN 1 ELSE 0 END) / 
  SUM(CASE WHEN is_repeated_guest = 0 THEN 1 ELSE 0 END) AS repeat_to_new_ratio
FROM [Hotel Bookings - Edikan Onyekachukwu];
SELECT 
  CASE 
    WHEN SUM(CASE WHEN is_repeated_guest = 0 THEN 1 ELSE 0 END) = 0 THEN NULL
    ELSE SUM(CASE WHEN is_repeated_guest = 1 THEN 1 ELSE 0 END) / 
         SUM(CASE WHEN is_repeated_guest = 0 THEN 1 ELSE 0 END)
  END AS repeat_to_new_ratio
FROM [Hotel Bookings - Edikan Onyekachukwu];

--10.What are the monthly trends in booking numbers?--
SELECT 
  [arrival_date_month],
  COUNT(*) AS total_bookings
FROM 
    [Hotel Bookings - Edikan Onyekachukwu]
GROUP BY 
    [arrival_date_month]
ORDER BY 
    [arrival_date_month];
