create procedure stg.data_cleaning_stg
@end_date datetime2,
@start_date datetime2
as
delete from stg.nyctaxi_yellow where tpep_pickup_datetime < @start_date or tpep_pickup_datetime > @end_date;

GO