-- trips were totally made on September 18th 2019
SELECT count(*) FROM public.green_taxi_trip t 
where date(t.lpep_pickup_datetime) = '2019-09-18' and 
date(t.lpep_dropoff_datetime) = '2019-09-18';

-- Longest trip for each day
SELECT date(t.lpep_pickup_datetime) pickup_date FROM public.green_taxi_trip t 
order by t.trip_distance desc limit 1;

-- Three biggest pick up Boroughs
select "Borough", sum(total_amount) 
from green_taxi_trip 
left join taxi_zone_lookup on "PULocationID"="LocationID" 
where date(lpep_pickup_datetime) = '2019-09-18' 
group by "Borough" 
having sum(green_taxi_trip.total_amount) > 50000;

-- Largest tip
 select pu."Zone" pickup_zone, dro."Zone" dropoff_zone, green_taxi_trip.tip_amount 
 from green_taxi_trip
 left join taxi_zone_lookup pu on "PULocationID"="LocationID" 
 left join taxi_zone_lookup dro on "DOLocationID"=dro."LocationID" 
 where date(lpep_pickup_datetime) between '2019-09-01' and '2019-09-30' 
 and pu."Zone" = 'Astoria' order by green_taxi_trip.tip_amount desc limit 1;