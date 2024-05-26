if room==rm_editor {
	return
}

key_left=keyboard_check(vk_left)
key_right=keyboard_check(vk_right)
key_jump_press=keyboard_check_pressed(vk_space) or mouse_check_button_pressed(mb_left)
key_jump_rel=keyboard_check_released(vk_space) or mouse_check_button_released(mb_left)
var key_save=keyboard_check_pressed(ord("S"))

if key_save {
	var lobjects=get_level_objects(obj_gamecontroller.initial_objects)
	var ltiles=get_level_tiles()
	save_level_to_file(lobjects, ltiles, "objects.txt", "tiles.txt")
}

if key_jump_press {
	jumping=true
}
if key_jump_rel {
	jumping=false
}
else if place_meeting(x, y, obj_jumpstop) {
	var jstop=instance_place(x, y, obj_jumpstop)
	
	if !jstop.activated {
		jstop.activated=true
		jumping=false
	}
}

key_jump=jumping

if level_mode {
	key_left=0
	key_right=1
}

switch (state) {
	case states.normal:
		player_normal()
		break
	
	case states.fall:
		player_fall()
		break
	
	case states.ship:
		player_ship()
		break
	
	case states.ufo:
		player_ufo()
		break
	
	case states.wave:
		player_wave()
		break
	
	case states.ball:
		player_ball()
		break
	
	case states.robot:
		player_robot()
		break
	
	case states.robot_jump:
		player_robot_jump()
		break
	
	case states.robot_fall:
		player_robot_fall()
		break
	
	case states.spider:
		player_spider()
		break
	
	case states.swipe:
		player_swipe()
		break
	
	case states.swing:
		player_swing()
		break
	
	case states.loose:
		player_loose()
		break
	
	case states.win:
		player_win()
		break
}

player_collide()

if instance_exists(swipeID) and swipeID.image_alpha==0 and state!=states.swipe {
	swipeID.image_alpha=1
}

if instance_exists(spider_trailID) {
	spider_trailID.x=x
	spider_trailID.image_xscale=point_distance(spider_trailID.x, spider_trailID.y, x, y)/sprite_get_width(spider_trailID.sprite_index)
	spider_trailID.image_yscale=abs(image_yscale)
	spider_trailID.image_angle=point_direction(spider_trailID.x, spider_trailID.y, x, y)
}

if state==states.ship or state==states.ufo {
	if !instance_exists(mini_iconID) {
		mini_iconID=instance_create_layer(x, y, "Instances", obj_miniicon)
		mini_iconID.sprite_index=spr_idle
		mini_iconID.depth=depth+1
		mini_iconID.image_angle=rotation
		mini_iconID.image_xscale=image_xscale/2
		mini_iconID.image_yscale=image_yscale/2
		mini_iconID.palette_col1=palette_col1
		mini_iconID.palette_col2=palette_col2
		mini_iconID.replace_col1=replace_col1
		mini_iconID.replace_col2=replace_col2
	}
}
else if instance_exists(mini_iconID) {
	instance_destroy(mini_iconID)
}

if instance_exists(mini_iconID) {
	mini_iconID.image_angle=rotation
	mini_iconID.x=x
	mini_iconID.y=y
	if state==states.ship {
		mini_iconID.y=y-10*grav_dir
	}
	mini_iconID.image_xscale=image_xscale/2
	mini_iconID.image_yscale=image_yscale/2
}

if grounded and state!=states.loose {
	var part=create_particles(1, spr_particle, 1, x, y+abs(sprite_height/2)*grav_dir, -hsp/2*abs(image_xscale), -irandom(7)*grav_dir, false)
	for (var p=0;p<array_length(part);p++) {
		part[p].x=irandom_range(x-sprite_width/2, x)
		part[p].fade_sp=0.1
	}
}