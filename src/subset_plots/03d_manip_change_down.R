#src/subset_plots/03c_manip_change_up.R

# ---- manipulated/change_up (from rating_shown and r1) subsets ----
manip_change_down_shown <- filter_r2_vs_shown(datasets$manipulated, "down")
manip_change_down_r1 <- filter_r1_vs_r2(datasets$manipulated, "down")

manip_change_down_dir <- here(subset_plots_dir, "manip_change_down")

plot_standard(manip_change_down_shown, file.path(manip_change_down_dir, "shown"))
plot_standard(manip_change_down_r1, file.path(manip_change_down_dir, "r1"))