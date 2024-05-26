/*Song: DEAF KEV - Invincible [NCS Release]
Music provided by NoCopyrightSounds
Free Download/Stream: http://ncs.io/invincible
Watch: http://youtu.be/J2X5mJ3HDYE*/

randomize()

if game_get_speed(gamespeed_fps)>60 {
	game_set_speed(60, gamespeed_fps)
}

enum states {
	normal,
	fall,
	ship,
	ufo,
	wave,
	ball,
	robot,
	robot_jump,
	robot_fall,
	spider,
	swipe,
	swing,
	loose,
	win
}
enum player_sizes {
	normal,
	small
}
enum orb_types {
	jump,
	bounce,
	leap,
	grav,
	spider,
	smooth,
	boost
}
enum pad_types {
	jump,
	bounce,
	leap,
	grav,
	spider
}
enum portal_types {
	normal,
	ship,
	ufo,
	wave,
	ball,
	robot,
	spider,
	grav_down,
	grav_up,
	grav_invert,
	dir_right,
	dir_left,
	teleport,
	duplicate_start,
	duplicate_end,
	icon_small,
	icon_normal,
	swing
}
enum swipe_types {
	swipe,
	grav
}
enum speed_up_types {
	slow,
	normal,
	fast,
	very_fast,
	extremely_fast
}
enum trigger_types {
	move,
	rotate,
	alpha,
	background,
	zoom,
	flicker,
	win
}
enum transition_types {
	none,
	scale_up,
	scale_down,
	alpha,
	object_up,
	object_down,
	player_up,
	player_down
}
enum difficulties {
	easy,
	easier,
	hard,
	harder,
	insane,
	demon
}

transition_type=transition_types.none

draw_dir=1
draw_target=1
draw_sp=0.1
start_dtb=100 //camera_get_view_width(view_camera[0])/2 very cool effect for some transitions!
draw_transition_border=start_dtb
max_bg_move=7500

plr_shader=shd_playertexture
def_col1=col_to_shader([100, 100, 100])
def_col2=col_to_shader([200, 200, 200])
sh_handle_range=shader_get_uniform(plr_shader, "range")
sh_handle_match1=shader_get_uniform(plr_shader, "colorMatch1")
sh_handle_match2=shader_get_uniform(plr_shader, "colorMatch2")
sh_handle_replace1=shader_get_uniform(plr_shader, "colorReplace1")
sh_handle_replace2=shader_get_uniform(plr_shader, "colorReplace2")

level_tiles=[]

level_music=ds_map_create()
current_music=noone

ds_map_add(level_music, rm_level1, mus_1)

objects=ds_list_create()
initial_objects=[]
triggers=[]

cam_rot_factor=0

bgspr=spr_BG1
bgblend=[255, 255, 255]
bgalpha=1

flicker_bpm= -1

initial_camw=camera_get_view_width(view_camera[0])
initial_camh=camera_get_view_height(view_camera[0])
initial_cambx=camera_get_view_border_x(view_camera[0])
initial_camby=camera_get_view_border_y(view_camera[0])

alarm[1]=room_speed/(flicker_bpm/60)

depth= -100