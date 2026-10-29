// Crimson Black live wallpaper: mpv user shader, run per output by omarchy-livewall through mpvpaper.
//
// Hooks MAIN (the only resizable stage before scaling) and renders at half the output size; mpv's scaler
// brings it to full resolution. OLED rules match gen_wallpapers.py: near-black, crimson only as soft low
// light, the top 6% (waybar zone) kept dark, and a hard black floor so unlit pixels stay fully off.
// Motion orbits through noise space, so it loops seamlessly every LOOP_SECONDS.

//!HOOK MAIN
//!BIND HOOKED
//!DESC crimson-black embers
//!WIDTH OUTPUT.w 2 /
//!HEIGHT OUTPUT.h 2 /

const int FPS = 30;                // matches the lavfi source rate in omarchy-livewall
const int LOOP_SECONDS = 480;
const vec3 CRIMSON = vec3(224.0, 17.0, 43.0) / 255.0;
const float PEAK = 0.34;           // brightest ember as a fraction of full crimson

float hash(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i), hash(i + vec2(1.0, 0.0)), u.x),
               mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), u.x), u.y);
}

float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    mat2 rotate = mat2(0.8, -0.6, 0.6, 0.8);
    for (int octave = 0; octave < 5; octave++) {
        value += amplitude * noise(p);
        p = rotate * p * 2.03 + 11.7;
        amplitude *= 0.5;
    }
    return value;
}

vec4 hook() {
    vec2 uv = HOOKED_pos;                                   // 0..1, y grows downward
    float aspect = target_size.x / target_size.y;           // real screen shape (HOOKED is the 16:9 dummy source); portrait-safe
    vec2 p = vec2(uv.x * aspect, uv.y) * 2.2;

    // Integer modulo keeps the phase exact no matter how long mpv has been running.
    int period = FPS * LOOP_SECONDS;
    float phase = 6.28318530718 * float(frame % period) / float(period);
    vec2 orbit = vec2(cos(phase), sin(phase));

    // Domain-warped smoke drifting on a closed orbit.
    vec2 warp = vec2(fbm(p + 1.6 * orbit), fbm(p + vec2(5.2, 1.3) - 1.6 * orbit.yx));
    float smoke = fbm(p + 1.8 * warp + 0.9 * orbit);

    float rise = smoothstep(0.15, 1.05, uv.y);             // light gathers toward the bottom edge
    float barGuard = smoothstep(0.06, 0.22, uv.y);         // nothing lit behind the bar
    float ember = smoothstep(0.42, 0.95, smoke) * rise * barGuard;

    vec3 color = CRIMSON * (PEAK * ember + 0.05 * pow(rise, 3.0) * barGuard);
    color *= step(3.0 / 255.0, max(color.r, max(color.g, color.b)));   // OLED: sub-3/255 pixels fully off
    return vec4(color, 1.0);
}
