class_name BaseLevel
extends Node2D

export(NodePath) var spawn_node

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var player 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_nodes_in_group("Player")[0]
	pass # Replace with function body.

func allCoins():
	player.showTextbox(["You have collected all the coins in this level.", "Congratulations.", "You may now restart the game and do it all over again.", "Have fun."])

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
