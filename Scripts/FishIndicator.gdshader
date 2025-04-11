shader_type spatial;

uniform vec4 aoe_color : source_color = vec4(1.0, 1.0, 1.0, .5);
uniform float speed : hint_range(0.1, 5.0) = 1.0;

//Crear randomness técnicamente
float random(vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453123);
}

void fragment() {
	float d = distance(UV, vec2(0.5)) * 1.3; // DISTANCE
    d += (random(UV * 10.0) - 0.5) * 0.05; // RANDOMNESS
	float animated_fill = 0.5 - fract(TIME * speed - fract(d*10.0)) * 0.5; //TIME
	ALPHA = 0.0;

	//ANIMATION
	if (d < animated_fill)
		ALPHA = 1.0 * aoe_color.a;

	ALBEDO = aoe_color.xyz;
}