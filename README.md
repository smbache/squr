# squr [/'skju:əɹ/]: 
## Structured Query Utility for R

The `squr` (pronounced "skewer") package provides a set of tools
for managing structured query language (SQL) files in R projects.
It promotes the separation of logic and query scripts and eases the process
of reading, parameterizing, and composing SQL queries.

## Example

In the following example the `sql/query.sql` file is read and
parameterized, and sent.

```R
# Simple example of a query function wrapper. This part varies depending
# on database, drivers, etc, but needs only setup once.
rodbc <- function(query)
{
  ch <- RODBC::odbcDriverConnect("<connectionstring>")
  on.exit(RODBC::odbcClose(ch))
  RODBC::sqlQuery(query)
}

# Example of reading file, setting a parameter value, and sending the query,
# using the `sq_*` ("skew") functions.
result <- 
  sq_file("sql/query") %>% 
  sq_set(Param = value) %>%
  sq_send(with = rodbc)
```

The corresponding `query.sql` file could look something like:
```SQL
SELECT *
  FROM TheTable
 WHERE Param = @Param
```

## Separation of logic and SQL Files
It can be argued that it is good practice to keep query scripts separate
from R code, and `squr` aims at

* cleaner R source code,
* queries that (mostly) work as-is both in R and in your SQL IDE,
* easy composability and reusability of SQL blocks

To use a separate query from R:

```R
sql <- sq_file("path/query")
```

Note: 

* the `.sql` extension can be omitted,
* when packaged, the path is relative to the `inst` folder.

For the rare occation, there is also `sq_text`, which is the 
way to add inline SQL. Both `sq_file` and `sq_text` produces
S3 objects which are character types with an additional class
`sq` to enable a few methods (`print` and `+`).

## Insertion Blocks
`INSERT` statements can be constructed easily with `sq_insert`:
```R
# Use all column names as-is:
sq_insert(into = "TableName", data = the_data)

# Manually specify values:
sq_insert(into = "TableName", ~Foo, Bar = ~Baz , data = the_data)
```
Unnamed values will use its R name as column name.

It is also possible to use an "insert parameter" in a query, which is then 
set with `sq_set_insert`. These parameters are of the form `@Label:insert`:

```SQL
-- Suppose the SQL query in query.sql is:
BEGIN TRANSACTION;

DECLARE @Deleted INT

DELETE 
  FROM TheTable 
 WHERE Foo = @Foo

SELECT @Deleted = @@ROWCOUNT

@NewObs:insert

SELECT @Deleted AS Deleted
     , @@ROWCOUNT AS Inserted

COMMIT TRANSACTION;
```

Then the R code is, e.g.:
```R
result <-
  sq_file("sql/query") %>% 
  sq_set(Foo = Bar) %>% 
  sq_set_insert("NewObs", into = "TableName", data = the_data) %>% 
  sq_send(with = rodbc)
```

The default behaviour is to treat the `...` as *names* of values to insert.
To insert values directly/as-is use `I()` function:
```R
sq_insert("Table", colnames(the_data), Ten = I(10), data = head(the_data))
```

## Includes
Sometimes it is useful to be able to use the same SQL snippets in several queries, 
e.g. some Common Table Expressions (CTE) that are used several places. 
For this purpose one can use "include parameters" of the form `@Label:include` and
the `sq_set_include`. Example:
```SQL
-- shared.sql
;WITH SomeData AS 
(
  SELECT *
    FROM SomeTable
    WHERE This = @This
      AND That = @That
)
```

```SQL
-- specific.sql
SELECT *
  FROM OtherTable o
 INNER JOIN SomeTable s
    ON o.This = s.That
```

```R
sql <- 
  sq_file("specific") %>% 
  sq_set_include("shared") %>% 
  sq_set(This = this, That = that) 
```

## Transactions
When combining files and chunks then it can be useful to wrap them 
in a `TRANSACTION`. There's a small utility function for this:

```R
update <- sq_file("update")
insert <- sq_file("insert")

result <-
  sq_transaction(update, insert) %>% 
  sq_set(Param = value) %>% 
  sq_send(with = rodbc)
```

## Dynamic Table and Column Names
Since values are appropriately quoted, the default replacements
will not work for dynamically specifying e.g. column and table names.
However, you can use `sq_value` explicitely (this is the function used
internally to prepare a value for SQL):

```SQL
-- The SQL file
SELECT [Date]
     , [CustomerId]
     , [CustomerName]
     , @Feature
  FROM Customers
 WHERE Date BETWEEN @DateFrom AND @DateTo
```

```R
# R
result <- 
  sq_file("customers") %>% 
  sq_set(DateFrom = Sys.Date() - 10, 
         DateTo   = Sys.Date(), 
         Feature  = sq_value("Turnover", quote = "[")) %>% 
  sq_send(with = rodbc)
```

## SQL to be Ignored
To ignore certain parts of an SQL script in R, enclose it in 
`--rignore` and `--end`:

```SQL
--rignore
DECLARE @DateFrom DATE = '2016-01-01'
DECLARE @DateTo   DATE = '2016-06-30'
--end

SELECT *
  FROM Customers
 WHERE Date BETWEEN @DateFrom AND @DateTo
```

The above then is a complete working example in an SQL IDE, and the 
variable declarations are ignored in R.

## See also
A similar (but different) project for Clojure (with ports for some other languages) by @krisajenkins is [Yesql](https://github.com/krisajenkins/yesql).
