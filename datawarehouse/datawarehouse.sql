-- Creating external table referring to gcs path
CREATE OR REPLACE EXTERNAL TABLE `ny_taxi.external_green_tripdata`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://datawarehouse-de/ny-taxi-data/green_tripdata_2022-*.parquet']
);

-- Count number of records
SELECT count(*) FROM `data-engineeing.ny_taxi.external_green_tripdata`;

-- Count distinct pickup locations
SELECT distinct count(PULocationID) FROM `data-engineeing.ny_taxi.external_green_tripdata`;

-- Count fare_amount
select count(fare_amount) from `data-engineeing.ny_taxi.external_green_tripdata` where fare_amount = 0;

-- materialized table
CREATE OR REPLACE TABLE `data-engineeing.ny_taxi.external_green_tripdata_non_partisan`
as
SELECT * FROM `data-engineeing.ny_taxi.external_green_tripdata`;

-- partition by pickup date cluster by location ID
CREATE OR REPLACE TABLE `data-engineeing.ny_taxi.external_green_tripdata_partitioned_clustered`
PARTITION BY DATE(lpep_pickup_datetime) 
CLUSTER BY PULocationID
AS
SELECT * FROM `data-engineeing.ny_taxi.external_green_tripdata`;

-- distinct pickup location non partisan
select distinct PULocationID from `data-engineeing.ny_taxi.external_green_tripdata_non_partisan`
where DATE(lpep_pickup_datetime) between '2022-06-01' AND '2022-06-30';

-- distinct pickup location non partitioned
select distinct PULocationID from `data-engineeing.ny_taxi.external_green_tripdata_partitioned_clustered`
where DATE(lpep_pickup_datetime) between '2022-06-01' AND '2022-06-30';