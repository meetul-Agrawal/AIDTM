use automobile;

/* 1. */
select *
from cars
where selling_price = (
	Select max(selling_price)
    from cars
    where transmission = 'Manual'
);

/* 2. */
SELECT fuel, SUM(km_driven) AS total_km_driven 
FROM cars 
GROUP BY fuel;

/* 3. */
SELECT transmission, AVG(selling_price) AS avg_selling_price 
FROM cars 
GROUP BY transmission;

/* 4. */
SELECT name, selling_price FROM cars
WHERE name IN (SELECT name FROM cars GROUP BY name HAVING COUNT(*) > 1);

/* 5. */
SELECT name, year, selling_price, RANK() OVER (PARTITION BY year ORDER BY selling_price DESC) AS price_rank
FROM cars;

/* 6. */
SELECT * FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY name ORDER BY year DESC) AS row_num
    FROM cars
) AS ranked
WHERE row_num = 1;

/* 7. */
SELECT name, year, selling_price,
       AVG(selling_price) OVER (PARTITION BY name ORDER BY year ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS exp_moving_avg
FROM cars;

/* 8. */
SELECT name, selling_price
FROM cars
WHERE ABS(selling_price - (SELECT AVG(selling_price) FROM cars)) <= 2 * (SELECT STDDEV(selling_price) FROM cars);

/* 9. */
SELECT name, selling_price,
       CUME_DIST() OVER (PARTITION BY name ORDER BY selling_price) AS cumulative_distribution
FROM cars;

/* 10. */
SELECT year, name, selling_price
FROM (
    SELECT year, name, selling_price,
           ROW_NUMBER() OVER (PARTITION BY year ORDER BY selling_price DESC) AS price_rank
    FROM cars
) ranked
WHERE price_rank <= 3;

/* 11. */
SELECT name, SUM(selling_price * km_driven) / SUM(km_driven) AS weighted_avg_price
FROM cars
GROUP BY name;

/* 12. */
SELECT name, year, selling_price,
       AVG(selling_price) OVER (PARTITION BY name ORDER BY year ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS exp_moving_avg
FROM cars;

/* 13. */
SELECT name,
       ((MAX(selling_price) - MIN(selling_price)) / MIN(selling_price)) * 100 AS growth_rate
FROM cars
WHERE year >= YEAR(CURRENT_DATE) - 3
GROUP BY name
ORDER BY growth_rate DESC
LIMIT 5;

/* 14. */
SELECT fuel, transmission, name, selling_price
FROM (
    SELECT fuel, transmission, name, selling_price,
           ROW_NUMBER() OVER (PARTITION BY fuel, transmission ORDER BY selling_price DESC) AS price_rank
    FROM cars
) ranked
WHERE price_rank = 1;