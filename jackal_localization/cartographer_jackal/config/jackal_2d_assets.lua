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
      min_range = 0.5,
      max_range = 50.,
    },
    {
      action = "dump_num_points",
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
  }
}

return options
