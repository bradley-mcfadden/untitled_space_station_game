shader_type canvas_item;
void fragment(){
	COLOR = texture(TEXTURE, UV);
	if (UV.y < -UV.x + 2.0 * sin(TIME) && UV.y > -UV.x + 2.0 * sin(TIME) - 0.05){
		COLOR.r = 255.0;
		COLOR.g = 255.0;
		COLOR.b = 255.0;
	}
}