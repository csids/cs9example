# CS9 Example

[Core Surveillance 9](https://www.csids.no/cs9/) ("cs9") is a free and open-source framework for real-time analysis and disease surveillance.

Read the introduction vignette [here](https://www.csids.no/cs9/articles/cs9.html) or run `help(package="cs9")`.

## Interactive Usage in Posit Studio/Workbench

If you are running this interactively in Posit Studio/Workbench, you need to set up your environment variables. Run the following command:

```r
usethis::edit_r_environ("project")
```

Then add these environment variables to the `.Renviron` file:

```
CS9_DBCONFIG_USER='yourusername'
CS9_DBCONFIG_PASSWORD='yourStrongPassword100'

CS9_AUTO=0
CS9_PATH='/cs9path'

CS9_DBCONFIG_ACCESS='config/anon'
CS9_DBCONFIG_DRIVER='PostgreSQL Unicode'
CS9_DBCONFIG_PORT='5432'

CS9_DBCONFIG_SSLMODE='no'
CS9_DBCONFIG_ROLE_CREATE_TABLE='yourusername'
CS9_DBCONFIG_SERVER='db'

CS9_DBCONFIG_SCHEMA_CONFIG='public'
CS9_DBCONFIG_DB_CONFIG='cs_interactive_config'

CS9_DBCONFIG_SCHEMA_ANON='public'
CS9_DBCONFIG_DB_ANON='cs_interactive_anon'
```

After adding these variables, restart your R session for the changes to take effect.
