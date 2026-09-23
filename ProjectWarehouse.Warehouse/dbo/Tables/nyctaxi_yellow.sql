CREATE TABLE [dbo].[nyctaxi_yellow] (
    [vendor]                VARCHAR (50)  NULL,
    [tpep_pickup_datetime]  DATE          NULL,
    [tpep_dropoff_datetime] DATE          NULL,
    [pu_borough]            VARCHAR (100) NULL,
    [pu_zone]               VARCHAR (100) NULL,
    [do_borough]            VARCHAR (100) NULL,
    [do_zone]               VARCHAR (100) NULL,
    [payment_method]        VARCHAR (50)  NULL,
    [passenger_count]       INT           NULL,
    [trip_distance]         FLOAT (53)    NULL,
    [total_amount]          FLOAT (53)    NULL
);


GO