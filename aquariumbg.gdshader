shader_type canvas_item;

// Uniform to control the greyscale strength (1.0 = full greyscale, 0.0 = full color)
uniform float greyscale_amount : hint_range(0.0, 1.0) = 1.0;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    // Standard perceived luminance weights (matches human eye sensitivity)
    float gray = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));
    vec3 grayscale_color = vec3(gray);
    
    COLOR = vec4(mix(tex_color.rgb, grayscale_color, greyscale_amount), tex_color.a);
}