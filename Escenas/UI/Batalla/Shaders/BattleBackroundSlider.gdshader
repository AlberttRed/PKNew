shader_type canvas_item;

uniform vec2 Direction = vec2(1.0, 0.0);
uniform float Speed = 0.08;
uniform sampler2D overlay;

void fragment() {

	vec4 overlay_texture = texture(TEXTURE, mod(vec2(UV.x/2.0, UV.y/2.0) + TIME * (Speed/20.0) * Direction, 1));
	COLOR.rgb = overlay_texture.rgb;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
