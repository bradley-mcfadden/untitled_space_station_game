shader_type canvas_item;

void fragment(){
	COLOR = texture(TEXTURE, UV);
	COLOR.r = 0.5 + (0.5 * sin(4.0 * TIME + 50.0));
	COLOR.b = 0.5 + (0.5 * sin(4.0 * TIME + 50.0));
}