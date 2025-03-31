
# _targets.R file

# https://books.ropensci.org/targets/crew.html#configuration-and-auto-scaling
# tar_make() ; tar_crew()

library(targets)
library(tarchetypes)

controller <- crew::crew_controller_local(
  name = "my_controller",
  workers = 10,
  seconds_idle = 3
)
tar_option_set(controller = controller)
list(
  tar_target(x, seq_len(1000)),
  tar_target(y, Sys.sleep(.1), pattern = map(x)) # Run for 1 second.
  # tar_target(y, x, pattern = map(x))
)
