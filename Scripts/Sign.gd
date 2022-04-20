extends Area2D


export(Array, String, MULTILINE) var signText = ["I am a sign."]

var reaction = []


var reachable = false

onready var textbox = $CanvasLayer/Control/Textbox

var reader 
var reacted = false

	
func setSignText(var text):
	if not text is Array:
		text = [text]
	signText = text
	

func read():
	if not textbox.closed:
		return
	
	if reader.has_method("read_sign"):
		reader.read_sign()
		reacted = false
		var text = ["The sign reads:"]
		var paddedText = signText.duplicate()
		for i in range(paddedText.size()):
			paddedText[i] = "\"" + paddedText[i] + "\""
			
		text.append_array(paddedText)
		textbox.set_text(text)
		textbox.open()
	


func _unhandled_input(event: InputEvent) -> void:
	if reachable and not reader.block_movement and event.is_action_pressed("Interact"):
		read()
		get_tree().set_input_as_handled()



func _on_Sign_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		reader = body
		reachable = true
		$Animation.play("ReadHint")


func _on_Sign_body_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		reachable = false
		$Animation.play_backwards("ReadHint")


func _on_Textbox_closed() -> void:
	if(not reacted and reaction.size() != 0):
		reacted = true
		textbox.set_text(reaction)
		textbox.open()
		return
		
	if reader.has_method("quit_sign"):
		reader.quit_sign()
