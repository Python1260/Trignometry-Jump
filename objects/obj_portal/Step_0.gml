image_index=portal_type

if portal_type==portal_types.teleport {
	if !instance_exists(tpportalID) {
		tpportalID=instance_create_layer(tpportal_x, tpportal_y, "Instances", obj_tpportal_exit)
		tpportalID.parentID=id
		tpportalID.image_angle=tpportal_angle
		tpportalID.image_xscale= -1
	}
	else {
		tpportalID.x=tpportal_x
		tpportalID.y=tpportal_y
		tpportalID.image_angle=tpportal_angle
	}
}

var px=x-lengthdir_x(irandom(100), irandom_range(image_angle-45, image_angle+45))*image_xscale
var py=y-lengthdir_y(irandom(100), irandom_range(image_angle-45, image_angle+45))
var pdir=point_direction(px, py, x, y)
var p=create_particles(1, spr_particle, 1, px, py, lengthdir_x(5, pdir), lengthdir_y(5, pdir), false)
p[0].fade_sp=0.1