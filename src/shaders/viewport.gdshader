shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture;
uniform sampler2D image: source_color;
void vertex() {
	// Called for every vertex the material is visible on.
}
const float brightness = 0.18;
const float darken = 0.25;
void fragment() {
	if (texture(image,UV).r <= 0.37){
		COLOR=  texture(screen_texture, SCREEN_UV)  +  texture(image,UV)*vec4(brightness);
	}
	else{
		COLOR = texture(screen_texture,SCREEN_UV);
	}
	
	//COLOR *= vec4(darken,darken,darken,darken);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
