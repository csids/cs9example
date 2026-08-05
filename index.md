What’s inside

01

### Three tasks, each feeding the next

Download a MET Norway forecast per municipality, clean it into daily and
weekly series aggregated up to county and nation, then plot each county.
Every task’s output table is the next one’s input.

02

### An action and a data selector

The data selector runs once per plan and returns a named list read from
the database. The action takes that list plus its argset and does the
work: a table write, or a file on disk.

03

### Validated tables, complete skeletons

Two tables hold the raw and the cleaned weather, both checked by the
`csfmt_rts_data_v2` validators.
[`make_skeleton_date()`](https://niphr.github.io/cs9example/reference/make_skeleton_date.md)
lays out the full location-by-date grid first, so a gap stays a visible
row.
