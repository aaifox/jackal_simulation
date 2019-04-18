include "jackal_3d_slam.lua"

TRAJECTORY_BUILDER.pure_localization = true
POSE_GRAPH.optimize_every_n_nodes = 1
POSE_GRAPH.constraint_builder.sampling_ratio = 0.05
-- POSE_GRAPH.global_sampling_ratio = 0.001

return options