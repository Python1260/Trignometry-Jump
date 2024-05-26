image_index+=image_speed
image_alpha-=fade_sp
image_xscale+=scale_grow
image_yscale+=scale_grow
image_angle+=angle_change

if physics {
	vsp+=grav
}

if move_with_angle {
	x+=lengthdir_x(hsp, image_angle)
	y+=lengthdir_y(vsp, image_angle)
}
else {
	x+=hsp
	y+=vsp
}

if instance_exists(follow_id) {
	x=follow_id.x+follow_offset_x
	y=follow_id.y+follow_offset_y
}

if y>room_width or image_alpha<=0 or image_xscale>scale_max or image_xscale<=0 {
	instance_destroy()
}