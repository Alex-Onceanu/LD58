shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = 2.0 * UV - vec2(1., 1.);
	COLOR = (1. - step(1., dot(uv, uv))) * vec4(0., 0., 1., 1.);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
