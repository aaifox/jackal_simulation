include "jackal_2d_slam.lua"

TRAJECTORY_BUILDER.pure_localization = true

-- Real-time optimization
POSE_GRAPH.optimize_every_n_nodes = 1

TRAJECTORY_BUILDER_2D.max_range = 25.
TRAJECTORY_BUILDER_2D.missing_data_ray_length = 1.
TRAJECTORY_BUILDER_2D.voxel_filter_size = 0.035
TRAJECTORY_BUILDER_2D.adaptive_voxel_filter.max_range = 25.
TRAJECTORY_BUILDER_2D.loop_closure_adaptive_voxel_filter.max_range = 25.

TRAJECTORY_BUILDER_2D.submaps.num_range_data = 50

-- Local matcher
TRAJECTORY_BUILDER_2D.ceres_scan_matcher.translation_weight = 10
TRAJECTORY_BUILDER_2D.ceres_scan_matcher.rotation_weight = 40
TRAJECTORY_BUILDER_2D.use_online_correlative_scan_matching = false
-- TRAJECTORY_BUILDER_2D.real_time_correlative_scan_matcher.linear_search_window = 20.
-- TRAJECTORY_BUILDER_2D.real_time_correlative_scan_matcher.angular_search_window = math.rad(90.)

-- Global optimization
POSE_GRAPH.optimization_problem.ceres_solver_options.max_num_iterations = 30

-- Local constraints
POSE_GRAPH.constraint_builder.sampling_ratio = 0.1
POSE_GRAPH.constraint_builder.min_score = 0.57
-- POSE_GRAPH.constraint_builder.max_constraint_distance = 25.
-- POSE_GRAPH.constraint_builder.fast_correlative_scan_matcher.linear_search_window = 20.
-- POSE_GRAPH.constraint_builder.fast_correlative_scan_matcher.angular_search_window = math.rad(90.)
-- POSE_GRAPH.constraint_builder.fast_correlative_scan_matcher.branch_and_bound_depth = 15.

-- Global relocalization
POSE_GRAPH.global_sampling_ratio = 0.001
POSE_GRAPH.constraint_builder.global_localization_min_score = 0.6
POSE_GRAPH.global_constraint_search_after_n_seconds = 1

POSE_GRAPH.max_num_final_iterations = 1

return options