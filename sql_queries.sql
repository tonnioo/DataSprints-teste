--QUESITOS 
-- Qual a distância média percorrida por viagens com no máximo 2 passageiros?

SELECT AVG(trip_distance)
FROM
(SELECT trip_distance FROM `datasprintsteste.datasets.NYCTaxiTrips2009` 
WHERE passenger_count <= 2 
UNION ALL
SELECT trip_distance FROM `datasprintsteste.datasets.NYCTaxiTrips2010` 
WHERE passenger_count <= 2
UNION ALL
SELECT trip_distance FROM `datasprintsteste.datasets.NYCTaxiTrips2011` 
WHERE passenger_count <= 2
UNION ALL
SELECT trip_distance FROM `datasprintsteste.datasets.NYCTaxiTrips2012` 
WHERE passenger_count <= 2) 


-- Quais os 3 maiores Vendors em quantidade total de dinheiro arrecadado?


SELECT vendor_id, sum(total_amount) as total_revenue
FROM
(SELECT vendor_id,total_amount FROM `datasprintsteste.datasets.NYCTaxiTrips2009` 
UNION ALL
SELECT vendor_id,total_amount FROM `datasprintsteste.datasets.NYCTaxiTrips2010` 
UNION ALL
SELECT vendor_id,total_amount FROM `datasprintsteste.datasets.NYCTaxiTrips2011` 
UNION ALL
SELECT vendor_id,total_amount FROM `datasprintsteste.datasets.NYCTaxiTrips2012` ) AS NYCTaxiTrips
GROUP BY vendor_id
ORDER BY total_revenue DESC
LIMIT 3

-- Faça um histograma da distribuição mensal, nos 4 anos, de corridas pagas em dinheiro.

SELECT COUNT(string_field_1) AS frequency,
       EXTRACT(MONTH FROM pickup_datetime) AS month,
       EXTRACT(YEAR FROM pickup_datetime) AS year       
FROM
(SELECT *
FROM
( SELECT payment_type, pickup_datetime FROM `datasprintsteste.datasets.NYCTaxiTrips2009`
  UNION ALL
  SELECT payment_type, pickup_datetime FROM `datasprintsteste.datasets.NYCTaxiTrips2010`
  UNION ALL
  SELECT payment_type, pickup_datetime FROM `datasprintsteste.datasets.NYCTaxiTrips2011`
  UNION ALL
  SELECT payment_type, pickup_datetime FROM `datasprintsteste.datasets.NYCTaxiTrips2012`) AS NYCTaxiTrips
INNER JOIN 
(SELECT * FROM`datasprintsteste.datasets.PaymentLookup` WHERE string_field_1 = 'Cash') AS payment_lookup
ON NYCTaxiTrips.payment_type = payment_lookup.string_field_0)
GROUP BY month, year
ORDER BY year,month


-- Faça um gráfico de série temporal contando a quantidade de gorjetas de cada dia,nos últimos 3 meses de 2012.


SELECT SUM(tip_amount) AS tip_total,
       EXTRACT(MONTH FROM pickup_datetime) AS month,
       EXTRACT(DAY FROM pickup_datetime) AS day
FROM `datasprintsteste.datasets.NYCTaxiTrips2012`
WHERE EXTRACT(MONTH FROM pickup_datetime) >= 10
GROUP BY day,month
ORDER BY month,day




