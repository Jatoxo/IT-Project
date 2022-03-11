extends KinematicBody2D


## Acceleration Curve for the player
export var accelerationCurve : Curve = Curve.new()
export var maxSpeed := 200
export var gravity : float = 2500
export var jump = 1000


var motion := Vector2.ZERO


var upDirection = Vector2.UP

onready var sprite : AnimatedSprite = $AnimatedSprite




func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Action 1"):
		next_gravity()
	if event.is_action_pressed("Action 2"):
		prev_gravity()
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var rot = stepify(-rad2deg(upDirection.angle_to(Vector2.UP)), 0.05)
	
	var normal_motion = motion.rotated(-deg2rad(rot))
	normal_motion.x = stepify(normal_motion.x, 0.0001)
	#print(normal_motion)
	
	if normal_motion.x < 0:
		sprite.flip_h = true
	if normal_motion.x > 0:
		sprite.flip_h = false
		
	if is_on_floor():
		if normal_motion.x != 0:
			sprite.play("run")
			
			var speed : float = abs(normal_motion.x)
			sprite.speed_scale = (speed / maxSpeed)
		else:
			sprite.play("idle")
	else:
		if normal_motion.y < 0:
			sprite.play("up")
		if normal_motion.y > 0:
			sprite.play("down")
			


func _physics_process(delta: float) -> void:
	var vector := Vector2(0,0)
	var rot = stepify(rad2deg(-upDirection.angle_to(Vector2.UP)), 0.05)
	rot = deg2rad(rot)
	
	motion = motion.rotated(-rot)
	motion.x = stepify(motion.x, 0.0001)
	motion.y = stepify(motion.y, 0.0001)
	#print(motion)
	motion.y += gravity * delta 
	
	
	vector.x = Input.get_axis("Move Left", "Move Right")
	
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		motion.y -= jump 
	
	
	motion.x = vector.x * maxSpeed

	
	motion = motion.rotated(rot)
	
	#For some reason the x component of motion is not zero when it should be by a very small amount, so round it down
	motion.x = stepify(motion.x, 0.0001)
	
	#print(motion)
	motion = move_and_slide(motion, upDirection)
	#print(motion)


func _on_CheckButton_toggled(button_pressed: bool) -> void:
	set_gravity(Vector2.DOWN if button_pressed else Vector2.UP)


func next_gravity():
	var gravities = [Vector2.UP, Vector2.LEFT, Vector2.DOWN, Vector2.RIGHT]
	set_gravity(gravities[(gravities.find(upDirection) + 1)%gravities.size()])
	
func prev_gravity():
	var gravities = [Vector2.UP, Vector2.LEFT, Vector2.DOWN, Vector2.RIGHT]
	set_gravity(gravities[(gravities.find(upDirection) - 1)%gravities.size()])
	
func set_gravity(var direction : Vector2):
	upDirection = direction
	
	$Tween.interpolate_property(self, "rotation", null, Vector2.UP.angle_to(upDirection), 0.3,Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.start()


