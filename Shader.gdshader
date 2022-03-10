shader_type canvas_item;

uniform float blue = 1.0;
uniform float zooms = 1;
uniform float flooms = 1;

void fragment(){
	COLOR = texture(TEXTURE, UV); //read from texture
	
	COLOR.r = texture(TEXTURE, UV).r *(0.5f + 0.5f * (cos(TIME * 1.5f) + 1f)/2f);
	COLOR.g = texture(TEXTURE, UV).g * (0.5f + 0.5f * (cos(TIME * 2f) + 1f)/2f);
	COLOR.b = texture(TEXTURE, UV).b * (0.5f + 0.5f * (cos(TIME * 2.5f) + 1f)/2f);
	
	//COLOR.a = texture(TEXTURE, UV).a * (0.5f + 0.5f * (cos(TIME * 10f) + 1f)/2f);
	
}

void vertex() {
	//Bottom Right
	VERTEX.y += UV.x * UV.y * 10.0 * (cos(TIME));
	VERTEX.x += UV.x * UV.y * 10.0 * (sin(TIME));
	//Bottom left
	VERTEX.y += (1f - UV.x) * UV.y * 10.0 * (sin(TIME));
	VERTEX.x -= (1f - UV.x) * UV.y * 10.0 * (cos(TIME));
	//Top Left
	VERTEX.y -= (1f - UV.x) * (1f - UV.y) * 10.0 * (cos(TIME));
	VERTEX.x -= (1f - UV.x) * (1f - UV.y) * 10.0 * (sin(TIME));
	//Top right
	VERTEX.y -= (UV.x) * (1f - UV.y) * 10.0 * (sin(TIME));
	VERTEX.x += (UV.x) * (1f - UV.y) * 10.0 * (cos(TIME));
	
	
	//Bottom Right
	VERTEX.y += UV.x * UV.y * 10.0 * (tan(TIME));
	VERTEX.x += UV.x * UV.y * 10.0 * (tan(TIME*0.5));
	//Bottom left
	VERTEX.y += (1f - UV.x) * UV.y * 10.0 * (tan(TIME));
	VERTEX.x -= (1f - UV.x) * UV.y * 10.0 * (tan(TIME*0.5));
	//Top Left
	VERTEX.y -= (1f - UV.x) * (1f - UV.y) * 10.0 * (tan(TIME));
	VERTEX.x -= (1f - UV.x) * (1f - UV.y) * 10.0 * (tan(TIME*0.5f));
	//Top right
	VERTEX.y -= (UV.x) * (1f - UV.y) * 10.0 * (tan(TIME));
	VERTEX.x += (UV.x) * (1f - UV.y) * 10.0 * (tan(TIME*0.5));
	
	VERTEX += vec2(tan(TIME*2f)*100.0*zooms, cos(TIME)*200.0*flooms);
}