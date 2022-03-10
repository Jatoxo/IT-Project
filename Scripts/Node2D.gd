extends Node2D


func _ready():
	pass
	$CanvasLayer/HSlider.value = $Icon.material.get_shader_param("zooms")
	$CanvasLayer/HSlider2.value = $Icon.material.get_shader_param("flooms")
	

func _input(event):
	
	if event.is_action_pressed("space"):
		print("mogu")
		OS.window_borderless = !OS.window_borderless
	elif event.is_action_pressed("f"):
	
		OS.window_fullscreen = !OS.window_fullscreen
	
	



func _on_HSlider_value_changed(value):
	$Icon.material.set_shader_param("zooms", value)


func _on_HSlider2_value_changed(value):
	$Icon.material.set_shader_param("flooms", value)
















