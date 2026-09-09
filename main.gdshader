shader_type canvas_item;

uniform float speed : hint_range(0.5, 10.0) = 2.5;
uniform float sway_strength : hint_range(0.0, 50.0) = 12.0;
uniform float sway_phase_offset : hint_range(0.0, 6.28) = 0.0;

void vertex() {
    // (1.0 - UV.y) is 0.0 at the bottom roots and 1.0 at the top tip
    float height_factor = clamp(1.0 - UV.y, 0.0, 1.0);
    
    // Non-linear bend so the tip curves more dramatically than the base
    float bend = pow(height_factor, 1.5);
    
    // Displace vertex position along the X-axis over time
    float sway = sin(TIME * speed + sway_phase_offset) * sway_strength * bend;
    VERTEX.x += sway;
}
