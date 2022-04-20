class_name Player
extends KinematicBody2D


## Acceleration Curve for the player
export var accelerationCurve : Curve = Curve.new()
export var maxSpeed := 200
export var gravity : float = 2500
export var jump = 1000

const textbox = preload("res://Scenes/Textbox.tscn")


signal coin_collected
signal respawned
signal textbox_closed

var spawn : Vector2

var motion := Vector2.ZERO
var die = false

var upDirection = Vector2.UP

onready var sprite : AnimatedSprite = $AnimatedSprite

var block_movement = false

var gravField = null


var coins := 0 setget set_coins, get_coins
var totalCoins := 0  setget set_total_coins, get_total_coins
onready var coinLabel = $CanvasLayer/Control/HBoxContainer/Coins

var rotationfix = 0.0 setget set_rot, get_rot 
	
func set_rot(var newvalue):
	rotationfix = newvalue
	rotation = rotationfix
	
func get_rot():
	return rotationfix


func set_coins(new_value):
	coins = new_value
	coinLabel.set_text(str(coins) + "/" + str(totalCoins))

func get_coins():
	return coins
	
func set_total_coins(new_value):
	totalCoins = new_value
	coinLabel.set_text(str(coins) + "/" + str(totalCoins))

func get_total_coins():
	return totalCoins

func _unhandled_input(event: InputEvent) -> void:
	if block_movement:
		return
	if event.is_action_pressed("Q"):
		showTextbox(["You pressed the q button.", "Good job.", "(This is for debugging)"])
	elif event.is_action_pressed("Die"):
		die()



func _ready() -> void:
	$AnimationPlayer.play("reset")
	coinLabel.set_text(str(coins) + "/" + str(totalCoins))



func complete():
	if(get_parent().has_method("complete")):
		get_parent().complete()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	var rot = stepify(-rad2deg(upDirection.angle_to(Vector2.UP)), 0.05)
	
	var normal_motion = motion.rotated(-deg2rad(rot))
	normal_motion.x = stepify(normal_motion.x, 0.0001)
	
	
	if normal_motion.x < -0.1:
		sprite.flip_h = true
	if normal_motion.x > 0.1:
		sprite.flip_h = false
		
	if is_on_floor():
		if abs(normal_motion.x) > 0.2 and not block_movement:
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
	if not block_movement:
		
		var vector := Vector2(0,0)
		var rot = stepify(rad2deg(-upDirection.angle_to(Vector2.UP)), 0.05)
		rot = deg2rad(rot)
		
		motion = motion.rotated(-rot)
		motion.x = stepify(motion.x, 0.0001)
		motion.y = stepify(motion.y, 0.0001)
		
		motion.y += gravity * delta 
		
		
		vector.x = Input.get_axis("Move Left", "Move Right")
		
		if Input.is_action_just_pressed("Jump") and is_on_floor():
			motion.y -= jump 
			$Jump.play()
		
		if not is_on_wall():
			motion.x = vector.x * maxSpeed

		
		motion = motion.rotated(rot)
		
		#For some reason the x component of motion is not zero when it should be by a very small amount, so round it down
		motion.x = stepify(motion.x, 0.0001)
		
		
		motion = move_and_slide(motion, upDirection, true, 4, deg2rad(20))
		
	
	#Handle collision with TileMap
	for i in range(get_slide_count()):
		
		var collision = get_slide_collision(i)
		if collision.collider is TileMap:
			var tilemap : TileMap = collision.collider
			var cell = tilemap.world_to_map(collision.position - collision.normal)
			var tile_id = tilemap.get_cellv(cell)
			#If player collides with spikes, death
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
	if direction == upDirection:
		return
	
	upDirection = direction
	
	
	var target_rot = Vector2.UP.angle_to(upDirection)
	#Convert rotation into a positive value
	if target_rot < 0:
		target_rot = 2.0*PI - abs(target_rot)

	
	var fixrot = rotation
	if fixrot < 0:
		fixrot = 2.0*PI - abs(fixrot)
	
	rotationfix = fmod(fixrot, 2.0*PI)
	
	
	if abs(rad2deg(target_rot) - rad2deg(fixrot)) > 300:
		if rad2deg(target_rot) - rad2deg(fixrot) <= 0:
			target_rot = target_rot + (4.0*PI)
		
		rotationfix += 2*PI
		
	
	if not instant:
		$GravitySwoosh.play()
		$Tween.interpolate_property(self, "rotation", null, target_rot, 0.3,Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		$Tween.start()
		block_movement = true
		yield(get_tree().create_timer(0.2), "timeout")
		block_movement = false
	else:
		
		$Tween.interpolate_property(self, "rotationfix", rotationfix, target_rot, 0.1, Tween.TRANS_LINEAR)
		$Tween.start()
		
	
func reset_gravity():
	set_gravity(Vector2.UP)



func die():
	block_movement = true
	motion = Vector2.ZERO
	$AnimationPlayer.play("die")
	yield(get_node("AnimationPlayer"), "animation_finished")
	$AnimationPlayer.play("reset")
	reset_gravity()
	global_position = spawn
	emit_signal("respawned")
	die = false
	block_movement = false
	


func _on_Player_coin_collected() -> void:
	coins += 1
	coinLabel.set_text(str(coins) + "/" + str(totalCoins))
	if coins == totalCoins:
		if(get_parent().has_method("allCoins")):
			get_parent().allCoins()


func _on_Area_area_entered(area: Area2D) -> void:
	if area.is_in_group("Coin"):
		area.collect()
		emit_signal("coin_collected")


func showTextbox(var text, var closed = null):
	var boxes = $GUI/Control/Textboxes.get_children()
	for textbox in boxes:
		if not textbox.closed:
			textbox.close(true)
		textbox.queue_free() 
	
	var new_box = textbox.instance()
	new_box.name = "Textbox"
	new_box.set_text(text)
	
	$GUI/Control/Textboxes.add_child(new_box)
	new_box.open()
	block_movement = true
	yield(new_box, "closed")
	
	if closed != null and has_method(closed):
		call(closed)
	block_movement = false
	emit_signal("textbox_closed")

func dieMsg():
	$Die.start()

func read_sign():
	block_movement = true
	
func quit_sign():
	block_movement = false


func _on_Die_timeout() -> void:
	die()
