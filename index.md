---
title: cs9example
---

<p class="cs-section">What's inside</p>

<div class="cs-cards">
<div class="cs-card"><div class="cs-card-num">01</div><h3>Three tasks, each feeding the next</h3><p>Download a MET Norway forecast per municipality, clean it into daily and weekly series aggregated up to county and nation, then plot each county. Every task's output table is the next one's input.</p></div>
<div class="cs-card"><div class="cs-card-num">02</div><h3>An action and a data selector</h3><p>The data selector runs once per plan and returns a named list read from the database. The action takes that list plus its argset and does the work: a table write, or a file on disk.</p></div>
<div class="cs-card"><div class="cs-card-num">03</div><h3>Validated tables, complete skeletons</h3><p>Two tables hold the raw and the cleaned weather, both checked by the <code>csfmt_rts_data_v2</code> validators. <code>make_skeleton_date()</code> lays out the full location-by-date grid first, so a gap stays a visible row.</p></div>
</div>
