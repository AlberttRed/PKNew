shader_type canvas_item;

uniform vec2 Direction = vec2(1.0, 0.0);
uniform float Speed = 0.08;
uniform float opacity: hint_range(0.0, 1.00) = 1.00;
uniform sampler2D overlay;

void fragment() {



	//OKvec4 overlay_texture = texture(overlay, mod(vec2(UV.x/2.0, UV.y/2.0) + TIME * (Speed/2.0) * Direction, 1));
	//COLOR.rgb = overlay_texture.rgb;
	//COLOR.rgb = texture(TEXTURE, UV).rgb*(overlay_texture.rgb);// / opacity);

	vec4 base_teture = texture(TEXTURE, UV);
	vec4 overlay_texture = texture(overlay, mod(vec2(UV.x/2.0, UV.y/2.0) + TIME * (Speed/2.0) * Direction, 1));
	vec4 color = texture(overlay, UV);

	COLOR.rgb = mix(base_teture.rgb, overlay_texture.rgb, overlay_texture.a * opacity);
	//overlay_texture.a -= overlay_texture.r * opacity;
	//mix
	//COLOR = overlay_texture;
}