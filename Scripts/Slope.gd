extends StaticBody2D

var bodies := []
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	for body in bodies:
		if body.name == "Player" and body.is_on_floor():
			var grav : Vector2 = body.get_floor_normal()
			
			body.set_gravity(grav.normalized(), true)


func _on_Area2D_body_entered(body: Node) -> void:
	bodies.append(body)
	


func _on_Area2D_body_exited(body: Node) -> void:
	bodies.erase(body)
	
