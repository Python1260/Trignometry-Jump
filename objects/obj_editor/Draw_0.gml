var cam=view_camera[0]
var camx=camera_get_view_x(cam)
var camy=camera_get_view_y(cam)
var camw=camera_get_view_width(cam)
var camh=camera_get_view_height(cam)

draw_set_font(ft_editor)

draw_sprite(spr_play, -1, camx+camw-sprite_get_width(spr_play), camy)
draw_sprite(spr_save, -1, camx+camw-sprite_get_width(spr_save), camy+sprite_get_height(spr_play))

if !editing {
	return
}

draw_set_color(c_black)
draw_set_alpha(0.75)
draw_rectangle(camx, camy, camx+editor_width, camy+camh, false)
draw_set_alpha(1)
draw_set_color(c_white)

switch (show_types[show_type]) {
	case show_modes.object:
		for (var o=0;o<array_length(objects_types);o++) {
			var obj=objects_types[o]
			var objname=object_get_name(obj)
			var dx=editor_width/2-string_width(objname)/2
			var dy=string_height(objname)*(o+1)
			
			if o==object_type {
				draw_set_color(c_white)
			}
			else {
				draw_set_color(c_gray)
			}
	
			draw_text(camx+dx, camy+editor_offset+dy, objname)
		}
		break
	
	case show_modes.edit:
		for (var t=0;t<array_length(edit_types);t++) {
			if t==edit_type {
				draw_set_color(c_white)
			}
			else {
				draw_set_color(c_gray)
			}
			var edit=edit_types[t]
			var text=""
			
			switch (edit) {
				case edit_modes.move:
					text="MOVE"
					break
				case edit_modes.scale:
					text="SCALE"
					break
				case edit_modes.rotate:
					text="ROTATE"
					break
			}
			var dx=editor_width/2-string_width(text)/2
			var dy=string_height(text)*(t+1)
			
			draw_text(camx+dx, camy+editor_offset+dy, text)
		}
		break
		
	case show_modes.variable:
		if instance_exists(selectID) {
			var v=ds_map_find_value(game_objects, selectID)
			var key=ds_map_find_first(v)
			
			for (var o=0;o<=ds_map_size(v);o++) {
				if o==ds_map_size(v) {
					var dx=editor_width/2-sprite_get_width(spr_addvariable)/2
					var dy=string_height("A")*(o+1)
					if variable_idx>=ds_map_size(v) {
						dy=string_height("A")*(o+2)
					}
					draw_sprite(spr_addvariable, -1, camx+dx, camy+editor_offset+dy)
				}
				else {
					if o==variable_idx {
						draw_set_color(c_white)
					}
					else {
						draw_set_color(c_gray)
					}
					var text=string(key)+"="+string(ds_map_find_value(v, key))
					var dx=editor_width/2-string_width(text)/2
					var dy=string_height(text)*(o+1)
			
					draw_text(camx+dx, camy+editor_offset+dy, text)
				}
				
				key=ds_map_find_next(v, key)
			}
			
			if variable_idx>=ds_map_size(v) {
				var text=keyboard_string
				draw_text(camx+editor_width/2-string_width(text)/2, camy+editor_offset+(ds_map_size(v)+1)*string_height(text), text)
			}
			
			var dx=editor_width/2-sprite_get_width(spr_delete)/2
			var dy=camh-sprite_get_height(spr_delete)
			draw_sprite(spr_delete, -1, camx+dx, camy+editor_offset+dy)
		}
		break
	
	case show_modes.tiles:
		var tiles=layer_tilemap_get_id(layer_get_id("Tiles"))
		var cell_width=tilemap_get_tile_width(tiles)
		var cell_height=tilemap_get_tile_height(tiles)
		var spr_width=sprite_get_width(tileset_spr)
		var spr_height=sprite_get_height(tileset_spr)
		
		for (var w=0;w<(spr_width/cell_width);w++) {
			for (var h=0;h<(spr_height/cell_height);h++) {
				var t_color=c_gray
				if w==tile_idx[0] and h==tile_idx[1] {
					t_color=c_white
				}
				var dx=w*cell_width
				var dy=string_height("A")+h*cell_height
				
				draw_sprite_part_ext(tileset_spr, -1, w*cell_width, h*cell_height, cell_width, cell_height, camx+dx, camy+editor_offset+dy, 1, 1, t_color, 1)
			}
		}
		break
}

var dx=0
for (var t=0;t<array_length(show_types);t++) {
	if t==show_type {
		draw_set_color(c_red)
	}
	else {
		draw_set_color(c_yellow)
	}
	var edit=show_types[t]
	var text=""
			
	switch (edit) {
		case show_modes.object:
			text="OBJECT"
			break
		case show_modes.edit:
			text="EDIT"
			break
		case show_modes.variable:
			text="VARIABLE"
			break
		case show_modes.tiles:
			text="TILES"
			break
	}	
	draw_text(camx+dx, camy, text)
	dx+=string_width(text)+editor_showt_border
}