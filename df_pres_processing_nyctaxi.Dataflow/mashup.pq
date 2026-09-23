[StagingDefinition = [Kind = "FastCopy"]]
section Section1;
shared #"stg nyctaxi_yellow" = let
  Source = Fabric.Warehouse(null),
  Navigation = Source{[workspaceId = "8ae217f4-af82-422e-9ee4-635f8e4ee72a"]}[Data],
  #"Navigation 1" = Navigation{[warehouseId = "71562c05-cbff-4ea9-9398-e96718d54574"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Schema = "stg", Item = "nyctaxi_yellow"]}[Data],
  #"Removed columns" = Table.RemoveColumns(#"Navigation 2", {"RatecodeID", "store_and_fwd_flag", "fare_amount", "extra", "mta_tax", "tip_amount", "tolls_amount", "improvement_surcharge", "congestion_surcharge", "Airport_fee"}),
  #"Inserted conditional column" = Table.AddColumn(#"Removed columns", "vendor", each if [VendorID] = 1 then "Creative Mobilibe Technologies" else if [VendorID] = 2 then "VeriFone" else "unknow"),
  #"Reordered columns" = Table.ReorderColumns(#"Inserted conditional column", {"VendorID", "vendor", "tpep_pickup_datetime", "tpep_dropoff_datetime", "passenger_count", "trip_distance", "PULocationID", "DOLocationID", "payment_type", "total_amount", "cbd_congestion_fee"}),
  #"Removed columns 1" = Table.RemoveColumns(#"Reordered columns", {"VendorID", "cbd_congestion_fee"}),
  #"Inserted conditional column 1" = Table.AddColumn(#"Removed columns 1", "payment_method", each if [payment_type] = 1 then "Credit Card" else if [payment_type] = 2 then "Cash" else if [payment_type] = 3 then "No Charge" else if [payment_type] = 4 then "Dispute" else if [payment_type] = 5 then "Unknow" else if [payment_type] = 6 then "Voided Trip" else "Unknow"),
  #"Removed columns 2" = Table.RemoveColumns(#"Inserted conditional column 1", {"payment_type"}),
  #"Renamed columns" = Table.RenameColumns(#"Removed columns 2", {{"PULocationID", "pu_location_id"}, {"DOLocationID", "do_location_id"}}),
  #"Calculated date" = Table.TransformColumns(#"Renamed columns", {{"tpep_pickup_datetime", each DateTime.Date(_), type nullable date}, {"tpep_dropoff_datetime", each DateTime.Date(_), type nullable date}}),
  #"Changed column type" = Table.TransformColumnTypes(#"Calculated date", {{"vendor", type text}, {"payment_method", type text}})
in
  #"Changed column type";
shared #"stg taxi_zone_lookup" = let
  Source = Fabric.Warehouse(null),
  Navigation = Source{[workspaceId = "8ae217f4-af82-422e-9ee4-635f8e4ee72a"]}[Data],
  #"Navigation 1" = Navigation{[warehouseId = "71562c05-cbff-4ea9-9398-e96718d54574"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Schema = "stg", Item = "taxi_zone_lookup"]}[Data],
  #"Changed column type" = Table.TransformColumnTypes(#"Navigation 2", {{"LocationID", Int64.Type}})
in
  #"Changed column type";
shared Merge = let
  Source = Table.NestedJoin(#"stg nyctaxi_yellow", {"pu_location_id"}, #"stg taxi_zone_lookup", {"LocationID"}, "stg taxi_zone_lookup", JoinKind.LeftOuter),
  #"Expanded stg taxi_zone_lookup" = Table.ExpandTableColumn(Source, "stg taxi_zone_lookup", {"Borough", "Zone"}, {"Borough", "Zone"}),
  #"Reordered columns" = Table.ReorderColumns(#"Expanded stg taxi_zone_lookup", {"vendor", "tpep_pickup_datetime", "tpep_dropoff_datetime", "passenger_count", "trip_distance", "pu_location_id", "Borough", "Zone", "do_location_id", "total_amount", "payment_method"}),
  #"Renamed columns" = Table.RenameColumns(#"Reordered columns", {{"Borough", "pu_borough"}, {"Zone", "pu_zone"}}),
  #"Removed columns" = Table.RemoveColumns(#"Renamed columns", {"pu_location_id"})
in
  #"Removed columns";
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Merge (2)_DataDestination", IsNewTarget = false], Settings = [Kind = "Manual", AllowCreation = false, ColumnSettings = [Mappings = {[SourceColumnName = "vendor", DestinationColumnName = "vendor"], [SourceColumnName = "tpep_pickup_datetime", DestinationColumnName = "tpep_pickup_datetime"], [SourceColumnName = "tpep_dropoff_datetime", DestinationColumnName = "tpep_dropoff_datetime"], [SourceColumnName = "pu_borough", DestinationColumnName = "pu_borough"], [SourceColumnName = "pu_zone", DestinationColumnName = "pu_zone"], [SourceColumnName = "do_borough", DestinationColumnName = "do_borough"], [SourceColumnName = "do_zone", DestinationColumnName = "do_zone"], [SourceColumnName = "payment_method", DestinationColumnName = "payment_method"], [SourceColumnName = "passenger_count", DestinationColumnName = "passenger_count"], [SourceColumnName = "trip_distance", DestinationColumnName = "trip_distance"], [SourceColumnName = "total_amount", DestinationColumnName = "total_amount"]}], DynamicSchema = false, UpdateMethod = [Kind = "Append"], TypeSettings = [Kind = "Table"]]]}]
shared #"Merge (2)" = let
  Source = Table.NestedJoin(Merge, {"do_location_id"}, #"stg taxi_zone_lookup", {"LocationID"}, "stg taxi_zone_lookup", JoinKind.LeftOuter),
  #"Expanded stg taxi_zone_lookup" = Table.ExpandTableColumn(Source, "stg taxi_zone_lookup", {"Borough", "Zone"}, {"Borough", "Zone"}),
  #"Reordered columns" = Table.ReorderColumns(#"Expanded stg taxi_zone_lookup", {"vendor", "tpep_pickup_datetime", "tpep_dropoff_datetime", "passenger_count", "trip_distance", "pu_borough", "pu_zone", "do_location_id", "Borough", "Zone", "total_amount", "payment_method"}),
  #"Renamed columns" = Table.RenameColumns(#"Reordered columns", {{"Borough", "do_borough"}, {"Zone", "do_zone"}}),
  #"Removed columns" = Table.RemoveColumns(#"Renamed columns", {"do_location_id"}),
  #"Reordered columns 1" = Table.ReorderColumns(#"Removed columns", {"vendor", "tpep_pickup_datetime", "tpep_dropoff_datetime", "pu_borough", "pu_zone", "do_borough", "do_zone", "payment_method", "passenger_count", "trip_distance", "total_amount"})
in
  #"Reordered columns 1";
shared #"Merge (2)_DataDestination" = let
  Pattern = Fabric.Warehouse([CreateNavigationProperties = false, HierarchicalNavigation = true]),
  Navigation_1 = Pattern{[workspaceId = "8ae217f4-af82-422e-9ee4-635f8e4ee72a"]}[Data],
  Navigation_2 = Navigation_1{[warehouseId = "71562c05-cbff-4ea9-9398-e96718d54574"]}[Data],
  Navigation_3 = Navigation_2{[Schema = "dbo"]}[Data],
  TableNavigation = Navigation_3{[Name = "nyctaxi_yellow"]}[Data]
in
  TableNavigation;
