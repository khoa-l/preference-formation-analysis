#src/subset_plots/03c_manip_change_up.R

# ---- manipulated/change_up (from rating_shown and r1) subsets ----
manip_change_up_shown <- filter_r2_vs_shown(datasets$manipulated, "up")
manip_change_up_r1 <- filter_r1_vs_r2(datasets$manipulated, "up")

manip_change_up_dir <- here(subset_plots_dir, "manip_change_up")

plot_standard(manip_change_up_shown, file.path(manip_change_up_dir, "shown"))
plot_standard(manip_change_up_r1, file.path(manip_change_up_dir, "r1"))