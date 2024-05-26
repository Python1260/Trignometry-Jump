function load_tiles(tileset_spr) {
	var tiles=layer_tilemap_get_id(layer_get_id("Tiles"))
	var tileIDs=[]
	var twidth=tilemap_get_width(tiles)
	var theight=tilemap_get_height(tiles)
	var cell_width=tilemap_get_tile_width(tiles)
	var cell_height=tilemap_get_tile_height(tiles)
	var spr_width=sprite_get_width(tileset_spr)
	var spr_height=sprite_get_height(tileset_spr)

	for (var w=0;w<twidth;w++) {
		for (var h=0;h<theight;h++) {
			var tile=tilemap_get(tiles, w, h)
			var tilex=w*cell_width
			var tiley=h*cell_height
			var tileidx=tile_get_index(tile)
			var tile_spr_x=tileidx%floor(spr_width/cell_width)
			var tile_spr_y=floor(tileidx/floor(spr_width/cell_width))
		
			if tile>0 {
				var _t=instance_create_layer(tilex, tiley, "Instances", obj_tile)
				_t.sprite_index=tileset_spr
				_t.image_speed=sprite_get_speed(tileset_spr)
				_t.t_left=tile_spr_x*cell_width
				_t.t_top=tile_spr_y*cell_height
				_t.t_width=cell_width
				_t.t_height=cell_height
				tileIDs[array_length(tileIDs)]=_t.id
			}
		}
	}
	
	return tileIDs
}

function setup_objects(objects) {
	var okey=ds_map_find_first(objects)
	
	for (var o=0;o<ds_map_size(objects);o++) {
		var vars=ds_map_find_value(objects, okey)
		var varskey=ds_map_find_first(vars)
		var inst=instance_create_layer(0, 0, "Instances", ds_map_find_value(vars, "object_index"))
		
		for (var v=0;v<ds_map_size(vars);v++) {
			if varskey!="object_index" and varskey!="sprite_index" and varskey!="mask_index" {
				variable_instance_set(inst, varskey, ds_map_find_value(vars, varskey))
			}
			
			varskey=ds_map_find_next(vars, varskey)
		}
		
		okey=ds_map_find_next(objects, okey)
	}
}

function setup_tiles(tiles) {
}

function load_instances() {
	var linstances=[]
	var instnum=instance_number(all)
	
	for (var n=0;n<instnum;n++) {
		var inst=instance_find(all, n)

		if instance_exists(inst) and inst.object_index!=obj_gamecontroller and inst.object_index!=obj_editor {
			linstances[array_length(linstances)]=inst.id
		}
	}
	
	return linstances
}

function load_game_objects() {
	var _go=[]
	var _obj=0
	
	while true {
		if object_exists(_obj) {
			if string_starts_with(object_get_name(_obj), "obj_") and _obj!=obj_editor and _obj!=obj_gamecontroller {
				_go[array_length(_go)]=_obj
			}
		}
		else {
			break
		}
		_obj+=1
	}
	
	return _go
}

function get_level_objects(objects) {
	var sobjects=ds_map_create()
	var ocounter=0
	
	for (var n=0;n<array_length(objects);n++) {
		var inst=objects[n]

		if instance_exists(inst) and inst.object_index!=obj_gamecontroller and inst.object_index!=obj_editor {
			var instvariables=variable_instance_get_names(inst)
			var varmap=ds_map_create()
			var basevariables=["object_index", "x", "y", "image_xscale", "image_yscale", "image_angle", "image_blend", "image_alpha", "image_index", "sprite_index", "image_speed", "direction", "speed", "mask_index", "depth", "visible", "persistent"]
			instvariables=array_concat(instvariables, basevariables)
		
			for (var v=0;v<array_length(instvariables);v++) {
				ds_map_add(varmap, instvariables[v], variable_instance_get(inst, instvariables[v]))
			}
		
			ds_map_add(sobjects, ocounter, varmap)
			ocounter+=1
		}
	}
	
	return sobjects
}

function get_level_tiles() {
	var tiles=layer_tilemap_get_id(layer_get_id("Tiles"))
	var tilepos=ds_map_create()
	var twidth=tilemap_get_width(tiles)
	var theight=tilemap_get_height(tiles)
	var cell_width=tilemap_get_tile_width(tiles)
	var cell_height=tilemap_get_tile_height(tiles)
	var tcounter=0

	for (var w=0;w<twidth;w++) {
		for (var h=0;h<theight;h++) {
			var tile=tilemap_get(tiles, w, h)
			var tilex=w*cell_width
			var tiley=h*cell_height
			var tileidx=tile_get_index(tile)
		
			ds_map_add(tilepos, tcounter, [tileidx, tilex, tiley])
			tcounter+=1
		}
	}
	
	return tilepos
}

function save_level_to_file(levelobjects, leveltiles, ofilename, tfilename) {
	var objmap=ds_map_create()
	var key=ds_map_find_first(levelobjects)
	var len=ds_map_size(levelobjects)
	
	for (var o=0;o<len;o+=1) {
		var val=ds_map_find_value(levelobjects, key)
		ds_map_add(objmap, key, json_encode(val))
		key=ds_map_find_next(levelobjects, key)
	}
	objmap=json_encode(objmap)
	
	var tilemap=ds_map_create()
	ds_map_copy(tilemap, leveltiles)
	tilemap=json_encode(tilemap)
	
	var ofile=file_text_open_write(ofilename)
	file_text_write_string(ofile, objmap)
	file_text_close(ofile)
	var tfile=file_text_open_write(tfilename)
	file_text_write_string(tfile, tilemap)
	file_text_close(tfile)
}

function load_level_from_file(ofilename, tfilename) {
	if !file_exists(ofilename) or !file_exists(tfilename) {
		show_error("InternalError: no data files found.", true)
		return
	}
	var ofile=file_text_open_read(ofilename)
	var odata=file_text_read_string(ofile)
	file_text_close(ofile)
	var tfile=file_text_open_read(tfilename)
	var tdata=file_text_read_string(tfile)
	file_text_close(tfile)
	
	odata=json_decode(odata)
	var key=ds_map_find_first(odata)
	var len=ds_map_size(odata)
	for (var o=0;o<len;o+=1) {
		var val=ds_map_find_value(odata, key)
		ds_map_set(odata, key, json_decode(val))
		key=ds_map_find_next(odata, key)
	}
	
	tdata=json_decode(tdata)
	
	return [odata, tdata]
}

function get_trigger_objects(object_code) {
	var inum=instance_number(all)
	var objects=[]
	
	for (var i=0;i<inum;i++) {
		var inst=instance_find(all, i)
		
		if variable_instance_exists(inst, "object_code") and inst.object_code==object_code {
			objects[array_length(objects)]=inst.id
			
			if variable_instance_exists(inst, "take_tiles") and inst.take_tiles==true {
				with (inst) {
					var _tiles=ds_list_create()
					var _tilesnum=instance_place_list(x, y, obj_tile, _tiles, false)
			
					for (var t=0;t<_tilesnum;t++) {
						objects[array_length(objects)]=_tiles[| t]
					}
				}
			}
		}
	}
	
	return objects
}

/*function set_variables(objects) {
	var key=ds_map_find_first(objects)
	var obj_len=ds_map_size(objects)
	var to_delete=[]
	for (var o=0;o<ds_map_size(obj_len);o++) {
		if instance_exists(key) {
			var variables=ds_map_find_value(objects, key)
			var v_key=ds_map_find_first(variables)
	
			for (var v=0;v<ds_map_size(variables);v++) {
				var variable=ds_map_find_value(variables, v_key)
				variable_instance_set(key, v_key, variable)
		
				v_key=ds_map_find_next(variables, v_key)
			}
		}
		else {
			to_delete[array_length(to_delete)]=key
		}
	
		key=ds_map_find_next(objects, key)
	}
	for (var d=0;d<array_length(to_delete);d++) {
		ds_map_delete(objects, to_delete[d])
	}
	
	return objects
}*/