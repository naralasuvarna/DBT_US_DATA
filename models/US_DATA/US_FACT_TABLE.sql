{{ config(pre_hook="truncate table {{source('DEVELOPER_DB','US_ACCIDENTS_DATA_RAW_STAGE')}}",
materialized='incremental') }}

select b.ADD_ID,z.DATE_ID,c.DORN_ID,d.RES_ID,
a.WIND_CHILL_F_ as WIND_CHILL,a.HUMIDITY_ as HUMIDITY,a.PRESSURE_IN_ as PRESSURE,a.VISIBILITY_MI_ as VISIBILITY,
a.WIND_DIRECTION as WIND_DIRECTION, a.WIND_SPEED_MPH_ as WIND_SPEED,
a.PRECIPITATION_IN_ as PRECIPITATION, a.WEATHER_CONDITION as WEATHER_CONDITION,count(a.ID) as No_of_Accidents
from "DEVELOPER_DB"."ANJALI_SCHEMA"."STAGE_US_DATA" as a

left outer join "DEVELOPER_DB"."ANJALI_SCHEMA"."US_ACCIDENTS_ADDRESS_DIM" b
on a.COUNTRY= b.COUNTRY and a.ZIPCODE= b.ZIPCODE and a.STATE=b.STATE
and a.COUNTY= b.COUNTY and a.CITY= b.CITY and a.STREET=b.STREET ----28,45,330
left outer join "DEVELOPER_DB"."ANJALI_SCHEMA"."US_ACCIDENTS_DORN_DIM" c
on a.SUNRISE_SUNSET=c.SUNRISE_SUNSET and a.CIVIL_TWILIGHT=c.CIVIL_TWILIGHT and
a.NAUTICAL_TWILIGHT=c.NAUTICAL_TWILIGHT and a.ASTRONOMICAL_TWILIGHT=c.ASTRONOMICAL_TWILIGHT

left outer join "DEVELOPER_DB"."ANJALI_SCHEMA"."US_ACCIDENTS_REASON_DIM" d
on a.AMENITY=d.AMENITY and a.BUMP=d.BUMP and a.CROSSING= d.CROSSING and a.GIVE_WAY=d.GIVE_WAY
and a.JUNCTION=d.JUNCTION and a.NO_EXIT=d.NO_EXIT and a.RAILWAY=d.RAILWAY
and a.ROUNDABOUT=d.ROUNDABOUT and a.STATION=d.STATION and a.STOP=d.STOP
and a.TRAFFIC_CALMING=d.TRAFFIC_CALMING and a.TRAFFIC_SIGNAL=d.TRAFFIC_SIGNAL and a.TURNING_LOOP=d.TURNING_LOOP


left outer join "DEVELOPER_DB"."ANJALI_SCHEMA"."US_CALENDER_DIM"  as z
on a.DATE_ID=z.DATE_ID
where a._MODIFIED=b.LOAD_TIME and a._MODIFIED=c.LOAD_TIME and a._MODIFIED=d.LOAD_TIME
group by z.DATE_ID,c.DORN_ID,d.RES_ID,b.ADD_ID,a.ID,a.SEVERITY,a.TEMPERATURE_F_,a.WIND_CHILL_F_,
a.HUMIDITY_,a.PRESSURE_IN_,a.VISIBILITY_MI_,a.WIND_DIRECTION,a.WIND_SPEED_MPH_,a.PRECIPITATION_IN_,a.WEATHER_CONDITION