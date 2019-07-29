shader_type canvas_item;

void fragment(){
	vec3 c = textureLod(TEXTURE, UV, 0.0).rgb;
	vec3 negative = vec3(1.0) - c;
	vec3 amplitude = abs(c - negative) / 2.0; 
	vec3 vertical_shift = vec3(min(negative, c)) + amplitude;
	vec3 adjust = vec3(negative.r < c.r ? 1. : -1., negative.g < c.g ? 1. : -1., negative.b < c.b ? 1. : -1.); 
	COLOR.rgb = (adjust * sin(TIME) * amplitude) + vertical_shift;
	
	// Remove me to make effect loop
	if (TIME >= 4.712) {
		COLOR.rgb = negative;
	}
}