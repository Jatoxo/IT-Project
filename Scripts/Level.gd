extends BaseLevel
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"



var deathsInTheEndlessAbyss = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player.spawn = get_node(spawn_node).global_position
	for child in $Coins.get_children():
		if child.is_in_group("Coin"):
			$Player.totalCoins += 1

func complete():
	var _err = get_tree().change_scene("res://Scenes/Level2.tscn")
	
func allCoins():
	player.showTextbox(["You have collected all the coins in this level.", "Congratulations.", "That is all you can do here.", "Have fun."])

func _process(_delta: float) -> void:
	
	if($Player.global_position.y > 10000 and not $Player.die):
		$Player.die = true
		deathsInTheEndlessAbyss += 1
		if(deathsInTheEndlessAbyss == 1):
			$Player.showTextbox(["You appear to be falling into the endless abyss.", "Well done.", "...", "Here, let's fix that."], "dieMsg")
			$ExtraSigns.visible = true
			$Sign.setSignText(["THERE ARE NO BOTTOMLESS PITS IN THIS LEVEL", "DON'T EVEN BOTHER"])
			$Sign.reaction = ["I could have sworn it said something else earlier..."]
		elif(deathsInTheEndlessAbyss == 2):
			$Player.showTextbox(["You're here again?", "Truly, incredible.", "There was nothing here last time, why come back?", "You are just going to die again."], "dieMsg")
			$ExtraExtraSigns.visible = true
			$Sign.scale = Vector2(1.6, 1.6)
			$Sign.setSignText(["Enjoy the solid ground.", "It is everywhere.", "The ground.", "No pits.", "OKAY?"])
			$Sign.reaction = ["It seems...", "More aggressive."]
		else:
			$Player.showTextbox(["You are persistent, I'll give you that.", "Alright, Alright, you can have somewhere else to play."], "complete")
			

