image_index=orb_type

var px=x+irandom_range(-sprite_width, sprite_width)
var py=y+irandom_range(-sprite_height, sprite_height)
var pdir=point_direction(px, py, x, y)
var p=create_particles(1, spr_particle, 1, px, py, lengthdir_x(5, pdir), lengthdir_y(5, pdir), false)
p[0].fade_sp=0.1

image_xscale=approach(image_xscale, start_xscale, scale_reset_sp)
image_yscale=approach(image_yscale, start_yscale, scale_reset_sp)