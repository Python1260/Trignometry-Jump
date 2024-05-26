var key_select=mouse_check_button(mb_left)
var key_select_press=mouse_check_button_pressed(mb_left)
var key_select_rel=mouse_check_button_released(mb_left)

var cam=view_camera[0]
var camx=camera_get_view_x(cam)
var camy=camera_get_view_y(cam)
var camw=camera_get_view_width(cam)
var camh=camera_get_view_height(cam)

if key_select_press {
	if point_in_rectangle(mouse_x, mouse_y, camx+camw-sprite_get_width(spr_editor), camy, camx+camw, camy+sprite_get_height(spr_editor)) {
		if room==rm_editor or room==testing_room {
			if room==testing_room {
				room_goto(rm_editor)
				game_objects=reset_object_ids(game_objects)
				show_message(ds_map_size(game_objects))
				alarm[1]=1*room_speed
				editing=true
				obj_gamecontroller.level_tiles=[]
				camera_set_view_target(cam, noone)
				camera_set_view_pos(cam, stored_cam[0], stored_cam[1])
				obj_gamecontroller.bgblend=stored_bg[0]
				_a=true
			}
			else {
				selectID=noone
				show_type=0
				object_type=0
				edit_type=0
				variable_idx=0
				tile_idx=[1, 0]
				
				editing=false
				stored_cam=[camx, camy]
				//show_message(instance_find(obj_solid, 0).id)
				stored_bg=[obj_gamecontroller.bgblend]
				
				var cobjects=ds_map_create()
				var _f=ds_map_find_first(game_objects)
				
				for (var i=0;i<ds_map_size(game_objects);i++) {
					ds_map_add(cobjects, _f.object_index, ds_map_find_value(game_objects, _f))
					_f=ds_map_find_next(game_objects, _f)
				}
				
				room_goto(testing_room)
				var _objs=load_objects(cobjects)
				obj_gamecontroller.level_tiles=load_tiles(tileset_spr)
				camera_set_view_target(cam, obj_player)
			}
		}
		else {
			room_goto(rm_editor)
			//room_set_persistent(rm_editor, true)
			editing=true
			selectID=noone
			show_type=0
			object_type=0
			edit_type=0
			variable_idx=0
			tile_idx=[1, 0]
		}
	}
	else if point_in_rectangle(mouse_x, mouse_y, camx+camw-sprite_get_width(spr_save), camy+sprite_get_height(spr_play), camx+camw, camy+sprite_get_height(spr_play)+sprite_get_height(spr_save)) and editing {
		save_level_to_file(game_objects, tiles_to_map(), "levelo.txt", "levelt.txt")
	}
}

if !editing {
	return
}

if show_types[show_type]==show_modes.variable and instance_exists(selectID) {
	var map_val=ds_map_find_value(game_objects, selectID)
	
	if variable_idx>=ds_map_size(map_val) {
		if key_select_press {
			ds_map_add(map_val, keyboard_string, "0")
			ds_map_set(game_objects, selectID, map_val)
			keyboard_string=string(ds_map_find_value(map_val, ds_map_find_last(map_val)))
		}
		return
	}
	
	var _k=ds_map_find_first(map_val)
	var tkey=""
	for (var v=0;v<ds_map_size(map_val);v++) {
		if v==variable_idx {
			tkey=_k
		}
		_k=ds_map_find_next(map_val, _k)
	}
	
	if string_ends_with(tkey, "ID") and (ds_map_find_value(map_val, tkey)=="0" or ds_map_find_value(map_val, tkey)=="") {
		if key_select_press {
			ds_map_set(map_val, tkey, collision_point(mouse_x, mouse_y, all, false, true))
		}
		return
	}
}

/*var inum=instance_number(all)
for (var i=0;i<inum;i++) {
	var inst=instance_find(all, i)
	show_message(string(ds_map_keys_to_array(game_objects))+", "+string(inst.id))
	if !array_contains(ds_map_keys_to_array(game_objects), inst.id) and inst.object_index!=obj_editor and inst.object_index!=obj_gamecontroller {
		var variable_map=ds_map_create()
		ds_map_add(variable_map, "image_xscale", inst.image_xscale)
		ds_map_add(variable_map, "image_yscale", inst.image_yscale)
		ds_map_add(variable_map, "image_angle", inst.image_angle)
		ds_map_add(variable_map, "x", inst.x)
		ds_map_add(variable_map, "y", inst.y)
		ds_map_add(game_objects, inst.id, variable_map)
	}
}*/

if key_select_press {
	mouse_press_pos=[mouse_x, mouse_y]
	
	var _clicked=false
	
	var dx=0
	for (var t=0;t<array_length(show_types);t++) {
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
		if point_in_rectangle(mouse_x, mouse_y, camx+dx, camy+0, camx+dx+string_width(text), camy+0+string_height(text)) {
			_clicked=true
		}
		
		dx+=string_width(text)+editor_showt_border
	}
	
	if !_clicked {
		switch (show_types[show_type]) {
			case show_modes.object:
				for (var o=0;o<array_length(objects_types);o++) {
					var obj=objects_types[o]
					var objname=object_get_name(obj)
					var dx=editor_width/2-string_width(objname)/2
					var dy=string_height(objname)*(o+1)
	
					if point_in_rectangle(mouse_x, mouse_y, camx+dx, camy+editor_offset+dy, camx+dx+string_width(objname), camy+editor_offset+dy+string_height(objname)) {
						_clicked=true
						break
					}
				}
				break
			case show_modes.edit:
				for (var t=0;t<array_length(edit_types);t++) {
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
			
					if point_in_rectangle(mouse_x, mouse_y, camx+dx, camy+editor_offset+dy, camx+dx+string_width(text), camy+editor_offset+dy+string_height(text)) {
						_clicked=true
						break
					}
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
							if point_in_rectangle(mouse_x, mouse_y, camx+dx, camy+dy, camx+dx+sprite_get_width(spr_addvariable), camy+editor_offset+dy+sprite_get_height(spr_addvariable)) {
								_clicked=true
								break
							}
						}
						else {
							var text=string(key)+"="+string(ds_map_find_value(v, key))
							var dx=editor_width/2-string_width(text)/2
							var dy=string_height(text)*(o+1)
			
							if point_in_rectangle(mouse_x, mouse_y, camx+dx, camy+dy, camx+dx+string_width(text), camy+editor_offset+dy+string_height(text)) {
								_clicked=true
								break
							}
						}
						
						key=ds_map_find_next(v, key)
					}
					
					var dx=editor_width/2-sprite_get_width(spr_delete)/2
					var dy=camh-sprite_get_height(spr_delete)
					if !_clicked and point_in_rectangle(mouse_x, mouse_y, camx+dx, camy+editor_offset+dy, camx+dx+sprite_get_width(spr_delete), camy+editor_offset+dy+sprite_get_height(spr_delete)) {
						_clicked=true
					}
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
						var dx=w*cell_width
						var dy=string_height("A")+h*cell_height
				
						if point_in_rectangle(mouse_x, mouse_y, camx+dx, camy+editor_offset+dy, camx+dx+cell_width, camy+editor_offset+dy+cell_height) {
							_clicked=true
							break
						}
					}
				}
				break
		}
	}	
	
	if !_clicked {
		var _inst=collision_point(mouse_x, mouse_y, all, false, true)
		
		if _inst {
			if _inst.id==selectID {
				selectID=noone
				variable_idx=0
			}
			else {
				selectID=_inst
				var gobj=ds_map_find_value(game_objects, selectID)
				keyboard_string=string(ds_map_find_value(gobj, ds_map_find_first(gobj)))
				variable_idx=0
			}
		}
	}
}

if key_select {
	var _clicked=false
	
	var dx=0
	for (var t=0;t<array_length(show_types);t++) {
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
		if point_in_rectangle(mouse_x, mouse_y, camx+dx, camy+0, camx+dx+string_width(text), camy+0+string_height(text)) {
			_clicked=true
		}
		
		dx+=string_width(text)+editor_showt_border
	}
	
	if !_clicked {
		switch (show_types[show_type]) {
			case show_modes.object:
				for (var o=0;o<array_length(objects_types);o++) {
					var obj=objects_types[o]
					var objname=object_get_name(obj)
					var dx=editor_width/2-string_width(objname)/2
					var dy=string_height(objname)*(o+1)
	
					if point_in_rectangle(mouse_x, mouse_y, camx+dx, camy+editor_offset+dy, camx+dx+string_width(objname), camy+editor_offset+dy+string_height(objname)) {
						_clicked=true
						break
					}
				}
				break
			case show_modes.edit:
				for (var t=0;t<array_length(edit_types);t++) {
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
			
					if point_in_rectangle(mouse_x, mouse_y, camx+dx, camy+editor_offset+dy, camx+dx+string_width(text), camy+editor_offset+dy+string_height(text)) {
						_clicked=true
						break
					}
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
							if point_in_rectangle(mouse_x, mouse_y, camx+dx, camy+editor_offset+dy, camx+dx+sprite_get_width(spr_addvariable), camy+editor_offset+dy+sprite_get_height(spr_addvariable)) {
								_clicked=true
								break
							}
						}
						else {
							var text=string(key)+"="+string(ds_map_find_value(v, key))
							var dx=editor_width/2-string_width(text)/2
							var dy=string_height(text)*(o+1)
			
							if point_in_rectangle(mouse_x, mouse_y, camx+dx, camy+editor_offset+dy, camx+dx+string_width(text), camy+editor_offset+dy+string_height(text)) {
								_clicked=true
								break
							}
						}
						
						key=ds_map_find_next(v, key)
					}
					
					var dx=editor_width/2-sprite_get_width(spr_delete)/2
					var dy=camh-sprite_get_height(spr_delete)
					if !_clicked and point_in_rectangle(mouse_x, mouse_y, camx+dx, camy+editor_offset+dy, camx+dx+sprite_get_width(spr_delete), camy+editor_offset+dy+sprite_get_height(spr_delete)) {
						_clicked=true
					}
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
						var dx=w*cell_width
						var dy=string_height("A")+h*cell_height
				
						if point_in_rectangle(mouse_x, mouse_y, camx+dx, camy+editor_offset+dy, camx+dx+cell_width, camy+editor_offset+dy+cell_height) {
							_clicked=true
							break
						}
					}
				}
				break
		}
	}	
	
	if instance_exists(selectID) and !_clicked and !point_in_rectangle(mouse_x, mouse_y, camx+camw-sprite_get_width(spr_editor), camy, camx+camw, camy+sprite_get_height(spr_editor)) and !point_in_rectangle(mouse_x, mouse_y, camx+camw-sprite_get_width(spr_save), camy+sprite_get_height(spr_play), camx+camw, camy+sprite_get_height(spr_play)+sprite_get_height(spr_save)) and show_types[show_type]!=show_modes.tiles and point_distance(mouse_press_pos[0], mouse_press_pos[1], mouse_x, mouse_y)>object_thresold {
		switch (edit_types[edit_type]) {
			case edit_modes.move:
				selectID.x=mouse_x
				selectID.y=mouse_y
				
				var map_val=ds_map_find_value(game_objects, selectID)
				ds_map_replace(map_val, "x", selectID.x)
				ds_map_replace(map_val, "y", selectID.y)
				ds_map_replace(game_objects, selectID, map_val)
				break
			
			case edit_modes.scale:
				var diffx=mouse_x-selectID.x
				var diffy=mouse_y-selectID.y
				
				if sprite_exists(selectID.sprite_index) {
					selectID.image_xscale=diffx/sprite_get_width(selectID.sprite_index)
					selectID.image_yscale=diffy/sprite_get_height(selectID.sprite_index)
					if selectID.object_index==obj_orb {
						selectID.start_xscale=selectID.image_xscale
						selectID.start_yscale=selectID.image_yscale
					}
					
					var map_val=ds_map_find_value(game_objects, selectID)
					ds_map_replace(map_val, "image_xscale", selectID.image_xscale)
					ds_map_replace(map_val, "image_yscale", selectID.image_yscale)
					ds_map_replace(game_objects, selectID, map_val)
				}
				break
			
			case edit_modes.rotate:
				selectID.image_angle=point_direction(selectID.x, selectID.y, mouse_x, mouse_y)
				var map_val=ds_map_find_value(game_objects, selectID)
				ds_map_replace(map_val, "image_angle", selectID.image_angle)
				ds_map_replace(game_objects, selectID, map_val)
				break
		}
	}
	else if !_clicked and !point_in_rectangle(mouse_x, mouse_y, camx+camw-sprite_get_width(spr_editor), camy, camx+camw, camy+sprite_get_height(spr_editor)) and !point_in_rectangle(mouse_x, mouse_y, camx+camw-sprite_get_width(spr_save), camy+sprite_get_height(spr_play), camx+camw, camy+sprite_get_height(spr_play)+sprite_get_height(spr_save)) {
		if show_types[show_type]!=show_modes.tiles {
			if point_in_rectangle(mouse_press_pos[0], mouse_press_pos[1], camx, camy, camx+editor_width, camy+camh) {
				editor_offset+=mouse_y-old_ms_pos[1]
			}
			else {
				var diffx=mouse_x-old_ms_pos[0]
				var diffy=mouse_y-old_ms_pos[1]
		
				camera_set_view_pos(cam, camx-diffx, camy-diffy)
			}
		}
		else {
			var tiles=layer_tilemap_get_id(layer_get_id("Tiles"))
			var cell_width=tilemap_get_tile_width(tiles)
			var cell_height=tilemap_get_tile_height(tiles)
			var spr_width=sprite_get_width(tileset_spr)
			var spr_height=sprite_get_height(tileset_spr)
			var tilepos=[floor(mouse_x/cell_width), floor(mouse_y/cell_height)]
			var tiledata=tilemap_get(tiles, tilepos[0], tilepos[1])
			tiledata=tile_set_index(tiledata, tile_idx[1]*(floor(spr_height/cell_height)+1)+tile_idx[0])
			
			tilemap_set(tiles, tiledata, tilepos[0], tilepos[1])
		}
	}
}

if key_select_rel {
	var _clicked=false
	
	var dx=0
	for (var t=0;t<array_length(show_types);t++) {
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
		if point_in_rectangle(mouse_x, mouse_y, camx+dx, camy+0, camx+dx+string_width(text), camy+0+string_height(text)) {
			if show_type!=t and show_types[t]==show_modes.variable and instance_exists(selectID) {
				var map_val=ds_map_find_value(game_objects, selectID)
				keyboard_string=string(ds_map_find_value(map_val, ds_map_find_first(map_val)))
			}
			
			editor_offset=0
			show_type=t
			_clicked=true
		}
		
		dx+=string_width(text)+editor_showt_border
	}
	
	if !_clicked {
		switch (show_types[show_type]) {
			case show_modes.object:
				for (var o=0;o<array_length(objects_types);o++) {
					var obj=objects_types[o]
					var objname=object_get_name(obj)
					var dx=editor_width/2-string_width(objname)/2
					var dy=string_height(objname)*(o+1)
	
					if point_in_rectangle(mouse_x, mouse_y, camx+dx, camy+editor_offset+dy, camx+dx+string_width(objname), camy+editor_offset+dy+string_height(objname)) {
						object_type=o
						_clicked=true
						break
					}
				}
				break
			case show_modes.edit:
				for (var t=0;t<array_length(edit_types);t++) {
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
			
					if point_in_rectangle(mouse_x, mouse_y, camx+dx, camy+editor_offset+dy, camx+dx+string_width(text), camy+editor_offset+dy+string_height(text)) {
						edit_type=t
						_clicked=true
						break
					}
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
							if point_in_rectangle(mouse_x, mouse_y, camx+dx, camy+editor_offset+dy, camx+dx+sprite_get_width(spr_addvariable), camy+editor_offset+dy+sprite_get_height(spr_addvariable)) {
								keyboard_string=""
								variable_idx=o
								_clicked=true
								break
							}
						}
						else {
							var text=string(key)+"="+string(ds_map_find_value(v, key))
							var dx=editor_width/2-string_width(text)/2
							var dy=string_height(text)*(o+1)
			
							if point_in_rectangle(mouse_x, mouse_y, camx+dx, camy+editor_offset+dy, camx+dx+string_width(text), camy+editor_offset+dy+string_height(text)) {
								keyboard_string=string(ds_map_find_value(v, key))
								variable_idx=o
								_clicked=true
								break
							}
						}
						
						key=ds_map_find_next(v, key)
					}
					
					var dx=editor_width/2-sprite_get_width(spr_delete)/2
					var dy=camh-sprite_get_height(spr_delete)
					if !_clicked and point_in_rectangle(mouse_x, mouse_y, camx+dx, camy+editor_offset+dy, camx+dx+sprite_get_width(spr_delete), camy+editor_offset+dy+sprite_get_height(spr_delete)) {
						instance_destroy(selectID)
						ds_map_delete(game_objects, selectID)
						_clicked=true
					}
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
						var dx=w*cell_width
						var dy=string_height("A")+h*cell_height
				
						if point_in_rectangle(mouse_x, mouse_y, camx+dx, camy+editor_offset+dy, camx+dx+cell_width, camy+editor_offset+dy+cell_height) {
							tile_idx=[w, h]
							_clicked=true
							break
						}
					}
				}
				break
		}
	}
	
	if point_distance(mouse_press_pos[0], mouse_press_pos[1], mouse_x, mouse_y)<=object_thresold and !collision_point(mouse_x, mouse_y, all, false, true) and !_clicked and !point_in_rectangle(mouse_x, mouse_y, camx+camw-sprite_get_width(spr_editor), camy, camx+camw, camy+sprite_get_height(spr_editor)) and !point_in_rectangle(mouse_x, mouse_y, camx+camw-sprite_get_width(spr_save), camy+sprite_get_height(spr_play), camx+camw, camy+sprite_get_height(spr_play)+sprite_get_height(spr_save)) and show_types[show_type]!=show_modes.tiles {
		var _obj=instance_create_layer(mouse_x, mouse_y, "Instances", objects_types[object_type])
		show_message("jest")
		variable_idx=0
		var variable_map=ds_map_create()
		ds_map_add(variable_map, "image_xscale", 1)
		ds_map_add(variable_map, "image_yscale", 1)
		ds_map_add(variable_map, "image_angle", 0)
		ds_map_add(variable_map, "x", _obj.x)
		ds_map_add(variable_map, "y", _obj.y)
		ds_map_add(variable_map, "object_index", _obj.object_index)
		ds_map_add(game_objects, _obj.id, variable_map)
		keyboard_string=string(ds_map_find_first(variable_map))
		selectID=_obj.id
	}
}

var key=ds_map_find_first(game_objects)
var obj_len=ds_map_size(game_objects)
var to_delete=[]
for (var o=0;o<ds_map_size(game_objects);o++) {
	if instance_exists(key) {
		var variables=ds_map_find_value(game_objects, key)
		var v_key=ds_map_find_first(variables)
	
		for (var v=0;v<ds_map_size(variables);v++) {
			var variable=ds_map_find_value(variables, v_key)
			
			try {
				variable_instance_set(key, v_key, variable)
			}
			catch (exception) {
			}
		
			v_key=ds_map_find_next(variables, v_key)
		}
	}
	else {
		to_delete[array_length(to_delete)]=key
	}
	
	key=ds_map_find_next(game_objects, key)
}
for (var d=0;d<array_length(to_delete);d++) {
	ds_map_delete(game_objects, to_delete[d])
}

if show_types[show_type]==show_modes.variable and instance_exists(selectID) {
	var map_val=ds_map_find_value(game_objects, selectID)
	var key=ds_map_find_first(map_val)
	
	for (var o=0;o<ds_map_size(map_val);o++) {
		if o==variable_idx {
			try {
				ds_map_replace(map_val, key, real(keyboard_string))
			}
			catch (exception) {
				ds_map_replace(map_val, key, keyboard_string)
			}
		}
		
		key=ds_map_find_next(map_val, key)
	}
	
	ds_map_replace(game_objects, selectID, map_val)
}

layer_background_sprite(layer_background_get_id(layer_get_id("Background")), bg_spr)

try {
	/*var o=ds_map_find_value(ds_map_find_value(stored_objects, ds_map_find_first(stored_objects)), "y")
	var n=ds_map_find_value(ds_map_find_value(game_objects, ds_map_find_first(game_objects)), "y")
	if o==n {
		show_debug_message(string(o)+", "+string(n))
	}
	else {
		show_message("a")
	}*/
}
catch (e) {
}

show_debug_message(instance_number(all))

if _a {
}