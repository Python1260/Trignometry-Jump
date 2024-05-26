function player_normal() {
	sprite_index=spr_idle
	
	rsp=0
	var move=key_right-key_left
	hsp=approach(hsp, move*spd, spd_accel)
	
	if vsp<20 {
		vsp+=grav
	}
	
	if not grounded {
		state=states.fall
	}
	else if key_jump {
		state=states.fall
		
		if size==player_sizes.normal {
			vsp= -jspd
		}
		else {
			vsp= -jspd_small
		}
	}
}

function player_fall() {
	sprite_index=spr_idle
	
	var move=key_right-key_left
	hsp=approach(hsp, move*spd, spd_accel)
	
	if vsp<20 {
		vsp+=grav
	}
	
	rsp=clamp(abs(vsp)*-sign(image_xscale)/3, -infinity, -5)
	
	if grounded {
		state=states.normal
	}
}

function player_ship() {
	sprite_index=spr_ship
	
	var move=key_right-key_left
	hsp=approach(hsp, move*spd, spd_accel)
	
	if key_jump {
		var part=create_particles(1, spr_particle, 1, x-lengthdir_x(sprite_width/2, rotation)*sign(image_xscale), y, -hsp/2*abs(image_xscale), irandom_range(-3, 3), false)
		for (var p=0;p<array_length(part);p++) {
			part[p].depth=depth+1
			part[p].fade_sp=0.1
			part[p].vsp=irandom_range(-5, 5)
		}
		
		if size=player_sizes.normal {
			vsp=approach(vsp, -max_ship_fly_spd, fly_accel)
		}
		else {
			vsp=approach(vsp, -max_ship_fly_spd_small, fly_accel_small)
		}
	}
	else {
		if size=player_sizes.normal {
			vsp=approach(vsp, max_ship_fly_spd, fly_accel)
		}
		else {
			vsp=approach(vsp, max_ship_fly_spd_small, fly_accel_small)
		}
	}
	
	if !grounded {
		rotation=vsp*grav_dir*-sign(image_xscale) //angle_approach(rotation, max_ship_angle*image_xscale*image_yscale, fly_angle_accel)
	}
	else {
		rotation=0
		rsp=0
	}
}

function player_ufo() {
	sprite_index=spr_ufo
	
	var move=key_right-key_left
	hsp=approach(hsp, move*spd, spd_accel)
	
	if vsp<20 {
		vsp+=grav
	}
	
	if key_jump_press {
		var part=create_particles(10, spr_particle, 1, x, y, 0, 0, false)
		for (var p=0;p<array_length(part);p++) {
			part[p].hsp= -irandom(hsp)
			part[p].vsp=irandom(10)*grav_dir
			part[p].fade_sp=0.1
		}
		
		if size==player_sizes.normal {
			vsp= -ufo_jspd
		}
		else {
			vsp= -ufo_jspd_small
		}
	}
	
	if !grounded {
		rotation=vsp*grav_dir*sign(image_xscale) //angle_approach(rotation, max_ship_angle*image_xscale*image_yscale, fly_angle_accel)
	}
	else {
		rotation=0
		rsp=0
	}
}

function player_wave() {
	if !instance_exists(wave_trailID) {
		wave_trailID=instance_create_layer(x, y, "Instances", obj_wavetrail)
		wave_trailID.image_angle=point_direction(wave_trailID.x, wave_trailID.y, x, y)
		wave_trailID.depth=depth+2
		wave_trailID.image_xscale=point_distance(wave_trailID.x, wave_trailID.y, x, y)/sprite_get_width(spr_wavetrail)
		wave_trailID.image_yscale=abs(image_yscale)
		wave_trailID.creator=id
	}
	
	sprite_index=spr_wave
	
	var move=key_right-key_left
	
	wave_trailID.image_angle=point_direction(wave_trailID.x, wave_trailID.y, x, y)
	wave_trailID.image_xscale=point_distance(wave_trailID.x, wave_trailID.y, x, y)/sprite_get_width(spr_wavetrail)
	
	if key_jump_press or key_jump_rel or ((grounded or place_meeting(x, y-1*grav_dir, obj_solid)) and wave_trailID.y!=y) {
		if key_jump_press or key_jump_rel {
			var wave_corner=instance_create_layer(wave_trailID.x+lengthdir_x(wave_trailID.sprite_width, wave_trailID.image_angle), wave_trailID.y+lengthdir_y(wave_trailID.sprite_width, wave_trailID.image_angle), "Instances", obj_wavetrail)
			wave_corner.sprite_index=spr_wavetrail_corner
			wave_corner.image_xscale=abs(image_xscale)
			wave_corner.image_angle=wave_trailID.image_angle
			wave_corner.depth=depth+1
			wave_corner.creator=id
			
			if key_jump_press {
				wave_corner.image_yscale= -abs(image_yscale)
			}
			else {	
				wave_corner.image_yscale=abs(image_yscale)
			}
		}
		
		wave_trailID=instance_create_layer(x, y, "Instances", obj_wavetrail)
		wave_trailID.image_angle=point_direction(wave_trailID.x, wave_trailID.y, x, y)
		wave_trailID.depth=depth+2
		wave_trailID.image_xscale=point_distance(wave_trailID.x, wave_trailID.y, x, y)/sprite_get_width(spr_wavetrail)
		wave_trailID.image_yscale=abs(image_yscale)
		wave_trailID.creator=id
	}
	
	if key_jump {
		if size==player_sizes.normal {
			hsp=lengthdir_x(move*spd/cos(degtorad(wave_angle)), wave_angle)
			vsp=lengthdir_y(move*spd/cos(degtorad(wave_angle)), wave_angle)
			rotation=wave_angle*sign(image_xscale)*sign(image_yscale)
		}
		else {
			hsp=lengthdir_x(move*spd/cos(degtorad(wave_angle_small)), wave_angle_small)
			vsp=lengthdir_y(move*spd/cos(degtorad(wave_angle_small)), wave_angle_small)
			rotation=wave_angle_small*sign(image_xscale)*sign(image_yscale)
		}
	}
	else {
		if size==player_sizes.normal {
			hsp=lengthdir_x(move*spd/cos(degtorad(wave_angle)), -wave_angle)
			vsp=lengthdir_y(move*spd/cos(degtorad(wave_angle)), -wave_angle)
		}
		else {
			hsp=lengthdir_x(move*spd/cos(degtorad(wave_angle_small)), -wave_angle_small)
			vsp=lengthdir_y(move*spd/cos(degtorad(wave_angle_small)), -wave_angle_small)
		}
		
		if !grounded {
			if size==player_sizes.normal {
				rotation= -wave_angle*sign(image_xscale)*sign(image_yscale)
			}
			else {
				rotation= -wave_angle_small*sign(image_xscale)*sign(image_yscale)
			}
		}
		else {
			rotation=0
			rsp=0
		}
	}
}

function player_ball() {
	sprite_index=spr_ball
	
	var move=key_right-key_left
	hsp=approach(hsp, move*spd, spd_accel)
	
	if vsp<20 {
		vsp+=ball_fly_spd
	}
	
	if key_jump_press and grounded {
		grav_dir= -grav_dir
	}
	
	rsp=angle_approach(rsp, -ball_rot_spd*move*sign(image_yscale), ball_rot_accel)
}

function player_robot() {
	sprite_index=spr_robot
	rotation=0
	rsp=0
	
	var move=key_right-key_left
	hsp=approach(hsp, move*spd, spd_accel)
	
	if vsp<20 {
		vsp+=grav
	}
	
	if !grounded {
		state=states.robot_fall
	}
	else if key_jump_press {
		state=states.robot_jump
		robot_jump_t=0
	}
}

function player_robot_jump() {
	sprite_index=spr_robot
	rotation=0
	rsp=0
	robot_jump_t+=1
	
	var part=create_particles(1, spr_particle, 1, x, y+sprite_height/2*sign(image_yscale), 0, 0, false)
	for (var p=0;p<array_length(part);p++) {
		part[p].depth=depth+1
		part[p].hsp=irandom_range(-3, 3)
		part[p].vsp=irandom(10)*grav_dir
		part[p].fade_sp=0.1
	}
	
	var move=key_right-key_left
	hsp=approach(hsp, move*spd, spd_accel)
	
	if size==player_sizes.normal {
		vsp=approach(vsp, -robot_jump_max, robot_jump_accel)
	}
	else {
		vsp=approach(vsp, -robot_jump_max_small, robot_jump_accel)
	}
	
	if key_jump_rel or ((size==player_sizes.normal and robot_jump_t>=robot_jump_tmax) or (size==player_sizes.small and robot_jump_t>=robot_jump_tmax_small)) {
		state=states.robot_fall
	}
}

function player_robot_fall() {
	sprite_index=spr_robot
	rotation=0
	rsp=0
	
	var move=key_right-key_left
	hsp=approach(hsp, move*spd, spd_accel)
	
	if vsp<20 {
		vsp+=grav
	}
	
	if grounded {
		state=states.robot
	}
}

function player_spider() {
	sprite_index=spr_spider
	rotation=0
	rsp=0
	
	var move=key_right-key_left
	hsp=approach(hsp, move*spd, spd_accel)
	
	if vsp<20 {
		vsp+=grav
	}
	
	if key_jump_press and grounded {
		grav_dir= -grav_dir
		vsp=spider_jspd
		
		spider_trailID=instance_create_layer(x, y, "Instances", obj_spidertrail)
		spider_trailID.x=x
		spider_trailID.image_xscale=point_distance(spider_trailID.x, spider_trailID.y, x, y)/sprite_get_width(spider_trailID.sprite_index)
		spider_trailID.image_yscale=abs(image_yscale)
		spider_trailID.image_angle=90
	}
}

function player_swipe() {
	if !instance_exists(swipeID) {
		state=states.normal
		return
	}
	if !instance_exists(swipeeffectID) or swipeeffectID.fade_sp!=0 {
		var _part=create_particles(1, spr_swipetrail_1, swipeID.swipe_type, x, y)
		if swipeID.swipe_type==swipe_types.grav {
			_part[0].sprite_index=spr_swipetrail_2
		}
		else {
			_part[0].sprite_index=spr_swipetrail_1
		}
		_part[0].image_xscale=image_xscale
		_part[0].image_yscale=image_yscale
		_part[0].image_speed=0.3
		_part[0].depth=depth+1
		_part[0].scale_grow=0
		swipeeffectID=_part[0]
	}
	
	var px=x+irandom_range(-sprite_width/2, sprite_width/2)
	var py=y+irandom_range(-sprite_height/2, sprite_height/2)
	var part=create_particles(1, spr_particle, 1, px, py, -irandom(spd)*abs(image_xscale), irandom_range(-5, 5), false)
	for (var p=0;p<array_length(part);p++) {
		part[p].fade_sp=0.05
		if swipeID.swipe_type==swipe_types.grav {
			part[p].image_blend=make_color_rgb(237, 0, 140)
		}
		else {
			part[p].image_blend=make_color_rgb(19, 255, 0)
		}
	}
	
	hsp=lengthdir_x(spd, swipeID.image_angle)
	vsp=lengthdir_y(spd, swipeID.image_angle)
	
	swipeeffectID.x=x
	swipeeffectID.y=y
	
	if prev_state==states.normal or prev_state==states.fall {
		rsp=swipe_rsp
	}
	else {
		rsp=0
	}
	
	if key_jump_rel or place_meeting(x, y, obj_swipestop) {
		state=prev_state
		swipeID.image_alpha=1
		swipeeffectID.fade_sp=0.1
	}
}

function player_swing() {
	sprite_index=spr_swing
	
	var move=key_right-key_left
	hsp=approach(hsp, move*spd, spd_accel)
	
	if vsp<20 {
		vsp+=swing_fly_spd
	}
	
	if key_jump_press {
		vsp= -vsp
		grav_dir= -grav_dir
	}
	
	if !grounded {
		var part=create_particles(1, spr_particle, 1, x-lengthdir_x(sprite_width/2, rotation)*sign(image_xscale), y, -hsp/2*abs(image_xscale), irandom_range(-9, 9), false)
		for (var p=0;p<array_length(part);p++) {
			part[p].depth=depth+1
			part[p].fade_sp=0.1
		}
	}
	
	rotation=vsp*grav_dir*-sign(image_xscale)
}

function player_collide_special() {
	//instance_place_list(x+hsp, y+(vsp*grav_dir), obj_special, specials_list, false)
	var fvsp=round(vsp*grav_dir)
	var svsp=sign(fvsp)
	var target_y=round(y+fvsp)
	var cy=y
	var bbox_size_y=bbox_bottom-bbox_top
	var fhsp=round(hsp)
	var shsp=sign(fhsp)
	var target_x=round(x+fhsp)
	var cx=x
	var bbox_size_x=bbox_right-bbox_left
	
	while abs(target_x-cx)>=bbox_size_x or abs(target_y-cy)>=bbox_size_y {
		if place_meeting(cx, cy, obj_solid) {
			cx=round(target_x)
			cy=round(target_y)
			break
		}
		handle_specials(cx, cy)
		
		if abs(target_x-cx)>=bbox_size_x {
			cx+=bbox_size_x*shsp
		}
		if abs(target_y-cy)>=bbox_size_y {
			cy+=bbox_size_y*svsp
		}
	}
	while round(target_x)!=round(cx) or round(target_y)!=round(cy) {
		if place_meeting(cx, cy, obj_solid) {
			break
		}
		handle_specials(cx, cy)
		
		if round(target_x)!=round(cx) {
			cx+=shsp
		}
		if round(target_y)!=round(cy) {
			cy+=svsp
		}
	}
}

function handle_specials(sx, sy) {
	ds_list_clear(specials_list)
	var specials_num=instance_place_list(sx, sy, obj_special, specials_list, false)
	
	for (var s=0;s<specials_num;s++) {
		var object=specials_list[| s]
		if object.activated {
			continue
		}
		
		switch (object.object_index) {
			case obj_pad:
				object.activated=true
				var part=create_particles(1, spr_orb, object.pad_type, object.x, object.y)
				for (var p=0;p<array_length(part);p++) {
					part[p].scale_grow=0.1
					part[p].scale_max=100
					part[p].fade_sp=0.1
				}
				
				switch (object.pad_type) {
					case pad_types.jump:
						vsp= -object.jspd
						break
			
					case pad_types.bounce:
						vsp= -object.bspd
						break
		
					case pad_types.leap:
						vsp= -object.lspd
						break
		
					case pad_types.grav:
						vsp=object.grav_jspd
						grav_dir= -grav_dir
						
						var _g=instance_create_layer(camera_get_view_x(view_camera[0]), camera_get_view_y(view_camera[0]), "Instances", obj_gravchange)
						_g.image_xscale=(camera_get_view_width(view_camera[0])/obj_gamecontroller.initial_camw)
						_g.image_yscale=(camera_get_view_height(view_camera[0])/obj_gamecontroller.initial_camh)
						if grav_dir==1 {
							_g.sprite_index=spr_gravdown
						}
						else {
							_g.sprite_index=spr_gravup
						}
						break
					
					case pad_types.spider:
						grav_dir= -grav_dir
						vsp=spider_jspd
		
						spider_trailID=instance_create_layer(x, y, "Instances", obj_spidertrail)
						spider_trailID.x=x
						spider_trailID.image_xscale=point_distance(spider_trailID.x, spider_trailID.y, x, y)/sprite_get_width(spider_trailID.sprite_index)
						spider_trailID.image_yscale=abs(image_yscale)
						spider_trailID.image_angle=90
						break
				}
				break
			
			case obj_orb:
				if key_jump_press {
					object.activated=true
					var part=create_particles(1, object.sprite_index, object.orb_type, object.x, object.y)
				for (var p=0;p<array_length(part);p++) {
					part[p].scale_grow=0.1
					part[p].scale_max=100
					part[p].fade_sp=0.1
				}
					object.image_xscale+=1
					object.image_yscale+=1
					
					switch (object.orb_type) {
						case orb_types.jump:
							vsp= -object.jspd
							break
			
						case orb_types.bounce:
							vsp= -object.bspd
							break
						
						case orb_types.leap:
							vsp= -object.lspd
							break
		
						case orb_types.grav:
							vsp=object.jspd
							grav_dir= -grav_dir
							
							var _g=instance_create_layer(camera_get_view_x(view_camera[0]), camera_get_view_y(view_camera[0]), "Instances", obj_gravchange)
							_g.image_xscale=(camera_get_view_width(view_camera[0])/obj_gamecontroller.initial_camw)
							_g.image_yscale=(camera_get_view_height(view_camera[0])/obj_gamecontroller.initial_camh)
							if grav_dir==1 {
								_g.sprite_index=spr_gravdown
							}
							else {
								_g.sprite_index=spr_gravup
							}
							break
					
						case orb_types.smooth:
							vsp= -vsp*1.25
							grav_dir= -grav_dir
							
							var _g=instance_create_layer(camera_get_view_x(view_camera[0]), camera_get_view_y(view_camera[0]), "Instances", obj_gravchange)
							_g.image_xscale=(camera_get_view_width(view_camera[0])/obj_gamecontroller.initial_camw)
							_g.image_yscale=(camera_get_view_height(view_camera[0])/obj_gamecontroller.initial_camh)
							if grav_dir==1 {
								_g.sprite_index=spr_gravdown
							}
							else {
								_g.sprite_index=spr_gravup
							}
							break
						
						case orb_types.boost:
							vsp=object.boost_sp
							break
						
						case orb_types.spider:
							grav_dir= -grav_dir
							vsp=spider_jspd
		
							spider_trailID=instance_create_layer(x, y, "Instances", obj_spidertrail)
							spider_trailID.x=x
							spider_trailID.image_xscale=point_distance(spider_trailID.x, spider_trailID.y, x, y)/sprite_get_width(spider_trailID.sprite_index)
							spider_trailID.image_yscale=abs(image_yscale)
							spider_trailID.image_angle=90
							break
					}
				}
				
				break
			
			case obj_swipe:
				if key_jump_press {
					object.activated=true
					object.image_alpha=0
					swipeID=object.id
					prev_state=state
					
					switch object.swipe_type {
						case swipe_types.swipe:
							state=states.swipe
							vsp=0
							break
					
						case swipe_types.grav:
							state=states.swipe
							grav_dir= -grav_dir
							vsp=0
							
							var _g=instance_create_layer(camera_get_view_x(view_camera[0]), camera_get_view_y(view_camera[0]), "Instances", obj_gravchange)
							_g.image_xscale=(camera_get_view_width(view_camera[0])/obj_gamecontroller.initial_camw)
							_g.image_yscale=(camera_get_view_height(view_camera[0])/obj_gamecontroller.initial_camh)
							if grav_dir==1 {
								_g.sprite_index=spr_gravdown
							}
							else {
								_g.sprite_index=spr_gravup
							}
							break
					}
					break
				}
				break
			
			case obj_portal:
				object.activated=true
				
				switch object.portal_type {
					case portal_types.normal:
						state=states.normal
						break
					
					case portal_types.ship:
						state=states.ship
						break
					
					case portal_types.ufo:
						state=states.ufo
						break
					
					case portal_types.wave:
						state=states.wave
						wave_trailID=noone
						break
					
					case portal_types.ball:
						state=states.ball
						break
						
					case portal_types.robot:
						state=states.robot
						break
					
					case portal_types.spider:
						state=states.spider
						break
					
					case portal_types.grav_down:
						if grav_dir!=1 {
							vsp= -vsp
							
							var _g=instance_create_layer(camera_get_view_x(view_camera[0]), camera_get_view_y(view_camera[0]), "Instances", obj_gravchange)
							_g.image_xscale=(camera_get_view_width(view_camera[0])/obj_gamecontroller.initial_camw)
							_g.image_yscale=(camera_get_view_height(view_camera[0])/obj_gamecontroller.initial_camh)
							_g.sprite_index=spr_gravdown
						}
						grav_dir=1
						break
					
					case portal_types.grav_up:
						if grav_dir!=-1 {
							vsp= -vsp
							var _g=instance_create_layer(camera_get_view_x(view_camera[0]), camera_get_view_y(view_camera[0]), "Instances", obj_gravchange)
							_g.image_xscale=(camera_get_view_width(view_camera[0])/obj_gamecontroller.initial_camw)
							_g.image_yscale=(camera_get_view_height(view_camera[0])/obj_gamecontroller.initial_camh)
							_g.sprite_index=spr_gravup
						}
						grav_dir= -1
						break
					
					case portal_types.grav_invert:
						vsp= -vsp
						grav_dir= -grav_dir
						
						var _g=instance_create_layer(camera_get_view_x(view_camera[0]), camera_get_view_y(view_camera[0]), "Instances", obj_gravchange)
						_g.image_xscale=(camera_get_view_width(view_camera[0])/obj_gamecontroller.initial_camw)
						_g.image_yscale=(camera_get_view_height(view_camera[0])/obj_gamecontroller.initial_camh)
						if grav_dir==1 {
							_g.sprite_index=spr_gravdown
						}
						else {
							_g.sprite_index=spr_gravup
						}
						break
					
					case portal_types.dir_right:
						obj_gamecontroller.draw_target=1
						break
					
					case portal_types.dir_left:
						obj_gamecontroller.draw_target= -1
						break
					
					case portal_types.teleport:
						x=object.tpportalID.x
						y=object.tpportalID.y
						object.tpportalID.activated=true
						break
					
					case portal_types.duplicate_start:
						if !instance_exists(cloneID) and instance_number(obj_player)==1 {
							cloneID=instance_create_layer(x, y, "Instances", obj_player)
							cloneID.cloneID=id
							cloneID.hsp=hsp
							cloneID.vsp=vsp
							cloneID.grav_dir= -grav_dir
							cloneID.size=size
							cloneID.state=state
							cloneID.palette_col1=palette_col2
							cloneID.palette_col2=palette_col1
						}
						break
					
					case portal_types.duplicate_end:
						if instance_exists(cloneID) {
							instance_destroy(cloneID)
						}
						break
					
					case portal_types.icon_normal:
						if size==player_sizes.small {
							var prev_bottom=bbox_bottom
							if grav_dir<0 {
								prev_bottom=bbox_top
							}
							size=player_sizes.normal
							image_xscale/=small_scale
							image_yscale/=small_scale
							y=prev_bottom-(sprite_height/2*grav_dir)
						}
						break
					
					case portal_types.icon_small:
						if size==player_sizes.normal {
							var prev_bottom=bbox_bottom
							if grav_dir<0 {
								prev_bottom=bbox_top
							}
							size=player_sizes.small
							image_xscale*=small_scale
							image_yscale*=small_scale
							y=prev_bottom-(sprite_height/2*grav_dir)
						}
						break
					
					case portal_types.swing:
						state=states.swing
						break
				}
				break
			
			case obj_tpportal_exit:
				object.activated=true
				
				x=object.parentID.x
				y=object.parentID.y
				object.parentID.activated=true
				break
			
			case obj_speedup:
				object.activated=true
				
				switch (object.speed_up_type) {
					case speed_up_types.slow:
						spd=slow_spd
						break
						
					case speed_up_types.normal:
						spd=normal_spd
						break
					
					case speed_up_types.fast:
						spd=fast_spd
						break
					
					case speed_up_types.very_fast:
						spd=very_fast_spd
						break
					
					case speed_up_types.extremely_fast:
						spd=extremely_fast_spd
						break
				}
				break
			
			case obj_trigger:
				object.activated=true
				switch (object.trigger_type) {
					case trigger_types.move:
						for (var i=0;i<array_length(object.triggerID);i++) {
							obj_gamecontroller.triggers[array_length(obj_gamecontroller.triggers)]=[object.trigger_type, object.triggerID[i], object.move_target, object.move_spd]
						}
						break
					case trigger_types.rotate:
						for (var i=0;i<array_length(object.triggerID);i++) {
							obj_gamecontroller.triggers[array_length(obj_gamecontroller.triggers)]=[object.trigger_type, object.triggerID[i], object.rotate_center, object.rotate_target, object.rotate_spd]
						}
						break
					case trigger_types.alpha:
						for (var i=0;i<array_length(object.triggerID);i++) {
							obj_gamecontroller.triggers[array_length(obj_gamecontroller.triggers)]=[object.trigger_type, object.triggerID[i], object.alpha_target, object.alpha_spd]
						}
						break
					case trigger_types.background:
						obj_gamecontroller.triggers[array_length(obj_gamecontroller.triggers)]=[object.trigger_type, object.id, object.bg_target, object.bg_spd]
						break
					case trigger_types.zoom:
						for (var i=0;i<array_length(object.triggerID);i++) {
							obj_gamecontroller.triggers[array_length(obj_gamecontroller.triggers)]=[object.trigger_type, object.triggerID[i], object.zoom_target, object.zoom_spd]
						}
						break
										
					case trigger_types.flicker:
						obj_gamecontroller.triggers[array_length(obj_gamecontroller.triggers)]=[object.trigger_type, object.id, object.flicker_bpm]
						break
					case trigger_types.win:
						if state!=states.loose {
							hsp=0
							vsp=0
							triggerID=object.id
							state=states.win
						}
						break
				}
				break
				
			case obj_transition:
				object.activated=true
				obj_gamecontroller.transition_type=object.transition_type
				break
		}
	}
}

function player_collide() {
	if state==states.win or state==states.loose {
		rotation+=rsp
		rotation=normalize_angle(rotation)
		if sign(hsp)!=0 {
			image_xscale=sign(hsp)*abs(image_xscale)
		}
		image_yscale=sign(grav_dir)*abs(image_yscale)
		x+=hsp
		y+=vsp
		return
	}
	
	rotation+=rsp
	rotation=normalize_angle(rotation)
	
	player_collide_special()
	
	if delta_time_mode {
		var _dt=delta_time/1000000
		hsp/=room_speed
		vsp/=room_speed
		hsp/=_dt
		vsp/=_dt
	}
	
	if sign(hsp)!=0 {
		image_xscale=sign(hsp)*abs(image_xscale)
	}
	if state!=states.swing {
		image_yscale=sign(grav_dir)*abs(image_yscale)
	}
	else {
		image_yscale=abs(image_yscale)
	}
	
	var fvsp=vsp*grav_dir
	var svsp=sign(fvsp)
	var target_y=y+fvsp
	var bbox_size_y=bbox_bottom-bbox_top
	
	for (var a=0;a<floor(fvsp/bbox_size_y);a++) {
		if not place_meeting(x, y+bbox_size_y*svsp, obj_solid) {
			y+=bbox_size_y*svsp
		}
	}
	for (var s=0;s<abs(target_y-y);s++) {
		if !place_meeting(x, y+svsp, obj_solid) {
			y+=svsp
		}
		else {
			var inst=instance_place(x, y+svsp, obj_solid)
			
			if vsp<0 and (state==states.normal or state==states.fall or state==states.robot or state==states.robot_jump or state==states.robot_fall or state==states.spider) {
				if inst.object_index==obj_safesolid {
					//do nothing
				}
				else if inst.object_index==obj_gravsolid {
					grav_dir= -grav_dir
				}
				else {
					player_gameover()
				}
			}
			vsp=0
			break
		}
	}
	
	var shsp=sign(hsp)
	var target_x=x+hsp
	var bbox_size_x=bbox_right-bbox_left
	var _reset=true
	var start_pos=[x, y]
	
	for (var a=0;a<floor(hsp/bbox_size_x);a++) {
		if not place_meeting(x+bbox_size_x*shsp, y, obj_solid) {
			x+=bbox_size_y*shsp
		}
	}
	for (var s=0;s<abs(target_x-x);s++) {
		for (var k=1;k<=4;k++) {
			var rk=k*grav_dir
			
			if place_meeting(x+shsp, y, obj_solid) and !place_meeting(x+shsp, y-rk, obj_solid) {
				var inst=instance_place(x+shsp, y, obj_solid)
				if state!=states.wave or (state==states.wave and inst.object_index==obj_safesolid) {
					_reset=false
					if !instance_exists(sloping) {
						sloping_start=[x, y]
					}
					sloping=instance_place(x+shsp, y, obj_solid)
					y-=rk
				}
			}
			if (!place_meeting(x+shsp, y, obj_solid) and !place_meeting(x+shsp, y+1*grav_dir, obj_solid) and place_meeting(x+shsp, y+rk+1*grav_dir, obj_solid) and vsp>=0) {
				y+=rk
			}
			else if (place_meeting(x+shsp, y, obj_solid) and place_meeting(x, y-rk, obj_solid) and !place_meeting(x+shsp, y+rk, obj_solid)) {
				var inst=instance_place(x+shsp, y, obj_solid)
				if state!=states.wave or (state==states.wave and inst.object_index==obj_safesolid) {
					y+=rk
				}
			}
		}
		
		if !place_meeting(x+shsp, y, obj_solid) {
			x+=shsp
		}
		else {
			hsp=0
			
			if level_mode {
				player_gameover()
			}
			break
		}
	}
	
	if _reset and instance_exists(sloping) {
		if state!=states.wave and ((y<=floor(sloping.bbox_top) and place_meeting(x, y+1, sloping) and grav_dir==1) or (y>=floor(sloping.bbox_bottom) and place_meeting(x, y-1, sloping) and grav_dir==-1)) {
			vsp=lengthdir_y(hsp*2*abs(image_xscale), point_direction(sloping_start[0], sloping_start[1], x, y))
			//vsp= -abs(hsp)*2
		}
		
		sloping=noone
	}
	
	if place_meeting(x, y, obj_spike) {
		player_gameover()
	}
	
	grounded=place_meeting(x, y+(1*grav_dir), obj_solid)
	var roofed=place_meeting(x, y-(1*grav_dir), obj_solid)
	
	if (grounded or roofed) and state!=states.ball {
        var slope_angle=point_direction(start_pos[0], start_pos[1], x, y)
        rotation=angle_approach(rotation, closest_angle(rotation, 4, slope_angle), 15)
	}
}


function player_win() {
	rsp=approach(rsp, 15, 0.5)
	hsp=approach(hsp, lengthdir_x(15, point_direction(x, y, triggerID.bbox_right, triggerID.y)), 1)
	vsp=approach(vsp, lengthdir_y(15, point_direction(x, y, triggerID.bbox_right, triggerID.y)), 1)
	
	if y>=triggerID.bbox_right {
		obj_gamecontroller.alarm[0]=1*room_speed
		state=states.loose
	}
}

function player_loose() {
	hsp=0
	vsp=0
	rsp=0
	rotation=0
	image_alpha=0
}

function player_gameover() {
	if debug {
		return
	}
	
	if audio_exists(obj_gamecontroller.current_music) and audio_is_playing(obj_gamecontroller.current_music) {
		audio_stop_sound(obj_gamecontroller.current_music)
	}
	
	if instance_exists(cloneID) {
		instance_destroy(cloneID)
	}
	
	var part=create_particles(4, spr_player_debris, 1, x, y, 0, 0, false)
	for (var p=0;p<array_length(part);p++) {
		var inst=part[p]
		
		inst.depth=depth-1
		inst.image_index=p+1
		inst.scale_grow=0
		inst.hsp=irandom_range(-5, 5)
		inst.vsp=-irandom(15)
		inst.physics=true
		inst.palette_col1=palette_col1
		inst.palette_col2=palette_col2
	}
	
	var shock_num=45
	var shock_part=create_particles(shock_num, spr_particle, 1, x, y, 0, 0, false)
	for (var p=0;p<array_length(shock_part);p+=1) {
		var inst=shock_part[p]
		
		inst.hsp=lengthdir_x(10, 360/shock_num*p)
		inst.vsp=lengthdir_y(10, 360/shock_num*p)
		inst.fade_sp=0.05
	}
	
	obj_gamecontroller.alarm[0]=1*room_speed
	state=states.loose
}