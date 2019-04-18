include "map_builder.lua"
include "trajectory_builder.lua"

options = {
  map_builder = MAP_BUILDER,
  trajectory_builder = TRAJECTORY_BUILDER,

  -- TF frames
  map_frame = "map",  -- parent frame of published poses
  published_frame = "odom",  -- child frame of published poses
  tracking_frame = "um7_imu_link",  -- need IMU frame if using IMU
  odom_frame = "odom",  -- not used if provide_odom_frame is false
  provide_odom_frame = false,
  publish_frame_projected_to_2d = false,  -- assume flat terrain
  -- use_pose_extrapolator = true,  -- not supported in 1.0

  -- Extra inputs
  use_odometry = false,
  use_nav_sat = false,
  use_landmarks = false,

  -- Input scans
  num_laser_scans = 0,
  num_multi_echo_laser_scans = 0,
  num_subdivisions_per_laser_scan = 1,
  num_point_clouds = 1,

  -- Publishing frequencies
  submap_publish_period_sec = 0.3,
  pose_publish_period_sec = 5e-3,
  trajectory_publish_period_sec = 30e-3,
  lookup_transform_timeout_sec = 0.2,

  -- Sampling ratios: reduce to downsample inputs (not recommended)
  rangefinder_sampling_ratio = 1.,
  odometry_sampling_ratio = 1.,
  fixed_frame_pose_sampling_ratio = 1.,
  imu_sampling_ratio = 1.,
  landmarks_sampling_ratio = 1.,
}

-- Use 2D SLAM
MAP_BUILDER.use_trajectory_builder_2d = true
MAP_BUILDER.use_trajectory_builder_3d = false

-- Multithreading: use more threads if running on the server
MAP_BUILDER.num_background_threads = 7  -- (4)
TRAJECTORY_BUILDER_2D.ceres_scan_matcher.ceres_solver_options.num_threads = 7  -- (1)
POSE_GRAPH.constraint_builder.ceres_scan_matcher.ceres_solver_options.num_threads = 7  -- (1)
POSE_GRAPH.optimization_problem.ceres_solver_options.num_threads = 7  -- (7)

-------------------------- Local SLAM --------------------------

-- Input IMU measurements
TRAJECTORY_BUILDER_2D.use_imu_data = true  -- (true) greatly reduces the complexity of scan matching by providing an initial orientation guess

-- Number of messages needed to transmit a complete scan
TRAJECTORY_BUILDER_2D.num_accumulated_range_data = 1  -- (1) RoboSense-16

-- Input scan filering
TRAJECTORY_BUILDER_2D.voxel_filter_size = 0.025  -- (0.025)
TRAJECTORY_BUILDER_2D.missing_data_ray_length = 2.  -- (5.) extra length of rays beyond 'max_range'
TRAJECTORY_BUILDER_2D.min_range = 0.5  -- (0.) range bandpass filter
TRAJECTORY_BUILDER_2D.max_range = 35.  -- (30.)
TRAJECTORY_BUILDER_2D.min_z = -0.5  -- (-0.8) elevation bandpass filter
TRAJECTORY_BUILDER_2D.max_z = 1.5  -- (2.)

-- Adaptive voxel filter
TRAJECTORY_BUILDER_2D.adaptive_voxel_filter.max_length = 0.5 -- (0.5)
TRAJECTORY_BUILDER_2D.adaptive_voxel_filter.min_num_points = 200 -- (200) number of points per voxel until voxel length is reduced
TRAJECTORY_BUILDER_2D.adaptive_voxel_filter.max_range = 35. -- (50.)
TRAJECTORY_BUILDER_2D.loop_closure_adaptive_voxel_filter.max_length = 0.9 -- (0.9)
TRAJECTORY_BUILDER_2D.loop_closure_adaptive_voxel_filter.min_num_points = 100 -- (100)
TRAJECTORY_BUILDER_2D.loop_closure_adaptive_voxel_filter.max_range = 35. -- (50.)

-- Scan matcher
TRAJECTORY_BUILDER_2D.use_online_correlative_scan_matching = true  -- (false) RealTimeCorrelativeScanMatcher: trust only sensor scan to initialize CeresScanMatcher (expensive)
TRAJECTORY_BUILDER_2D.ceres_scan_matcher.occupied_space_weight = 1 -- (1)
TRAJECTORY_BUILDER_2D.ceres_scan_matcher.translation_weight = 10  -- (10) higher weight means deviating from prior through translation is more expensive
TRAJECTORY_BUILDER_2D.ceres_scan_matcher.rotation_weight = 40 -- (40) higher weight means deviating from prior through rotation is more expensive
TRAJECTORY_BUILDER_2D.ceres_scan_matcher.ceres_solver_options.max_num_iterations = 25  -- (20) optimization iterations for CeresScanMatcher

-- Motion filter: insert a scan in a submap only if any of the following 3 criteria is covered
TRAJECTORY_BUILDER_2D.motion_filter.max_time_seconds = 1.  -- (5.)
TRAJECTORY_BUILDER_2D.motion_filter.max_distance_meters = 0.1  -- (0.2)
TRAJECTORY_BUILDER_2D.motion_filter.max_angle_radians = math.rad(0.4)  -- (math.rad(1.))

-- Submaps
TRAJECTORY_BUILDER_2D.submaps.num_range_data = 200  -- (90) size of submap in scans
TRAJECTORY_BUILDER_2D.submaps.grid_options_2d.resolution = 0.05  -- (0.05) resolution of 2d grid
TRAJECTORY_BUILDER_2D.submaps.range_data_inserter.probability_grid_range_data_inserter.hit_probability = 0.55  -- (0.55) obstacle probability
TRAJECTORY_BUILDER_2D.submaps.range_data_inserter.probability_grid_range_data_inserter.miss_probability = 0.49  -- (0.49) freespace probability

-------------------------- Global SLAM --------------------------

-- Global optimization
POSE_GRAPH.optimize_every_n_nodes = TRAJECTORY_BUILDER_2D.submaps.num_range_data  -- (90) run global optimization every 1 submap
POSE_GRAPH.optimization_problem.ceres_solver_options.max_num_iterations = 75  -- (50) iterations to use for Ceres' global optimization
POSE_GRAPH.max_num_final_iterations = 250  -- (200) iterations to use for the final global optimization

-- Optimization scaling parameters
POSE_GRAPH.optimization_problem.huber_scale = 100  -- (10) impact of potential outliers 
POSE_GRAPH.optimization_problem.acceleration_weight = 10000  -- (1000) IMU acceleration
POSE_GRAPH.optimization_problem.rotation_weight = 500000  -- (300000) IMU rotation
POSE_GRAPH.optimization_problem.local_slam_pose_translation_weight = 100000  -- (100000) local SLAM pose translation
POSE_GRAPH.optimization_problem.local_slam_pose_rotation_weight = 50000 -- (100000) local SLAM pose rotation
POSE_GRAPH.optimization_problem.odometry_translation_weight = 50000  -- (100000) odometry translation
POSE_GRAPH.optimization_problem.odometry_rotation_weight = 25000  -- (100000) odometry rotation

-- Matcher (non loop-closure) constraints
POSE_GRAPH.matcher_translation_weight = 400  -- (500)
POSE_GRAPH.matcher_rotation_weight = 1200  -- (1600)

-- Local loop-closure constraints
POSE_GRAPH.constraint_builder.sampling_ratio = 0.3  -- (0.3) sample potential constraints (sampling few nodes will miss constraints/loop closure, sampling too many will slow down global SLAM)
POSE_GRAPH.constraint_builder.min_score = 0.53  -- (0.55) FastCorrelativeScanMatcher: only feed proposals above this score to CeresScanMatcher
POSE_GRAPH.constraint_builder.max_constraint_distance = 12.  -- (15.) distance between a new submap and previous nodes/poses to search for global constaints
POSE_GRAPH.constraint_builder.loop_closure_translation_weight = 11000  -- (11000)
POSE_GRAPH.constraint_builder.loop_closure_rotation_weight = 100000  -- (100000)

-- Global loop-closure constraints: loop-closure between multiple trajectories
POSE_GRAPH.global_sampling_ratio = 0.005  -- (0.003) sample nodes for global localization
POSE_GRAPH.constraint_builder.global_localization_min_score = 0.5  -- (0.6) only global localizations above this score are trusted
POSE_GRAPH.global_constraint_search_after_n_seconds = 7.  -- (10.) time to perform global loop closure search globally instead of locally if no constraint between 2 trajectories was added

return options
