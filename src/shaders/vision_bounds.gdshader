shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
	if (mod(VERTEX.x*100.0,2.0) < 0.1 && mod(VERTEX.y*100.0, 2.0) < 1.0){
	VERTEX.x += VERTEX.y * (sin(TIME)+cos(TIME));
	VERTEX.y += VERTEX.x * (sin(TIME)-cos(TIME));
	}
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
