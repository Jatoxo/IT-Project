extends Area2D


func collect():
	#Make sure the coin can't be collected twice by disabling monitoring
	set_deferred("monitorable", false)
	$Anim.play("collect")
	yield($Anim, "animation_finished")
	queue_free()

