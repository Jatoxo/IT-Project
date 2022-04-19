extends BaseLevel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.spawn = get_node(spawn_node).global_position
	
	for child in $Coins.get_children():
		if child.is_in_group("Coin"):
			player.totalCoins += 1


func allCoins():
	player.showTextbox(["You have collected all the coins in this level.", "There were only 2.", "You really didn't achieve much.", "Just keep running in circles."])
