-->game_cfg

cfg_player_acceleration_fast = 0.2 -- 跑步加速度
cfg_player_acceleration_low = 0.3 -- 跑步减速度
cfg_jump_speed = 3.2 -- 跳跃速度
cfg_climb_speed = 1.6 -- 爬墙速度
cfg_gravity = 0.4 -- 重力(向下的加速度)
cfg_player_max_v = 1.6 -- 最大速度
cfg_mogu_jump = 4 -- 采蘑菇跳跃速度
cfg_camera_move_speed = { -- 切换地图时镜头移动速度
  x = 5,
  y = 5,
}

cfg_levels_autumn = {
  level1 = {

    player_start_pos = { -- 角色起始在关卡中的位置 单位（格）
      x = 0,
      y = 7,
    },
    camera_pos = { -- 相机位置 单位（格）
      x = 0,
      y = 0,
    },
    enemys = { -- 敌人配置，参数分别为x坐标，y坐标，移动最远距离, 速度
      bees = {
        -- {6*8, 6*8, 16, 0.5},
        -- {56*8, 8*8, 16, 0.5}
      },
      catepillers = {
        -- {10*8, 10*8, 16, 0.5}
      }
    },
    songzi = {
      -- {9*8, 10*8}
    },
  },
  level2 = {
    player_start_pos = { -- 角色起始在关卡中的位置 单位（格）ps:相对于摄像机
      x = 0,
      y = 7,
    },
    camera_pos = { -- 相机位置 单位（格）
      x = 16,
      y = 0,
    },
    enemys = { -- 敌人配置
      caterpillar ={},
      bees = {
        -- {26*8, 6*8, 16, 0.5},
      },
      catepillers = {
        -- {27*8, 6*8, 8, 0.5}
      },
    },
    songzi = {
      -- {13*8, 8*8},
      {26*8, 6*8},
    },
  },
  level3 = {

    player_start_pos = { -- 角色起始在关卡中的位置 单位（格）
      x = 0,
      y = 7,
    },
    camera_pos = { -- 相机位置 单位（格）
      x = 32,
      y = 0,
    },
    enemys = { -- 敌人配置
      caterpillar ={},
      bees = {
        -- {26*8, 6*8, 16, 0.5},
      },
      catepillers = {

      },

    },
    songzi = {
      {36*8,8*8},
      {44*8,6*8},
    },
  },
  level4 = {
    player_start_pos = { -- 角色起始在关卡中的位置 单位（格）
      x = 0,
      y = 7,
    },
    camera_pos = { -- 相机位置 单位（格）
      x = 48,
      y = 0,
    },
    enemys = { -- 敌人配置
      caterpillar ={},
      bees = {
        {54*8, 7*8, 24, 0.5},
      },
      catepillers = {
        {52*8, 9*8, 8, 0.5}
      },
    },
    songzi = {
      {54*8, 9*8},
    },
  },
  level5 = {
    change_map = {
      {x = 23, y = 11, sp = 2},
      {x = 24, y = 11, sp = 2},
      {x = 42, y = 7, sp = 16},
      {x = 42, y = 8, sp = 16},
      {x = 42, y = 9, sp = 16},
      {x = 42, y = 10, sp = 16},
      {x = 63, y = 10, sp = 16},
      {x = 63, y = 11, sp = 16},
    },
    player_start_pos = { -- 角色起始在关卡中的位置 单位（格）
      x = 0,
      y = 7,
    },
    camera_pos = { -- 相机位置 单位（格）
      x = 0,
      y = 0,
    },
    enemys = { -- 敌人配置
      caterpillar ={},
      bees = {
        -- {54*8, 7*8, 24, 0.5},
      },
      catepillers = {
        -- {52*8, 9*8, 8, 0.5}
      },
    },
    songzi = {
      -- {54*8, 9*8},
    },
  },
  level6 = {
    player_start_pos = { -- 角色起始在关卡中的位置 单位（格）ps:相对于摄像机
      x = 0,
      y = 5,
    },
    camera_pos = { -- 相机位置 单位（格）
      x = 16,
      y = 0,
    },
    enemys = { -- 敌人配置
      caterpillar ={},
      bees = {
        -- {26*8, 6*8, 16, 0.5},
      },
      catepillers = {
        {27*8, 6*8, 8, 0.5}
      },
    },
    songzi = {
    },
  },
  level7 = {
    player_start_pos = { -- 角色起始在关卡中的位置 单位（格）
      x = 0,
      y = 5,
    },
    camera_pos = { -- 相机位置 单位（格）
      x = 32,
      y = 0,
    },
    enemys = { -- 敌人配置
      caterpillar ={},
      bees = {
        {35*8, 7*8, 16, 0.5},
      },
      catepillers = {
        {42*8, 10*8, 0, 0.5}
      },
    },
    songzi = {
    },
  },
  level8 = {
    player_start_pos = { -- 角色起始在关卡中的位置 单位（格）
      x = 0,
      y = 5,
    },
    camera_pos = { -- 相机位置 单位（格）
      x = 48,
      y = 0,
    },
    enemys = { -- 敌人配置
      caterpillar ={},
      bees = {
        {54*8, 7*8, 24, 0.5},
      },
      catepillers = {
        {52*8, 9*8, 8, 0.5},
        {56*8, 9*8, 8, 0.5},
      },
    },
    songzi = {
    },
  },
  level9 = {
    player_start_pos = { -- 角色起始在关卡中的位置 单位（格）
      x = 0,
      y = 5,
    },
    camera_pos = { -- 相机位置 单位（格）
      x = 48,
      y = 0,
    },
    enemys = { -- 敌人配置
      caterpillar ={},
      bees = {
        {54*8, 7*8, 24, 0.5},
      },
      catepillers = {
        {56*8, 9*8, 8, 0.5}
      },
    },
    songzi = {
    },
  },
}
