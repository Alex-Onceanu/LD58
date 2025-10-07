shader_type canvas_item;

uniform vec4 team_color : source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = 2.0 * UV - vec2(1., 1.);
	float alp = 2.0 * smoothstep(0.8, 1.0, length(uv)) * smoothstep(1.0, 0.8, length(uv));
	COLOR = vec4(team_color.rgb, alp);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
