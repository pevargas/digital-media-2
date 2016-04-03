show columns from lightning_co;
show columns from zip_code_co;

SELECT event_id, DATE_FORMAT(STR_TO_DATE(begin_date, "%m/%d/%Y"), "%Y%m%d") AS begin_date, begin_time, deaths_direct, injuries_direct, damage_property_num, damage_crops_num, begin_location
FROM lightning_co
ORDER BY deaths_direct;

SELECT latitude, longitude, city
FROM zip_code_co
ORDER BY city;

SELECT city, AVG(latitude) AS latitude, AVG(longitude) AS longitude
FROM zip_code_co
GROUP BY city;

SELECT *
FROM lightning_co l
LEFT JOIN zip_code_co c ON l.begin_location = c.city
WHERE c.city IS NULL;

SELECT *
FROM lightning_co
WHERE begin_location = "(AFF)USAF ACDMY COLO";

SELECT *
FROM zip_code_co
ORDER BY COUNTY, CITY;

SELECT l.event_id, DATE_FORMAT(STR_TO_DATE(l.begin_date,"%m/%d/%Y"), "%Y%m%d") AS begin_date, l.begin_date AS display_date, l.begin_time, l.deaths_direct, l.injuries_direct, l.damage_property_num,
	l.damage_crops_num, c.city, AVG(c.latitude) AS latitude, AVG(c.longitude) AS longitude
FROM lightning_co l, zip_code_co c
WHERE l.begin_location = c.city AND l.begin_date IS NOT NULL
GROUP BY c.city
ORDER BY begin_date, begin_time;