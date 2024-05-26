var cam=view_camera[0]
var camx=camera_get_view_x(cam)
var camy=camera_get_view_y(cam)
var camw=camera_get_view_width(cam)
var camh=camera_get_view_height(cam)
var key_quit=keyboard_check_pressed(vk_escape)

if key_quit {
	if audio_exists(current_music) and audio_is_playing(current_music) {
		audio_stop_sound(current_music)
	}
	room_goto(rm_menu)
}

if room==rm_editor or room==rm_menu {
	return
}

draw_dir=approach(draw_dir, draw_target, draw_sp)

if flicker_bpm>0 {
	bgalpha=approach(bgalpha, 0, 0.02)
}
else {
	bgalpha=approach(bgalpha, 1, 0.02)
}

camera_set_view_angle(view_camera[0], sin(current_time/1000)*cam_rot_factor)
camera_set_view_pos(cam, camx, camy-sin(current_time/1000)*10)

var _td=[]
for (var t=0;t<array_length(triggers);t++) {
	var trigger=triggers[t]
	var type=trigger[0]
	var inst=trigger[1]
	if !instance_exists(inst) {
		_td[array_length(_td)]=t
		continue
	}
	
	if type==trigger_types.move {
		var tiles=layer_tilemap_get_id(layer_get_id("Tiles"))
		var cell_width=tilemap_get_tile_width(tiles)
		var cell_height=tilemap_get_tile_height(tiles)
		var tx=trigger[2][0]
		var ty=trigger[2][1]
		
		
		if inst.x==inst.xstart+tx and inst.y==inst.ystart+ty {
			_td[array_length(_td)]=t
		}
		
		with (inst) {
			inst.x=approach(inst.x, inst.xstart+tx, trigger[3])
			if object_get_parent(object_index)==obj_solid {
				var plrx=instance_place(x, y, obj_player)
				if plrx {
					plrx.x+=trigger[3]*sign(tx-inst.xstart)
				}
			}
			
			inst.y=approach(inst.y, inst.ystart+ty, trigger[3])
			if object_get_parent(inst.object_index)==obj_solid {
				var plry=instance_place(x, y, obj_player)
				if plry {
					plry.y+=trigger[3]*sign(ty-inst.ystart)
				}
			}
		}
	}
	else if type==trigger_types.rotate {
		var _dist=point_distance(inst.x, inst.y, trigger[2][0], trigger[2][1])
		inst.x=trigger[2][0]
		inst.y=trigger[2][1]
		inst.image_angle=angle_approach(inst.image_angle, trigger[3], trigger[4])
		inst.x+=lengthdir_x(_dist, inst.image_angle)
		inst.y+=lengthdir_y(_dist, inst.image_angle)
		
		if inst.image_angle==trigger[3] {
			_td[array_length(_td)]=t
		}
	}
	else if type==trigger_types.alpha {
		inst.image_alpha=approach(inst.image_alpha, trigger[2], trigger[3])
		
		if inst.image_alpha==trigger[2] {
			_td[array_length(_td)]=t
		}
	}
	else if type==trigger_types.background {
		bgblend[0]=approach(bgblend[0], trigger[2][0], trigger[3])
		bgblend[1]=approach(bgblend[1], trigger[2][1], trigger[3])
		bgblend[2]=approach(bgblend[2], trigger[2][2], trigger[3])
		
		if bgblend[0]==trigger[2][0] and bgblend[1]==trigger[2][1] and bgblend[2]==trigger[2][2] {
			_td[array_length(_td)]=t
		}
	}
	else if type==trigger_types.zoom {
		var ns=approach((camw/initial_camw), trigger[2], trigger[3])
		camera_zoom(inst, ns)
		camw=camera_get_view_width(cam)
		camh=camera_get_view_height(cam)
		
		if (camw/initial_camw)==trigger[2] {
			_td[array_length(_td)]=t
		}
	}
	else if type==trigger_types.flicker {
		flicker_bpm=trigger[2]
		alarm[1]=room_speed/(flicker_bpm/60)
		_td[array_length(_td)]=t
	}
}
for (var i=0;i<array_length(_td);i++) {
	array_delete(triggers, _td[i], 1)
}