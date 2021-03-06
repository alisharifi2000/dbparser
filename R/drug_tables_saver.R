save_drug_sub <-
  function(con,
           df,
           table_name,
           save_table_only = FALSE,
           field.types = NULL,
           primary_key = NULL,
           foreign_key = "parent_key",
           ref_table = "drug(primary_key)") {
    # store drug sub_Table in db
    dbWriteTable(
      conn = con,
      value = df,
      name = table_name,
      field.types = field.types,
      overwrite = TRUE
    )
    if (!save_table_only) {
      # add primary key of drug table
      if (!is.null(primary_key)) {
        for (key in primary_key) {
          dbExecute(
            conn = con,
            statement = paste(
              "Alter table",
              table_name,
              "alter column",
              key,
              "varchar(255) NOT NULL;"
            )
          )
        }
        dbExecute(
          conn = con,
          statement = paste(
            "Alter table",
            table_name,
            "add primary key(",
            paste(primary_key, collapse = ","),
            ");"
          )
        )

      }
      # add foreign key of drug table
      if (!is.null(foreign_key)) {
        dbExecute(
          conn = con,
          statement = paste(
            "Alter table",
            table_name,
            "ADD CONSTRAINT",
            paste("FK_", table_name,
                  "_drug", sep = ""),
            paste(
              "FOREIGN KEY (",
              foreign_key,
              ") REFERENCES",
              ref_table,
              ";"
            )
          )
        )
      }

    }
  }
