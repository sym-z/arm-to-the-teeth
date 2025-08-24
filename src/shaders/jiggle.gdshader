shader_type canvas_item;
const float SPEED = 3.0;
const float OFFSET_X = 5.0;
const float OFFSET_Y = 2.0;

void vertex() {
	// Called for every vertex the material is visible on.
	VERTEX.x += (OFFSET_X * sin(TIME*SPEED)) + (OFFSET_X * cos(TIME * SPEED));
	VERTEX.y += (OFFSET_Y * sin(TIME*SPEED)) + (OFFSET_Y * cos(TIME * SPEED));

}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
