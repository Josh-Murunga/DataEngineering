-- Question 0

CREATE MATERIALIZED VIEW taxi_dropoff AS
    WITH t AS (
        SELECT MAX(tpep_dropoff_datetime) AS latest_dropoff_time
        FROM trip_data
    )
    SELECT taxi_zone.Zone as taxi_zone, latest_dropoff_time
    FROM t,
            trip_data
    JOIN taxi_zone
        ON trip_data.DOLocationID = taxi_zone.location_id
    WHERE trip_data.tpep_dropoff_datetime = t.latest_dropoff_time;

-- Question 1
CREATE MATERIALIZED VIEW trip_mv AS
SELECT
    tz1.zone AS pickup_zone,
    tz2.zone AS dropoff_zone,
    AVG(td.tpep_dropoff_datetime - td.tpep_pickup_datetime) AS avg_trip_time,
    MIN(td.tpep_dropoff_datetime - td.tpep_pickup_datetime) AS min_trip_time,
    MAX(td.tpep_dropoff_datetime - td.tpep_pickup_datetime) AS max_trip_time
FROM
    trip_data td
JOIN
    taxi_zone tz1 ON td.pulocationid = tz1.location_id
JOIN
    taxi_zone tz2 ON td.dolocationid = tz2.location_id
GROUP BY
    tz1.zone, tz2.zone;

-- Find the pair of taxi zones with the highest average trip time
SELECT
    pickup_zone,
    dropoff_zone,
    avg_trip_time
FROM
    trip_mv
ORDER BY
    avg_trip_time DESC
LIMIT 1;

-- Question 2
CREATE MATERIALIZED VIEW trip_mv_count AS
SELECT
    tz1.zone AS pickup_zone,
    tz2.zone AS dropoff_zone,
    AVG(td.tpep_dropoff_datetime - td.tpep_pickup_datetime) AS avg_trip_time,
    MIN(td.tpep_dropoff_datetime - td.tpep_pickup_datetime) AS min_trip_time,
    MAX(td.tpep_dropoff_datetime - td.tpep_pickup_datetime) AS max_trip_time,
    COUNT(*) AS trip_count
FROM
    trip_data td
JOIN
    taxi_zone tz1 ON td.pulocationid = tz1.location_id
JOIN
    taxi_zone tz2 ON td.dolocationid = tz2.location_id
GROUP BY
    tz1.zone, tz2.zone;

-- Find the pair of taxi zones with the highest average trip time and the number of trips

SELECT
    pickup_zone,
    dropoff_zone,
    avg_trip_time,
    trip_count
FROM
    trip_mv_count
ORDER BY
    avg_trip_time DESC
LIMIT 1;

-- Question 3
WITH t AS (
    SELECT
        MAX(tpep_pickup_datetime) AS latest_pickup_time
    FROM
        trip_data
)
SELECT
    tz.zone,
    COUNT(*) AS pickup_count
FROM
    trip_data td
JOIN
    taxi_zone tz ON td.pulocationid = tz.location_id
CROSS JOIN
    t
WHERE
    td.tpep_pickup_datetime >= t.latest_pickup_time - INTERVAL '17 hours'
GROUP BY
    tz.zone
ORDER BY
    pickup_count DESC
LIMIT 3;
