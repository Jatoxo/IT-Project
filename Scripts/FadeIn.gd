extends ColorRect

export(float, 0, 5) var fadeDelay = 0
export(float, 0.1, 4) var fadeSpeed = 2

func _ready():
	color = ProjectSettings.get_setting("application/boot_splash/bg_color")
	
	$FadeIn.playback_speed = fadeSpeed
	if fadeDelay != 0:
		yield(get_tree().create_timer(fadeDelay), "timeout")
	
	

	$FadeIn.play("Open")
