#src/subset_plots/03b_manip_no_change.R

# ---- manipulated/no_change (from rating_shown and r1) subsets ----
manip_no_change_shown <- filter_r2_vs_shown(datasets$manipulated, "same")
manip_no_change_r1 <- filter_r1_vs_r2(datasets$manipulated, "same")

manip_no_change_dir <- here(subset_plots_dir, "manip_no_change")

plot_standard(manip_no_change_shown, file.path(manip_no_change_dir, "shown"))
plot_standard(manip_no_change_r1, file.path(manip_no_change_dir, "r1"))