if room==rm_menu or room==rm_editor {
	return
}

initial_objects=load_instances()
level_tiles=load_tiles(spr_ts_blocks)

var tnum=instance_number(obj_trigger)
for (var t=0;t<tnum;t++) {
	var trigger=instance_find(obj_trigger, t)
	
	if variable_instance_exists(trigger, "trigger_object_code") {
		with (trigger) {
			triggerID=get_trigger_objects(trigger_object_code)
		}
	}
}

if audio_exists(current_music) and audio_is_playing(current_music) {
	audio_stop_sound(current_music)
}

var mus=ds_map_find_value(level_music, room)

if audio_exists(mus) {
	current_music=audio_play_sound(mus, 1, false)
}

draw_dir=1
draw_target=1
draw_transition_border=start_dtb
transition_type=transition_types.none
triggers=[]
bgblend=[255, 255, 255]
bgalpha=1
flicker_bpm= -1
alarm[1]=room_speed/(flicker_bpm/60)
initial_camw=camera_get_view_width(view_camera[0])
initial_camh=camera_get_view_height(view_camera[0])
initial_cambx=camera_get_view_border_x(view_camera[0])
initial_camby=camera_get_view_border_y(view_camera[0])