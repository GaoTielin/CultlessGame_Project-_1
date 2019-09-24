-->game_cfg

cfg_player_acceleration_fast = 0.3 -- �➡️步�⌂��█�度
cfg_player_acceleration_low = 0.6 -- �➡️步�♥◆�█�度
cfg_player_max_v = 1.8 -- �█大�█�度
cfg_ice_acceleration_fast = 0.1--�●�面�⌂��█�度
cfg_ice_acceleration_low = 0.1--�●�面�♥◆�█�度
cfg_ice_max_v = 3 -- �●�面��█大�█�度

cfg_jump_speed = 3 -- 跳�⬇️�█�度
cfg_climb_speed = 1.6 -- �☉��▥�█�度
cfg_gravity = 0.3 -- �♥♪�⌂�(�…➡️�⬅️�░�⌂��█�度)

cfg_mogu_jump = 4 -- �♥♥�▤➡️�◆♥跳�⬇️�█�度
cfg_camera_move_speed = { -- �☉♥�♪�地图�❎��ˇ�头移�⌂��█�度
  x = 5,
  y = 5,
}

cfg_box_gravity = 0.1 --箱��…��░�♥♪�⌂�
cfg_box_max_v = 0.5 --�🅾️�箱��…��█大�█�度
cfg_box_max_y = 1 --箱��…�★😐�●���❎y轴��░��█大�█�度

cfg_levels_autumn = {
  level1 = 'enemy_catepillerscamera_pos0,0icesboxsongzi140,88enemy_beesplayer_start_pos0,7',
  level2 = 'songzi1208,48icesenemy_catepillersenemy_beescamera_pos16,0player_start_pos0,7box',
  level3 = 'player_start_pos0,7icesenemy_beessongzi1288,642352,48camera_pos32,0boxenemy_catepillers',
  level4 = 'songzi1432,72icescamera_pos48,0player_start_pos0,7enemy_bees1432,64,24,0.5,0enemy_catepillers1432,72,24,0.5,1box',
  level5 = 'player_start_pos0,7camera_pos0,0songzienemy_catepillersicesboxenemy_beeschange_map123,11,2224,11,2342,7,16442,8,16542,9,16642,10,16763,9,16863,10,16963,11,16',
  level6 = 'songzienemy_catepillers1216,48,8,0.5player_start_pos0,5enemy_beesboxicescamera_pos16,0',
  level7 = 'boxenemy_bees1280,64,16,0.52336,48,16,0.5songzicamera_pos32,0player_start_pos0,5icesenemy_catepillers1336,64,8,0.5,1,1,1',
  level8 = 'boxcamera_pos48,0icessongziplayer_start_pos0,5enemy_catepillers1432,72,24,0.5,02432,72,24,0.5,1enemy_bees1464,64,24,0.6',
  level9 = 'boxenemy_beesplayer_start_pos0,5songziicesenemy_catepillerscamera_pos64,0'
}

cfg_levels_winter = {
  level1 = 'camera_pos0,0songzi140,88enemy_catepillersplayer_start_pos0,7boxicesenemy_bees',
 level2 = 'enemy_beesboxicesplayer_start_pos0,7songzi1224,80camera_pos16,0enemy_catepillers',
 level3 = 'enemy_catepillerssongzi1336,48player_start_pos0,7ice1264,642352,803344,48boxcamera_pos32,0enemy_bees',
 level4 = 'camera_pos48,0box1416,40ice1416,64songzi1496,80player_start_pos0,8enemy_catepillersenemy_bees',
 level5 = 'iceboxenemy_catepillersplayer_start_pos0,7songzienemy_beescamera_pos0,0',
 level6 = 'player_start_pos0,10songzi140,216enemy_beesice124,184232,216enemy_catepillersbox1104,176camera_pos0,16',
 level7 = 'enemy_beescamera_pos16,16box1208,192ice1184,2162184,2243193,2164193,2245175,2006176,1687200,168player_start_pos0,10enemy_catepillerssongzi1176,2242200,224',
 level8 = 'icesongzi1288,192enemy_catepillersplayer_start_pos0,10box1296,168enemy_beescamera_pos32,16',
 level9 = 'iceplayer_start_pos0,10songzi1424,216enemy_beesenemy_catepillersboxcamera_pos48,16',
 level10= 'boxice1552,168enemy_catepillersplayer_start_pos0,10enemy_beessongzicamera_pos64,16',
 level11= 'enemy_beesbox1672,1522712,152camera_pos80,16icesongzienemy_catepillersplayer_start_pos0,8',
}

cfg_levels_spring = {
  level1 = 'camera_pos0,16boxenemy_catepillerssongziplayer_start_pos0,11enemy_beesice',
  level2 = 'enemy_beesplayer_start_pos0,10box1160,176enemy_catepillersicecamera_pos16,16songzi1216,208',
  level3 = 'player_start_pos0,10iceenemy_catepillersboxsongzi1312,200camera_pos32,16enemy_bees',
  level4 = 'player_start_pos0,2enemy_catepillerscamera_pos48,16enemy_beesiceboxsongzi1448,192',
  level5 = 'enemy_beesenemy_catepillersicecamera_pos64,16songzi1592,184box1544,176player_start_pos0,2',
  level6 = 'player_start_pos3,11enemy_beesicebox1680,32camera_pos80,0enemy_catepillerssongzi1728,88',
  level7 = 'songziboxplayer_start_pos0,10enemy_beesenemy_catepillerscamera_pos96,0ice',
}


cfg_levels_summer = {
  level1 = 'boxenemy_beesenemy_catepillersiceplayer_start_pos0,9camera_pos0,16songzi',
  level2 = 'enemy_catepillerscamera_pos16,16player_start_pos2,9icesongzi1192,184enemy_beesbox',
  level3 = 'songzicamera_pos32,16enemy_catepillersboxenemy_beesplayer_start_pos0,10ice',
  level4 = 'enemy_catepillersicesongzi1408,2162488,216player_start_pos0,10box1424,1762464,216camera_pos48,16enemy_bees',
  level5 = 'enemy_catepillers1560,216,24,0.5,0,0,02624,200,8,0.5,1,0,1iceplayer_start_pos0,10enemy_bees1536,200,16,0.5,0boxcamera_pos64,16songzi1528,216',
  level6 = 'camera_pos80,16enemy_catepillersiceboxsongzi1760,160player_start_pos0,8enemy_bees',
}
