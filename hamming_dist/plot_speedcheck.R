require(ggplot2)
require(dplyr)

speeds <- read.csv(file = "hamming_dist/speedcheck.txt")

p <- ggplot(
  data = speeds,
  aes(x = N, shape = factor(EST_FREQ))) +
  geom_point(aes(y = runtime_pl, color = "Perl")) +
  geom_point(aes(y = runtime_py, color = "Python")) +
  facet_grid(M ~ N_CPU, scales = "free")

ggsave(filename = "hamming_dist/speedcheck_noreturnfrommap.png", plot = p)