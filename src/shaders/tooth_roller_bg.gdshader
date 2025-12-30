shader_type canvas_item;
uniform float green_tint = 1.0;
uniform float red_tint = 1.0;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR.r = min(1., red_tint*COLOR.r);
	COLOR.g = min(1., green_tint*COLOR.g);
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
