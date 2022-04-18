extends KinematicBody2D


## Acceleration Curve for the player
export var accelerationCurve : Curve = Curve.new()
export var maxSpeed := 200
export var gravity : float = 2500
export var jump = 1000


signal coin_collected

var spawn : Vector2

var motion := Vector2.ZERO


var upDirection = Vector2.UP

onready var sprite : AnimatedSprite = $AnimatedSprite

var block_movement = false


var coins := 0
onready var coinLabel = $CanvasLayer/Control/HBoxContainer/Coins


func _unhandled_input(event: InputEvent) -> void:
	pass
	#if event.is_action_pressed("Action 1"):
	#	next_gravity()
	#if event.is_action_pressed("Action 2"):
	#	prev_gravity()
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("reset")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(rotation_degrees)
	print(rotation)
	var rot = stepify(-rad2deg(upDirection.angle_to(Vector2.UP)), 0.05)
	
	var normal_motion = motion.rotated(-deg2rad(rot))
	normal_motion.x = stepify(normal_motion.x, 0.0001)
	#print(normal_motion)
	
	if normal_motion.x < -0.1:
		sprite.flip_h = true
	if normal_motion.x > 0.1:
		sprite.flip_h = false
		
	if is_on_floor():
		if abs(normal_motion.x) > 0.2:
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
	
	if not is_on_wall():
		motion.x = vector.x * maxSpeed

	
	motion = motion.rotated(rot)
	
	#For some reason the x component of motion is not zero when it should be by a very small amount, so round it down
	motion.x = stepify(motion.x, 0.0001)
	
	#print(motion)
	if not block_movement:
		motion = move_and_slide(motion, upDirection)
	
	for i in range(get_slide_count()):
		
		var collision = get_slide_collision(i)
		if collision.collider is TileMap:
			var tilemap : TileMap = collision.collider
			var cell = tilemap.world_to_map(collision.position - collision.normal)
			var tile_id = tilemap.get_cellv(cell)
			if tile_id == 3:
				die()
			
	
	


func _on_CheckButton_toggled(button_pressed: bool) -> void:
	set_gravity(Vector2.DOWN if button_pressed else Vector2.UP)


func next_gravity():
	var gravities = [Vector2.UP, Vector2.LEFT, Vector2.DOWN, Vector2.RIGHT]
	set_gravity(gravities[(gravities.find(upDirection) + 1)%gravities.size()])
	
func prev_gravity():
	var gravities = [Vector2.UP, Vector2.LEFT, Vector2.DOWN, Vector2.RIGHT]
	set_gravity(gravities[(gravities.find(upDirection) - 1)%gravities.size()])
	
func set_gravity(var direction : Vector2, var instant = false):
	upDirection = direction
	
	var target_rot = Vector2.UP.angle_to(upDirection)
	
	
	if not instant:
		$Tween.interpolate_property(self, "rotation", null, target_rot, 0.3,Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		$Tween.start()
	else:
		$Tween.interpolate_property(self, "rotation", null, target_rot, 0.1, Tween.TRANS_LINEAR)
		$Tween.start()
		
	
func reset_gravity():
	set_gravity(Vector2.UP)




func _on_spokey_body_entered(body: Node) -> void:
	pass # Replace with function body.

func die():
	block_movement = true
	$AnimationPlayer.play("die")
	yield(get_node("AnimationPlayer"), "animation_finished")
	$AnimationPlayer.play("reset")
	global_position = spawn
	block_movement = false
	


func _on_Player_coin_collected() -> void:
	coins += 1
	$CanvasLayer/Control/HBoxContainer/Coins.set_text
