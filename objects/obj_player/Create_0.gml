key_left=0
key_right=0
key_jump=0
jumping=false
key_jump_press=0
key_jump_rel=0

rotation=0

state=states.normal
size=player_sizes.normal
prev_state=state
hsp=0
vsp=0
rsp=0

slow_spd=5
normal_spd=10
fast_spd=20
very_fast_spd=30
extremely_fast_spd=40

spd=normal_spd
rot_spd=10
grav=1
jspd=25

max_ship_fly_spd=15
ufo_jspd=20
wave_angle=45
wave_spd=15
wave_trailID=noone
ball_rot_spd=15
ball_fly_spd=1.5
robot_jump_max=25
robot_jump_t=0
robot_jump_tmax=30
spider_jspd=200
spider_trailID=noone
swing_fly_spd=0.9
swipeID=noone
swipeeffectID=noone
swipe_rsp=25
cloneID=noone
small_scale=0.5
mini_iconID=noone

jspd_small=20
max_ship_fly_spd_small=20
ufo_jspd_small=15
wave_angle_small=55
robot_jump_max_small=20
robot_jump_tmax_small=25

spd_accel=0.5
fly_accel=0.8
fly_accel_small=1
ball_rot_accel=1
robot_jump_accel=1.2

grounded=false
grav_dir=1
sloping=noone
sloping_start=[]         

spr_idle=spr_player_idle
spr_ship=spr_player_ship
spr_ufo=spr_player_ufo
spr_wave=spr_player_wave
spr_ball=spr_player_ball
spr_robot=spr_player_robot
spr_spider=spr_player_spider
spr_swing=spr_player_swing

specials_list=ds_list_create()

level_mode=true
delta_time_mode=false // "reduces" lag but increments goofyness

palette_col1=col_to_shader([0, 255, 255])
palette_col2=col_to_shader([0, 255, 0])
replace_col1=col_to_shader([100, 100, 100])
replace_col2=col_to_shader([200, 200, 200])

debug=false

triggerID=noone