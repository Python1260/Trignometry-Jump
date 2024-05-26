bgalpha=1

if !(instance_exists(obj_player) and obj_player.state==states.loose) {
	alarm[1]=room_speed/(flicker_bpm/60)
}