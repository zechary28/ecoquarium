shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float light_level : hint_range(0.0, 1.0) = 0.55;
uniform vec3 night_tint : source_color = vec3(0.025, 0.075, 0.15);
uniform vec3 daylight_tint : source_color = vec3(1.08, 1.06, 0.98);
uniform float night_vignette : hint_range(0.0, 1.0) = 0.48;

void fragment() {
	vec3 source = textureLod(screen_texture, SCREEN_UV, 0.0).rgb;
	float daylight = smoothstep(0.0, 1.0, light_level);

	// A small blue pool in the centre keeps silhouettes readable at level zero.
	float centre_distance = distance(SCREEN_UV, vec2(0.50, 0.43));
	float ambient_pool = 1.0 - smoothstep(0.08, 0.72, centre_distance);
	vec3 night = source * vec3(0.035, 0.065, 0.13);
	night += night_tint * (0.035 + ambient_pool * 0.075);

	// The top setting is intentionally brighter and slightly warmer than the art.
	vec3 day = source * daylight_tint * 1.22 + vec3(0.035, 0.030, 0.018);
	vec3 graded = mix(night, day, pow(daylight, 0.82));

	float edge = smoothstep(0.28, 0.78, centre_distance);
	graded *= 1.0 - edge * night_vignette * (1.0 - daylight);

	COLOR = vec4(clamp(graded, vec3(0.0), vec3(1.0)), 1.0);
}
