shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR = mix(vec4(0.5, 0.58, 0.78, 1.0), vec4(1.0, 0.87, 0.67, 1.0), UV.y);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
