if instance_exists(creator) and creator.wave_trailID!=id {
	image_alpha-=0.01

	if image_alpha<=0 {
		instance_destroy()
	}
}