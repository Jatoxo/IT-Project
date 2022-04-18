extends Area2D

tool

export(Vector2) var gravityDirection = Vector2.UP
export(Vector2) var expanse = Vector2(100, 50)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var shape : RectangleShape2D = $CollisionShape2D.shape
	shape.extents = expanse
	var size = shape.extents * 2
	$PanelContainer.rect_size = size
	$PanelContainer.rect_position = $CollisionShape2D.position - size * 0.5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.editor_hint:
		var shape : RectangleShape2D = $CollisionShape2D.shape
		shape.extents = expanse
		var size = shape.extents * 2
		$PanelContainer.rect_size = size
		$PanelContainer.rect_position = $CollisionShape2D.position - size * 0.5
		
#	pass


func _on_GravityField_body_entered(body: Node) -> void:
	yield(get_tree().create_timer(0.1), "timeout")
	if body.has_method("set_gravity"):
		body.set_gravity(gravityDirection.normalized() * -1)
	


func _on_GravityField_body_exited(body: Node) -> void:
	yield(get_tree().create_timer(0.1), "timeout")
	if body.has_method("reset_gravity"):
		body.reset_gravity()
