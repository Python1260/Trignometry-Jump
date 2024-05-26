image_index=swipe_type

if image_alpha>0 {
	var px=x+irandom_range(-sprite_width/2, sprite_width/2)
	var py=y+irandom_range(-sprite_height/2, sprite_height/2)
	var pdir=point_direction(px, py, x, y)
	var p=create_particles(1, spr_particle, 1, px, py, -lengthdir_x(5, pdir), -lengthdir_y(5, pdir), false)
	p[0].fade_sp=0.1

	if swipe_type==swipe_types.grav {
		p[0].image_blend=make_color_rgb(237, 0, 140)
	}
	else {
		p[0].image_blend=make_color_rgb(19, 255, 0)
	}
}