function camera_zoom(targetinst, zoom) {
	var cam=view_camera[0]
	var camx=camera_get_view_x(cam)
	var camy=camera_get_view_y(cam)
	var camw=obj_gamecontroller.initial_camw
	var camh=obj_gamecontroller.initial_camh
	var cambx=obj_gamecontroller.initial_cambx
	var camby=obj_gamecontroller.initial_camby
	
	var cam_center_x=camx+camera_get_view_width(cam)/2
    var cam_center_y=camy+camera_get_view_height(cam)/2
	
	camera_set_view_size(cam, camw*zoom, camh*zoom)
	camera_set_view_border(cam, cambx*zoom, camby*zoom)
	obj_gamecontroller.draw_transition_border=obj_gamecontroller.start_dtb*zoom
	
	camw=camera_get_view_width(cam)
	camh=camera_get_view_height(cam)
	
	camx=cam_center_x-camera_get_view_width(cam)/2
    camy=cam_center_y-camera_get_view_height(cam)/2
    
    camera_set_view_pos(cam, camx, camy);
	camera_set_view_target(cam, targetinst)
}