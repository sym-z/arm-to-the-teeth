shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
	VERTEX.x += sin(TIME);
	VERTEX.y += cos(TIME);
	VERTEX.x = VERTEX.x * max(1.,((abs(cos(TIME*2.)) + 0.01))) ;
	VERTEX.y = VERTEX.y * max(1.,((abs(cos(TIME*2.)) + 0.01))) ;
}

void fragment() {
	COLOR.rgb *= abs(sin(TIME));
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
