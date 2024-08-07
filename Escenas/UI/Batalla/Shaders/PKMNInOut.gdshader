shader_type canvas_item;
render_mode unshaded;

uniform vec2 displacement = vec2(0.0, 0.0);
uniform vec2 velocity = vec2(1.0, 1.0);
uniform sampler2D noise: repeat_enable;

uniform vec4 color:source_color = vec4(1.0);
uniform float flash_modifier : hint_range(0.0, 1.0) = 0.0;
uniform float scale : hint_range(0.0, 1.0) = 1.0;
uniform float pos : hint_range(0.0, 1.0) = 1.0;
varying vec2 world_position; 
void vertex(){
	VERTEX.xy *= scale;
	//world_position = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy + (position*100.0);
	//UV.x *= 1;

}

void fragment()
{

	COLOR = texture(TEXTURE, UV);
	COLOR.rgb = mix(COLOR.rgb, color.rgb, flash_modifier);
	//
	
	//vec2 fixed_uv = displacement * UV;
    //float fog = texture(TEXTURE, fixed_uv).r;
    //COLOR = mix(vec4(0.0), color, fog);
	
	
	//COLOR = vec4(1,1,1, 1);
	    //ivec2 texsize = textureSize(TEXTURE,0);
    //float uv_frame_size = float(frame_size) / float(texsize.y);
    //float frame_time = anim_time / float(frames);
    //float time = mod(TIME, anim_time);
    //float frame = floor(time / frame_time);
//
    //vec2 uv = vec2(UV.x, UV.y + (uv_frame_size*frame));
	//
	//vec4 texture_color = texture(TEXTURE, UV);
	//COLOR = vec4(mix(texture_color.rgb, vec3(1,1,1), whitening), texture_color.a) * texture(frame1, uv + vec2(0, 0));
	
}
