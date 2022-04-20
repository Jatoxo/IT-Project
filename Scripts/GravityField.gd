extends Area2D

tool

export(Vector2) var gravityDirection = Vector2.UP
export(Vector2) var expanse = Vector2(100, 50) setget set_expanse, get_expanse



func _ready() -> void:
	#Duplicate to prevent different instances using the same shape instance
	$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate()
	
	update_shapes()



func set_expanse(var new_val : Vector2) -> void:
	expanse = new_val
	update_shapes()

func get_expanse() -> Vector2:
	return expanse

func update_shapes() -> void:
	var shape : RectangleShape2D = $CollisionShape2D.shape
	shape.extents = expanse
	var size = shape.extents * 2
	$PanelContainer.rect_size = size
	$PanelContainer.rect_position = $CollisionShape2D.position - size * 0.5
	$TextureRect.rect_rotation = rad2deg(Vector2.UP.angle_to(gravityDirection))



func _on_GravityField_body_entered(body: Node) -> void:
	body.gravField = self
	$ExitTimer.stop()
	yield(get_tree().create_timer(0.1), "timeout")
	if body.has_method("set_gravity"):
		body.set_gravity(gravityDirection.normalized() * -1)
	


func _on_GravityField_body_exited(body: Node) -> void:
	$ExitTimer.start()
	yield($ExitTimer, "timeout")
	if body.has_method("reset_gravity"):
		if body.gravField == self:
			body.reset_gravity()
	
