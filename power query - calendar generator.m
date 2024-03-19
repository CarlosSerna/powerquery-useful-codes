(years_back as number, optional years_ahead as number) =>
  let
    Source = #table(
      type table [EndDate = date, StartDate = date], 
      {
        {
          if years_ahead <> null and years_ahead > 0 then
            Date.AddYears(Date.EndOfYear(Date.From(DateTime.LocalNow())), years_ahead)
          else
            Date.EndOfYear(Date.From(DateTime.LocalNow())), 
          Date.AddYears(Date.StartOfYear(Date.From(DateTime.LocalNow())), - years_back)
        }
      }
    ), 
    #"Added Custom" = Table.AddColumn(
      Source, 
      "Date", 
      each {Number.From([StartDate]) .. Number.From([EndDate])}
    ), 
    #"Expanded ListDates" = Table.ExpandListColumn(#"Added Custom", "Date"), 
    #"Changed Type" = Table.TransformColumnTypes(#"Expanded ListDates", {{"Date", type date}}), 
    #"Removed Columns" = Table.RemoveColumns(#"Changed Type", {"EndDate", "StartDate"}), 
    #"Inserted Year" = Table.AddColumn(
      #"Removed Columns", 
      "Year", 
      each Date.Year([Date]), 
      Int64.Type
    ), 
    #"Inserted Start of Year" = Table.AddColumn(
      #"Inserted Year", 
      "Start of Year", 
      each Date.StartOfYear([Date]), 
      type date
    ), 
    #"Inserted End of Year" = Table.AddColumn(
      #"Inserted Start of Year", 
      "End of Year", 
      each Date.EndOfYear([Date]), 
      type date
    ), 
    #"Inserted Month" = Table.AddColumn(
      #"Inserted End of Year", 
      "Month", 
      each Date.Month([Date]), 
      Int64.Type
    ), 
    #"Inserted Start of Month" = Table.AddColumn(
      #"Inserted Month", 
      "Start of Month", 
      each Date.StartOfMonth([Date]), 
      type date
    ), 
    #"Inserted End of Month" = Table.AddColumn(
      #"Inserted Start of Month", 
      "End of Month", 
      each Date.EndOfMonth([Date]), 
      type date
    ), 
    #"Inserted Month Name" = Table.AddColumn(
      #"Inserted End of Month", 
      "Month Name", 
      each Date.MonthName([Date]), 
      type text
    ), 
    #"Inserted Week of Year" = Table.AddColumn(
      #"Inserted Month Name", 
      "Week of Year", 
      each Date.WeekOfYear([Date]), 
      Int64.Type
    ), 
    #"Inserted Week of Month" = Table.AddColumn(
      #"Inserted Week of Year", 
      "Week of Month", 
      each Date.WeekOfMonth([Date]), 
      Int64.Type
    ), 
    #"Inserted Start of Week" = Table.AddColumn(
      #"Inserted Week of Month", 
      "Start of Week", 
      each Date.StartOfWeek([Date]), 
      type date
    ), 
    #"Inserted Day" = Table.AddColumn(
      #"Inserted Start of Week", 
      "Day", 
      each Date.Day([Date]), 
      Int64.Type
    ), 
    #"Inserted Day of Week" = Table.AddColumn(
      #"Inserted Day", 
      "Day of Week", 
      each Date.DayOfWeek([Date]), 
      Int64.Type
    ), 
    #"Inserted Day of Year" = Table.AddColumn(
      #"Inserted Day of Week", 
      "Day of Year", 
      each Date.DayOfYear([Date]), 
      Int64.Type
    ), 
    #"Inserted Day Name" = Table.AddColumn(
      #"Inserted Day of Year", 
      "Day Name", 
      each Date.DayOfWeekName([Date]), 
      type text
    ), 
    #"Inserted Year Month" = Table.AddColumn(
      #"Inserted Day Name", 
      "Year Month", 
      each Number.FromText(Text.Combine({Date.ToText([Date], "yyyy"), Date.ToText([Date], "MM")})), 
      Int64.Type
    ),
    #"Month Offset"= Table.AddColumn(
      #"Inserted Year Month",
      "Month Offset",
      each (([Year]-Date.Year(DateTime.LocalNow()))*12) + [Month] -  Date.Month(DateTime.LocalNow()),  
      Int64.Type
    )

in
    #"Month Offset"
