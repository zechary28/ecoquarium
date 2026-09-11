shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform vec4 wipe_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float pixel_size : hint_range(1.0, 16.0) = 2.0;

// Standard 4x4 Bayer Matrix
const float bayer_4x4[16] = float[16](
     0.0 / 16.0,  8.0 / 16.0,  2.0 / 16.0, 10.0 / 16.0,
    12.0 / 16.0,  4.0 / 16.0, 14.0 / 16.0,  6.0 / 16.0,
     3.0 / 16.0, 11.0 / 16.0,  1.0 / 16.0,  9.0 / 16.0,
    15.0 / 16.0,  7.0 / 16.0, 13.0 / 16.0,  5.0 / 16.0
);

void fragment() {
    // Snap fragments to pixel_size chunks so dithering matches retro game resolution
    vec2 pixel_coord = floor(FRAGCOORD.xy / pixel_size);
    int x = int(mod(pixel_coord.x, 4.0));
    int y = int(mod(pixel_coord.y, 4.0));
    int index = x + y * 4;

    float threshold = bayer_4x4[index];

    // Pixels turn to wipe_color progressively as progress increases
    if (progress > threshold) {
        COLOR = wipe_color;
    } else {
        COLOR = vec4(0.0);
    }
}