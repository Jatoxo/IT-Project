extends KinematicBody2D


## Acceleration Curve for the player
export var accelerationCurve : Curve = Curve.new()
export var maxSpeed := 200
export var gravity : float = 2500
export var jump = 1000


var motion := Vector2.ZERO


var upDirection = Vector2.UP

onready var sprite : AnimatedSprite = $AnimatedSprite



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if motion.x < 0:
		sprite.flip_h = true
	if motion.x > 0:
		sprite.flip_h = false
		
	if is_on_floor():
		if motion.x != 0:
			sprite.play("run")
			
			var speed : float = abs(motion.x)
			sprite.speed_scale = (speed / maxSpeed)
		else:
			sprite.play("idle")
	else:
		if motion.y < 0:
			sprite.play("up")
		if motion.y > 0:
			sprite.play("down")
			
	sprite.rotation = Vector2.UP.angle_to(upDirection)

func _physics_process(delta: float) -> void:
	var vector := Vector2(0,0)
	
	motion -= upDirection * gravity * delta
	
	vector.x = Input.get_axis("Move Left", "Move Right")
	
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		motion.y = -jump
	
	
	motion.x = maxSpeed * vector.x
	
	motion = move_and_slide(motion, Vector2.UP)
