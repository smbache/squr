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
