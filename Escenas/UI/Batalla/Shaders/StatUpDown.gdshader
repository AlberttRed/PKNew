shader_type canvas_item;

uniform vec2 Direction = vec2(1.0, 0.0);
uniform float Speed = 0.08;
uniform sampler2D overlay;

void fragment() {
	//vec4 overlay_texture = texture(overlay, mod(UV + TIME * Speed * Direction, 1));
	vec4 overlay_texture = texture(overlay, mod(vec2(UV.x/2.0, UV.y/2.0) + TIME * (Speed/2.0) * Direction, 1));
	COLOR.rgb = overlay_texture.rgb;
}