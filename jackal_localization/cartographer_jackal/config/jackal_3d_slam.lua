include "map_builder.lua"
include "trajectory_builder.lua"

options = {
  map_builder = MAP_BUILDER,
  trajectory_builder = TRAJECTORY_BUILDER,
  map_frame = "map",
  tracking_frame = "base_link",
  published_frame = "odom",
  odom_frame = "odom",  -- not used
  provide_odom_frame = false,
  publish_frame_projected_to_2d = true,  -- flat terrain
  -- use_pose_extrapolator = true,
  use_odometry = true,
  use_nav_sat = false,
  use_landmarks = false,
  num_laser_scans = 0,
  num_multi_echo_laser_scans = 0,
  num_subdivisions_per_laser_scan = 1,
  num_point_clouds = 1,
  lookup_transform_timeout_sec = 0.2,
  submap_publish_period_sec = 0.3,
  pose_publish_period_sec = 5e-3,
  trajectory_publish_period_sec = 30e-3,
  rangefinder_sampling_ratio = 1.,
  odometry_sampling_ratio = 1.,
  fixed_frame_pose_sampling_ratio = 1.,
  imu_sampling_ratio = 1.,
  landmarks_sampling_ratio = 1.,
}

-- Number of messages needed for a full scan
TRAJECTORY_BUILDER_3D.num_accumulated_range_data = 1 -- Gazebo Velodyne-16 / RoboSense-16

-- Ignore robot's body
TRAJECTORY_BUILDER_3D.min_range = 0.25

-- Used for writing hybrid grid asset, increasing it can dramatically slow down computations
-- TRAJECTORY_BUILDER_3D.submaps.range_data_inserter.hit_probability = 0.55
-- TRAJECTORY_BUILDER_3D.submaps.range_data_inserter.miss_probability = 0.49
-- TRAJECTORY_BUILDER_3D.submaps.range_data_inserter.num_free_space_voxels = 2  -- Up to how many free space voxels are updated for scan matching. 0 disables free space.

-- These were just my first guess: use more points for SLAMing and adapt a bit for the ranges that are bigger for cars.
-- TRAJECTORY_BUILDER_3D.high_resolution_adaptive_voxel_filter.max_length = 5.
-- TRAJECTORY_BUILDER_3D.high_resolution_adaptive_voxel_filter.min_num_points = 250.
-- TRAJECTORY_BUILDER_3D.low_resolution_adaptive_voxel_filter.max_length = 8.
-- TRAJECTORY_BUILDER_3D.low_resolution_adaptive_voxel_filter.min_num_points = 400.

-- The submaps felt pretty big - since the car moves faster, we want them to be
-- slightly smaller. You are also slamming at 10cm - which might be aggressive
-- for cars and for the quality of the laser. I increased 'high_resolution',
-- you might need to increase 'low_resolution'. Increasing the
-- '*num_iterations' in the various optimization problems also trades
-- performance/quality.
-- TRAJECTORY_BUILDER_3D.submaps.num_range_data = 80
-- TRAJECTORY_BUILDER_3D.submaps.high_resolution = .25

MAP_BUILDER.use_trajectory_builder_3d = true
MAP_BUILDER.num_background_threads = 7  -- vm
-- MAP_BUILDER.num_background_threads = 19  -- server

-- Default
POSE_GRAPH.optimization_problem.huber_scale = 5e2
-- Trying loop closing too often will cost CPU and not buy you a lot. There is little point in trying more than once per submap.
POSE_GRAPH.optimize_every_n_nodes = 100
POSE_GRAPH.constraint_builder.sampling_ratio = 0.03
POSE_GRAPH.optimization_problem.ceres_solver_options.max_num_iterations = 100
-- Reuse the coarser 3D voxel filter to speed up the computation of loop closure constraints.
-- POSE_GRAPH.constraint_builder.adaptive_voxel_filter = TRAJECTORY_BUILDER_3D.high_resolution_adaptive_voxel_filter

-- This is probably the most important change: lower the matching score for adding constraints.
POSE_GRAPH.constraint_builder.min_score = 0.4
POSE_GRAPH.constraint_builder.global_localization_min_score = 0.5  -- TODO

-- TODO
-- POSE_GRAPH.constraint_builder.fast_correlative_scan_matcher_3d.linear_xy_search_window = 20.
-- POSE_GRAPH.constraint_builder.fast_correlative_scan_matcher_3d.linear_z_search_window = 5.
-- POSE_GRAPH.constraint_builder.fast_correlative_scan_matcher_3d.angular_search_window = math.rad(30.)

return options
