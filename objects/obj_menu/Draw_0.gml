var slevel=levels[level_idx]
var levelname=slevel[0]
var leveldiff=slevel[1]

draw_set_font(ft_menu)

draw_set_color(make_color_rgb(0, 200, 255))
draw_rectangle(0, 0, room_width, room_height, false)

draw_set_color(c_black)
draw_set_alpha(0.5)
draw_roundrect_ext(room_width/2-menu_rect_width/2, room_height/2-menu_rect_height/2, room_width/2+menu_rect_width/2, room_height/2+menu_rect_height/2, 50, 50, false)
draw_set_alpha(1)
draw_set_color(c_white)

draw_sprite(spr_difficons, leveldiff, room_width/2, room_height/2-sprite_get_height(spr_difficons)/2)
draw_text(room_width/2-string_width(levelname)/2, room_height/2+string_height(levelname)/2, levelname)