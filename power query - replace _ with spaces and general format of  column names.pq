let
  Source = Sql.Database("xxxxxxxx-sql.database.windows.net", "xxxxx-db"), 
  TableNameStep = Source{[Schema = "DWH", Item = "TableName"]}[Data],
  /* ####### transform the column name replacing "_" underscore with " " spaces and tranform to proper case then removing the Desc word */
  Custom1 = Table.TransformColumnNames(
    TableNameStep, 
    (c as text) as text =>
      Text.TrimEnd(Text.Replace(Text.Proper(Text.Replace(c, "_", " ")), "Desc", ""))
  ), 

  /* ####### split he column name by space and save in a list then replace the words in the key of the dictionary by the value and combine it back*/
  
  Custom2 = Table.TransformColumnNames(
    Custom1, 
    (columnName as text) as text =>
      let
        _list         = Text.Split(columnName, " "), 
        _list_replace = List.ReplaceMatchingItems(_list, {{"St", "ST"}, {"Mspn", "MSPN"}})
      in
        _list_replace, 
    Text.Combine(_list_replace, " ")
  )
in
  Custom2
