extends ColorRect


func _ready():
	color = ProjectSettings.get_setting("application/boot_splash/bg_color")

	$FadeIn.play("Open")
