{{ config(materialized='incremental',unique_key='ADD_ID') }}

with example_2 as

(select distinct CITY,_MODIFIED,COUNTRY, STATE, ZIPCODE, COUNTY, TIMEZONE, AIRPORT_CODE, STREET from {{source('DEVELOPER_DB','US_ACCIDENTS_DATA_RAW_STAGE')}}),

source_data1 as(
select concat('A-', cast(seq_add.nextval as varchar)) as ADD_ID,
CITY, COUNTRY, STATE, ZIPCODE, COUNTY, TIMEZONE, AIRPORT_CODE, STREET , _MODIFIED as LOAD_TIME from example_2 order by ADD_ID)

select ADD_ID,CITY, COUNTRY, STATE, ZIPCODE, COUNTY, TIMEZONE, AIRPORT_CODE, STREET, LOAD_TIME from source_data1