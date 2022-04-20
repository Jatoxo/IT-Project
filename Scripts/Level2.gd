extends BaseLevel

var lastPos = -1
var laps = 0 setget set_laps, get_laps

var visited = []

var ded = 0

var spikes_spawned = false

func set_deaths(var new_val):
	ded = new_val
	if(ded == 4):
		get_node(spawn_node).global_position.y -= 280
		player.spawn = get_node(spawn_node).global_position
		yield(player, "respawned")


func complete():
	print("You have beaten the game")
	pass

func _process(_delta: float) -> void:
	
	
		
		
	if(player.global_position.y > 10000 and not player.die):
		player.die = true
		player.showTextbox(["Here you are again.", "In a bottomless pit.", "What an achievement."], "complete")
		yield(player, "textbox_closed")
		player.showTextbox(["You have beaten the game."])
		



func set_laps(var new_laps : int) -> void:
	laps = new_laps
	#print(laps)
	
	match new_laps:
		3:
			player.showTextbox(["You have completed three laps.", "Incredible work.", "You are not getting anywhere."])
		6:
			player.showTextbox(["Yup.", "You ran six laps.", "Have another text box.", "Happy?"])
		10:
			player.showTextbox(["You're still doing this?", "...", "That's ten laps."])
		11:
			player.showTextbox(["You know what?", "Let me help you out with that.", "...", "There you go..."])
			player.maxSpeed = 500
		20:
			player.showTextbox(["Look at you go!", "20 pointless laps!", "..."])
		23:
			player.showTextbox(["Why don't we make this a little more interesting..."])
			yield(player, "textbox_closed")
			player.block_movement = true
			yield(get_tree().create_timer(0.5), "timeout")
			spawn_spikes()
			yield(get_tree().create_timer(0.5), "timeout")
			player.showTextbox(["Try doging these!"])
			yield(player, "respawned")
			
			#yield(get_tree().create_timer(0.1), "timeout")
			
			player.showTextbox(["Wow.", "Can't even dodge some tiny spikes?", "Keep trying, you'll get it.", "There is a reward at 100 laps.", "Good luck."])
			#yield(player, "textbox_closed")
			
	
func get_laps() -> int:
	return laps

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.spawn = get_node(spawn_node).global_position
	
	for child in $Coins.get_children():
		if child.is_in_group("Coin"):
			player.totalCoins += 1
			
	player.block_movement = true
	yield(get_tree().create_timer(3), "timeout")
	player.block_movement = false


func allCoins():
	player.showTextbox(["You have collected all the coins in this level.", "There were only 2.", "You really didn't achieve much.", "Just keep running in circles."])


func spawn_spikes():
	spikes_spawned = true
	var map : TileMap = $TileMap
	map.set_cell(11, -1, 3, true, false, true)
	map.set_cell(13, -1, 3, false, false, true)

func _on_loop_count_body_exited(body: Node, pos : int) -> void:
	if(body.is_in_group("Player")):
		if not pos in visited:
			visited.append(pos)
			
		#Count laps:
		#If you go from position 0 to position 0 and all other stops were in between,
		#regardless in which order or how many times, count a lap
		if pos == 0:
			var valid = true
			for i in range(4):
				if not i in visited:
					valid = false
					break
			if valid:
				set_laps(laps + 1)
			
			visited.clear()
			
			



func _on_Player_respawned() -> void:

	if spikes_spawned:
		set_deaths(ded + 1)
