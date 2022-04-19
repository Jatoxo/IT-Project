extends Sprite


export(Vector2) var speed = Vector2(0.3,0.2)

var noiseText : NoiseTexture 


func _ready() -> void:
	noiseText = texture
	

#func _process(delta: float) -> void:
	#This caused terrible lag so it was removed
	#noiseText.noise_offset += speed;
	
