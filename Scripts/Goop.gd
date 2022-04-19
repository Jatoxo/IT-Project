extends Sprite


export(Vector2) var speed = Vector2(0.3,0.2)

var noiseText : NoiseTexture 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	noiseText = texture
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#noiseText.noise_offset += speed;
	
