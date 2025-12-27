shader_type canvas_item;
const float speed = 0.5;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR.r *= 0.4 * abs(cos(TIME* speed * 0.5));
	COLOR.g += 0.1 * abs(sin(TIME * speed * 1.1));
	COLOR.b += 0.09 * abs(cos(TIME * speed));
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
