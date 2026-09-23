CREATE TABLE [stg].[nyctaxi_yellow] (
    [VendorID]              INT            NULL,
    [tpep_pickup_datetime]  DATETIME2 (6)  NULL,
    [tpep_dropoff_datetime] DATETIME2 (6)  NULL,
    [passenger_count]       BIGINT         NULL,
    [trip_distance]         FLOAT (53)     NULL,
    [RatecodeID]            BIGINT         NULL,
    [store_and_fwd_flag]    VARCHAR (8000) NULL,
    [PULocationID]          INT            NULL,
    [DOLocationID]          INT            NULL,
    [payment_type]          BIGINT         NULL,
    [fare_amount]           FLOAT (53)     NULL,
    [extra]                 FLOAT (53)     NULL,
    [mta_tax]               FLOAT (53)     NULL,
    [tip_amount]            FLOAT (53)     NULL,
    [tolls_amount]          FLOAT (53)     NULL,
    [improvement_surcharge] FLOAT (53)     NULL,
    [total_amount]          FLOAT (53)     NULL,
    [congestion_surcharge]  FLOAT (53)     NULL,
    [Airport_fee]           FLOAT (53)     NULL,
    [cbd_congestion_fee]    FLOAT (53)     NULL
);


GO