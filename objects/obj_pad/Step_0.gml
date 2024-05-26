image_index=pad_type

var p=create_particles(1, spr_particle, 1, x+irandom_range(-sprite_width/2, sprite_width/2), y+irandom_range(-sprite_height/2, sprite_height/2), lengthdir_x(5, image_angle+90)*sign(image_yscale), lengthdir_y(5, image_angle+90)*sign(image_yscale), false)
p[0].fade_sp=0.05