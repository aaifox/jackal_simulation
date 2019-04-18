VOXEL_SIZE = 5e-2

include "transform.lua"

options = {
  tracking_frame = "base_link",
  pipeline = {
    -- {
    --   action = "frame_id_filter",
    --   keep_frames = {"velodyne"},
    -- },
    {
      action = "min_max_range_filter",
      min_range = 0.3,
      max_range = 10.,
    },
    {
      action = "dump_num_points",
    },
    {
      action = "voxel_filter_and_remove_moving_objects",
      -- miss_per_hit_limit = 3,  -- not supported in 1.0
      voxel_size = VOXEL_SIZE,
    },
    {
      action = "write_hybrid_grid",
      voxel_size = VOXEL_SIZE,
      range_data_inserter = {
        hit_probability = 0.55,
        miss_probability = 0.49,
        num_free_space_voxels = 2,
      },
      filename = "hybrid_grid",
    },
    {
      action = "write_probability_grid",
      draw_trajectories = true,
      resolution = 0.05,
      range_data_inserter = {
        insert_free_space = true,
        hit_probability = 0.55,
        miss_probability = 0.49,
      },
      filename = "probability_grid",
    },
    {
      action = "write_xray_image",
      voxel_size = VOXEL_SIZE,
      filename = "xray_xy_all",
      transform = XY_TRANSFORM,
    },
    {
      action = "write_pcd",
      filename = "points.pcd",
    },
  }
}

return options
