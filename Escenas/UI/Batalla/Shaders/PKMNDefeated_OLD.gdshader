shader_type canvas_item;
uniform float cutoff : hint_range(0, 100);
uniform float VIEWPORT_HEIGHT = 384.0;
varying vec2 world_position;

void vertex() {
	// Called for every vertex the material is visible on.
	world_position = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	// Called for every pixel the material is visible on.

	float y = VIEWPORT_HEIGHT / 100.0 * cutoff;

	if (world_position.y < y) {
		COLOR = texture(TEXTURE, UV);
	}else{
		COLOR = vec4(1,1,1, 0);
	}
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.

}
