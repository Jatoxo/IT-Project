extends StaticBody2D

var bodies := []



func _physics_process(_delta: float) -> void:
	for body in bodies:
		if body.name == "Player" and body.is_on_floor():
			var grav : Vector2 = body.get_floor_normal()
			
			body.set_gravity(grav.normalized(), true)


func _on_Area2D_body_entered(body: Node) -> void:
	bodies.append(body)
	


func _on_Area2D_body_exited(body: Node) -> void:
	bodies.erase(body)
	
