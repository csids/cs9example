# ******************************************************************************
# ******************************************************************************
#
# 99_util_*.R
#
# PURPOSE 1:
#   Utility functions that are used across multiple tasks
#
# ******************************************************************************
# ******************************************************************************

no_data_plot <- function(){
  data=data.frame(x=0,y=0)
  q <- ggplot(data=data)
  q <- q + theme_void()
  q <- q + annotate("text", label=glue::glue("Ikke noe data {fhi::nb$aa} vise"), x=0, y=0, size=10)
  q
}
