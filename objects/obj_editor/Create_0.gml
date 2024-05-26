enum edit_modes {
	move,
	scale,
	rotate
}
enum show_modes {
	object,
	edit,
	variable,
	tiles
}

show_types=[show_modes.object, show_modes.edit, show_modes.variable, show_modes.tiles]
show_type=0

objects_types=load_game_objects()
object_type=0
object_thresold=5

game_objects=ds_map_create()
selectID=noone
edit_types=[edit_modes.move, edit_modes.scale, edit_modes.rotate]
edit_type=0

variable_idx=0

old_ms_pos=[mouse_x, mouse_y]
mouse_refresh=0.05
mouse_press_pos=[mouse_x, mouse_y]
alarm[0]=mouse_refresh*room_speed

editor_width=500
editor_showt_border=15
editor_offset=0

bg_spr=spr_BG1
tileset_spr=spr_ts_blocks

tile_idx=[1, 0]

testing_room=rm_editorplayground
stored_cam=[0, 0]
stored_bg=[[255, 255, 255]]

store=noone

editing=false

_a=false