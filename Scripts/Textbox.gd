extends NinePatchRect

signal nextLine
signal closed

var closed = true

var lines = ["I am a textbox"]
var currentLine = 0

var finalpos

	
	
func set_text(var text):
	if not text is Array:
		text = [text]
		
	lines = text

func open():
	closed = false
	currentLine = 0
	displayText()
	visible = true
	$BoxAnim.play("Reveal")
	
	if finalpos == null:
		finalpos = rect_position
	
	$Tween.interpolate_property(self, "rect_position", rect_position + Vector2(0, 500), finalpos, 0.3, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.start()

func close():
	if not closed:
		closed = true
		$BoxAnim.play_backwards("Reveal")
		
		$Tween.interpolate_property(self, "rect_position", null, rect_position + Vector2(0, 200), 0.3, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		$Tween.start()
		yield($BoxAnim, "animation_finished")
		visible = false
		emit_signal("closed")
	

func _input(event: InputEvent) -> void:
	if not closed and event.is_action_pressed("confirm"):
		advance()
		
func advance():
	if closed:
		return
	if $TextAnim.is_playing():
		$TextAnim.seek(1, true)
		return
			
	currentLine += 1
	if currentLine >= lines.size():
		close()
		return
	emit_signal("nextLine")
	displayText()
	
func displayText():
	$MarginContainer/Label.set_text(lines[currentLine])
	$TextAnim.play("Reveal")

func _ready() -> void:
	visible = false



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_TextureButton_pressed() -> void:
	advance()
