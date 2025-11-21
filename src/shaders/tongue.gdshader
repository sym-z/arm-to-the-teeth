shader_type canvas_item;
uniform bool v_shake = false;
uniform float intensity = 100.0;
uniform float span = 1.0;

uniform float saturation = 0.45;
uniform float tint_speed = 8.5;

uniform bool attacking = true;
void vertex() {
	// Called for every vertex the material is visible on.
	if (attacking){
		if (v_shake == false){
			VERTEX.x += sin(TIME*intensity) * span;
		}
		else{
			VERTEX.y += sin(TIME*intensity) * span;
		}
	}
}

void fragment() {
	// Called for every pixel the material is visible on.
	if (attacking == true){
		COLOR.r = min(255, COLOR.r + (cos(TIME*tint_speed * 2.0) + 1.0)/2.0 * saturation);
		COLOR.g = max(0.0, COLOR.g - (cos(TIME*tint_speed * 2.0) + 1.0)/2.0 * saturation);
		COLOR.b = max(0.0, COLOR.g - (cos(TIME*tint_speed * 2.0) + 1.0)/2.0 * saturation);
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
