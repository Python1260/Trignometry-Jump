var key_left=keyboard_check_pressed(vk_left)
var key_right=keyboard_check_pressed(vk_right)
var key_play=keyboard_check_pressed(vk_space)

if mouse_check_button_pressed(mb_left) {
	if mouse_x<menu_button_border {
		key_left=1
	}
	else if mouse_x>(room_width-menu_button_border) {
		key_right=1
	}
	else {
		key_play=1
	}
}

var level_switch=key_right-key_left
level_idx+=level_switch
if level_idx>array_length(levels)-1 {
	level_idx=0
}
else if level_idx<0 {
	level_idx=array_length(levels)-1
}

if key_play {
	room_goto(levels[level_idx][2])
}