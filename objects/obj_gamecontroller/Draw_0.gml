var cam=view_camera[0]
var camx=camera_get_view_x(cam)
var camy=camera_get_view_y(cam)
var camw=camera_get_view_width(cam)
var camh=camera_get_view_height(cam)

if room==rm_editor or room==rm_menu {
	return
}

draw_set_color(c_black)
draw_rectangle(0, 0, room_width, room_height, false)
draw_set_color(c_white)

var plr_ratio=(camx-obj_player.xstart)/(room_width-obj_player.xstart)
draw_sprite_tiled_ext(bgspr, -1, camx-(max_bg_move*plr_ratio)*sign(draw_dir), room_height-sprite_get_height(bgspr), sign(draw_dir), 1, make_color_rgb(bgblend[0], bgblend[1], bgblend[2]), bgalpha)

ds_list_clear(objects)
var objnum = instance_number(all);
for (var o = 0; o < objnum; o++) {
	var obj=instance_find(all, o)
	if rectangle_in_rectangle(obj.bbox_left, obj.bbox_top, obj.bbox_right, obj.bbox_bottom, camx, camy, camx+camw, camy+camh) {
		ds_list_add(objects, obj)
	}
}
objects=sort_objects_by_depth(objects)

for (var o = 0; o < ds_list_size(objects); o++) {
	var inst = objects[| o]
	if sprite_exists(inst.sprite_index) and inst.visible {
		var draw_x=(camx+camw/2)+(inst.x-(camx+camw/2))*draw_dir//lerp(inst.x, room_width - inst.x, (draw_dir + 1) / 2)
		var draw_y=inst.y
		var scale_factor=1
		var draw_xscale=inst.image_xscale*draw_dir
		var draw_yscale=inst.image_yscale
		var draw_alpha=inst.image_alpha
		var _shader=false
		
		if inst.object_index!=obj_particle and inst.object_index!=obj_wavetrail and inst.object_index!=obj_spidertrail and inst.object_index!=obj_gravchange and inst.object_index!=obj_miniicon {
			if draw_x>(camx+camw-draw_transition_border) {
				scale_factor=(camx+camw-draw_x)/draw_transition_border
			}
			else if draw_x<(camx+draw_transition_border) {
				scale_factor=(draw_x-camx)/draw_transition_border
			}
		
			switch (transition_type) {
				case transition_types.scale_up:
					draw_xscale*=scale_factor
					draw_yscale*=scale_factor
					break
				
				case transition_types.scale_down:
					draw_xscale*=(2-scale_factor)
					draw_yscale*=(2-scale_factor)
					break
				
				case transition_types.alpha:
					draw_alpha*=scale_factor
					break
				
				case transition_types.object_up:
					draw_alpha*=scale_factor
					draw_y*=(2-scale_factor)
					break
				
				case transition_types.object_down:
					draw_alpha*=scale_factor
					draw_y*=scale_factor
					break
				
				case transition_types.player_up:
					draw_alpha*=scale_factor
					if inst.y<obj_player.y {
						draw_y*=(2-scale_factor)
					}
					else {
						draw_y*=scale_factor
					}
					break
				
				case transition_types.player_down:
					draw_alpha*=scale_factor
					if inst.y<obj_player.y {
						draw_y*=scale_factor
					}
					else {
						draw_y*=(2-scale_factor)
					}
					break
			}
		}
		
		if variable_instance_exists(inst, "palette_col1") and variable_instance_exists(inst, "palette_col2") {
				_shader=true
				
				var plr_col1=inst.palette_col1
				var plr_col2=inst.palette_col2
				var rep_col1=def_col1
				var rep_col2=def_col2
				
				if variable_instance_exists(inst, "replace_col1") {
					rep_col1=inst.replace_col1
				}
				if variable_instance_exists(inst, "replace_col2") {
					rep_col2=inst.replace_col2
				}
			
				shader_set(plr_shader)
				shader_set_uniform_f(sh_handle_range, 1)
				shader_set_uniform_f(sh_handle_match1, rep_col1[0], rep_col1[1], rep_col1[2])
				shader_set_uniform_f(sh_handle_match2, rep_col2[0], rep_col2[1], rep_col2[2])
				shader_set_uniform_f(sh_handle_replace1, plr_col1[0], plr_col1[1], plr_col1[2])
				shader_set_uniform_f(sh_handle_replace2, plr_col2[0], plr_col2[1], plr_col2[2])
		}
		
		if inst.object_index==obj_player {
			draw_sprite_ext(inst.sprite_index, inst.image_index, draw_x, inst.y, inst.image_xscale*draw_dir, inst.image_yscale, inst.rotation*draw_dir, inst.image_blend, inst.image_alpha)
		}
		else if inst.object_index==obj_tile {
			draw_sprite_part_ext(inst.sprite_index, inst.image_index, inst.t_left, inst.t_top, inst.t_width, inst.t_height, draw_x, draw_y, draw_xscale, draw_yscale, inst.image_blend, draw_alpha)
		}
		else {
			draw_sprite_ext(inst.sprite_index, inst.image_index, draw_x, draw_y, draw_xscale, draw_yscale, inst.image_angle*draw_dir, inst.image_blend, draw_alpha)
		}
		
		if _shader {
			shader_reset()
		}
	}
}
/*var tiles=layer_tilemap_get_id(layer_get_id("Tiles"))
var twidth=tilemap_get_width(tiles)
var theight=tilemap_get_height(tiles)
var cell_width=tilemap_get_tile_width(tiles)
var cell_height=tilemap_get_tile_height(tiles)
var spr_width=sprite_get_width(spr_ts_blocks)
var spr_height=sprite_get_height(spr_ts_blocks)

for (var w=0;w<twidth;w++) {
	for (var h=0;h<theight;h++) {
		var tile=tilemap_get(tiles, w, h)
		var tilex=w*cell_width
		var tiley=h*cell_height
		var tileidx=tile_get_index(tile)
		var tile_spr_x=tileidx%floor(spr_width/cell_width)
		var tile_spr_y=floor(tileidx/floor(spr_width/cell_width))-1
		var draw_x = (camx+camw/2)+(tilex - (camx+camw/2)) * draw_dir
		
		draw_sprite_part(spr_ts_blocks, 1, tile_spr_x*cell_width, tile_spr_y*cell_height, cell_width, cell_height, tilex, tiley)
	}
}*/