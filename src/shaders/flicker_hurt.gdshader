shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
	VERTEX.xy += sin(TIME * 100.0) *7.0;
}

void fragment() {
	// Called for every pixel the material is visible on.
	COLOR.r += 50.0;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
