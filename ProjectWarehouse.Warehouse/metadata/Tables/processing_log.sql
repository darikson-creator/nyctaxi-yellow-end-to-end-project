CREATE TABLE [metadata].[processing_log] (
    [pipeline_run_id]         VARCHAR (255) NULL,
    [table_processed]         VARCHAR (255) NULL,
    [rows_processed]          INT           NULL,
    [latest_processed_pickup] DATETIME2 (6) NULL,
    [processed_datetime]      DATETIME2 (6) NULL
);


GO