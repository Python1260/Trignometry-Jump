function approach(num, target, val) {
	if num<target {
		num+=val
		
		if num>target {
			return target
		}
	}
	else if num>target {
		num-=val
		
		if num<target {
			return target
		}
	}
	
	return num
}

function normalize_angle(angle) {
	if angle<0 {
		angle=360-abs(angle)
	}
	
	return angle%360
}

function angle_approach(num, target, val) {
    num = normalize_angle(num);
    target = normalize_angle(target);

    var diff = target - num;

    if (diff > 180) {
        diff -= 360;
    } else if (diff < -180) {
        diff += 360;
    }

    if (abs(diff) <= val) {
        return target;
    } else {
        num += sign(diff) * val;
        return normalize_angle(num);
    }
}

function closest_angle(angle, angle_dividor, angle_start) {
    var angle_list=[]
    var angle_step=360/angle_dividor

    for (var s=0;s<angle_dividor;s++) {
        angle_list[array_length(angle_list)]=normalize_angle(angle_start+s*angle_step)
    }

    var normalized_angle=normalize_angle(angle)
    var t_angle=angle_list[0]
    var smallest_diff=abs(angle_difference(normalized_angle, t_angle))

    for (var i = 1; i < array_length(angle_list); i++) {
        var current_angle=angle_list[i]
        var current_diff=abs(angle_difference(normalized_angle, current_angle))

        if current_diff<smallest_diff {
            smallest_diff=current_diff
            t_angle=current_angle
        }
    }

    return t_angle
}


function create_particles(num, sprite, frame, px, py, hsp=0, vsp=0, randomized=false) {
	var particles=[]
	
	for (var p=0;p<num;p++) {
		var _e=instance_create_layer(px, py, "Instances", obj_particle)
		_e.sprite_index=sprite
		_e.image_index=frame
		if !randomized {
			_e.hsp=hsp
			_e.vsp=vsp
		}
		else {
			_e.hsp=irandom_range(-hsp, hsp)
			_e.vsp=irandom(vsp)
		}
		particles[array_length(particles)]=_e
	}
	
	return particles
}

function col_to_shader(rgb_col) {
	return [rgb_col[0]/255, rgb_col[1]/255, rgb_col[2]/255]
}

function sort_objects_by_depth(objects) {
	var _array = objects;
	var _length = ds_list_size(_array);
	var _swapped;

	repeat (_length - 1) {
	    _swapped = false;
	    for (var i = 0; i < _length - 1; i++) {
	        var obj1_depth = _array[| i].depth
	        var obj2_depth = _array[| i + 1].depth
        
	        if (obj1_depth < obj2_depth) {
	            var temp = _array[| i];
	            _array[| i] = _array[| i + 1];
	            _array[| i + 1] = temp;
	            _swapped = true;
	        }
	    }
	    if (!_swapped) break;
	}

	return _array;

}