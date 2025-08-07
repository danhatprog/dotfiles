// How straight the terminal is in each axis
// inverse quadratic (x, y > 0)
#define CURVE 12.0, 10.0

// How far apart the different colors are from each other
// linear (-Inf < x < Inf)
#define COLOR_FRINGING_SPREAD 0.8

// How much the ghost images are spread out
// linear (x >= 0)
#define GHOSTING_SPREAD 0.075
// How visible ghost images are
// linear (x >= 0)
#define GHOSTING_STRENGTH 1.5

// How much of the non-linearly darkened colors are mixed in
// [0, 1]
#define DARKEN_MIX 0.45

// How far in the vignette spreads
// linear (x >= 0)
#define VIGNETTE_SPREAD 0.12
// How bright the vignette is
// linear (x >= 0)
#define VIGNETTE_BRIGHTNESS 7.2

// Tint all colors
// [0, 1] ^ 3
#define TINT 0.97, 0.91, 1.0

// How visible the scan line effect is
// [0, 1]
#define SCAN_LINES_STRENGTH 0.35
// How bright the spaces between the lines are
// [0, 1]
#define SCAN_LINES_VARIANCE 0.45
// Pixels per scan line effect
// linear (x > 0)
#define SCAN_LINES_PERIOD 3.0

// How visible the aperture grille is
// linear (x >= 0)
#define APERTURE_GRILLE_STRENGTH 0.4
// Pixels per aperture grille
// linear (x > 0)
#define APERTURE_GRILLE_PERIOD 2

// How much the screen flickers
// linear (x >= 0)
#define FLICKER_STRENGTH 0.55
// How fast the screen flickers
// linear (x > 0)
#define FLICKER_FREQUENCY 16

// How much noise is added to filled areas
// [0, 1]
#define NOISE_CONTENT_STRENGTH 0.25
// How much noise is added everywhere
// [0, 1]
#define NOISE_UNIFORM_STRENGTH 0.015

// How big the bloom is
// linear (x >= 0)
#define BLOOM_SPREAD 1.05
// How visible the bloom is
// [0, 1]
#define BLOOM_STRENGTH 0.06

// How fast colors fade in and out
// [0, 1]
#define FADE_FACTOR 0.5

// Constants
#define PI 3.1415926535897932384626433832795

#ifdef BLOOM_SPREAD
// Golden spiral samples used for bloom.
//   [x, y, weight] weight is inverse of distance.
const vec3[24] bloom_samples = {
        vec3(0.1693761725038636, 0.9855514761735895, 1),
        vec3(-1.333070830962943, 0.4721463328627773, 0.7071067811865475),
        vec3(-0.8464394909806497, -1.51113870578065, 0.5773502691896258),
        vec3(1.554155680728463, -1.2588090085709776, 0.5),
        vec3(1.681364377589461, 1.4741145918052656, 0.4472135954999579),
        vec3(-1.2795157692199817, 2.088741103228784, 0.4082482904638631),
        vec3(-2.4575847530631187, -0.9799373355024756, 0.3779644730092272),
        vec3(0.5874641440200847, -2.7667464429345077, 0.35355339059327373),
        vec3(2.997715703369726, 0.11704939884745152, 0.3333333333333333),
        vec3(0.41360842451688395, 3.1351121305574803, 0.31622776601683794),
        vec3(-3.167149933769243, 0.9844599011770256, 0.30151134457776363),
        vec3(-1.5736713846521535, -3.0860263079123245, 0.2886751345948129),
        vec3(2.888202648340422, -2.1583061557896213, 0.2773500981126146),
        vec3(2.7150778983300325, 2.5745586041105715, 0.2672612419124244),
        vec3(-2.1504069972377464, 3.2211410627650165, 0.2581988897471611),
        vec3(-3.6548858794907493, -1.6253643308191343, 0.25),
        vec3(1.0130775986052671, -3.9967078676335834, 0.24253562503633297),
        vec3(4.229723673607257, 0.33081361055181563, 0.23570226039551587),
        vec3(0.40107790291173834, 4.340407413572593, 0.22941573387056174),
        vec3(-4.319124570236028, 1.159811599693438, 0.22360679774997896),
        vec3(-1.9209044802827355, -4.160543952132907, 0.2182178902359924),
        vec3(3.8639122286635708, -2.6589814382925123, 0.21320071635561041),
        vec3(3.3486228404946234, 3.4331800232609, 0.20851441405707477),
        vec3(-2.8769733643574344, 3.9652268864187157, 0.20412414523193154)
    };
#endif

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    // Get texture coordinates
    vec2 uv = fragCoord.xy / iResolution.xy;

    #ifdef CURVE
    // Curve texture coordinates to mimic non-flat CRT monior
    uv = (uv - 0.5) * 2.0;
    uv.xy *= 1.0 + pow((abs(vec2(uv.y, uv.x)) / vec2(CURVE)), vec2(2.0));
    uv = (uv / 2.0) + 0.5;
    #endif

    // Retrieve colors from appropriate locations
    fragColor.r = texture(iChannel0, vec2(uv.x + 0.0003 * COLOR_FRINGING_SPREAD, uv.y + 0.0003 * COLOR_FRINGING_SPREAD)).x;
    fragColor.g = texture(iChannel0, vec2(uv.x + 0.0000 * COLOR_FRINGING_SPREAD, uv.y - 0.0006 * COLOR_FRINGING_SPREAD)).y;
    fragColor.b = texture(iChannel0, vec2(uv.x - 0.0006 * COLOR_FRINGING_SPREAD, uv.y + 0.0000 * COLOR_FRINGING_SPREAD)).z;
    fragColor.a = texture(iChannel0, uv).a;

    // Add faint ghost images
    fragColor.r += 0.04 * GHOSTING_STRENGTH * texture(iChannel0, GHOSTING_SPREAD * vec2(+0.025, -0.027) + uv.xy).x;
    fragColor.g += 0.02 * GHOSTING_STRENGTH * texture(iChannel0, GHOSTING_SPREAD * vec2(-0.022, -0.020) + uv.xy).y;
    fragColor.b += 0.04 * GHOSTING_STRENGTH * texture(iChannel0, GHOSTING_SPREAD * vec2(-0.020, -0.018) + uv.xy).z;

    // Quadratically darken everything
    fragColor.rgb = mix(fragColor.rgb, fragColor.rgb * fragColor.rgb, DARKEN_MIX);

    // Vignette effect
    fragColor.rgb *= VIGNETTE_BRIGHTNESS * pow(uv.x * uv.y * (1.0 - uv.x) * (1.0 - uv.y), VIGNETTE_SPREAD);

    // Tint all colors
    fragColor.rgb *= vec3(TINT);

    // NOTE: At this point, RGB values may be above 1

    // Add scan lines effect
    fragColor.rgb *= mix(
            1.0,
            SCAN_LINES_VARIANCE / 2.0 * (1.0 + sin(2 * PI * uv.y * iResolution.y / SCAN_LINES_PERIOD)),
            SCAN_LINES_STRENGTH
        );

    // Add aperture grille
    int aperture_grille_step = int(8 * mod(fragCoord.x, APERTURE_GRILLE_PERIOD) / APERTURE_GRILLE_PERIOD);
    float aperture_grille_mask;

    if (aperture_grille_step < 3)
        aperture_grille_mask = 0.0;
    else if (aperture_grille_step < 4)
        aperture_grille_mask = mod(8 * fragCoord.x, APERTURE_GRILLE_PERIOD) / APERTURE_GRILLE_PERIOD;
    else if (aperture_grille_step < 7)
        aperture_grille_mask = 1.0;
    else if (aperture_grille_step < 8)
        aperture_grille_mask = mod(-8 * fragCoord.x, APERTURE_GRILLE_PERIOD) / APERTURE_GRILLE_PERIOD;

    fragColor.rgb *= 1.0 - APERTURE_GRILLE_STRENGTH * aperture_grille_mask;

    // Add flicker
    fragColor *= 1.0 - FLICKER_STRENGTH / 2.0 * (1.0 + sin(2 * PI * FLICKER_FREQUENCY * iTime));

    // Add noise
    // NOTE: Hard-coded noise distributions
    float noiseContent = smoothstep(0.4, 0.6, fract(sin(uv.x * uv.y * (1.0 - uv.x) * (1.0 - uv.y) * iTime * 4096.0) * 65536.0));
    float noiseUniform = smoothstep(0.4, 0.6, fract(sin(uv.x * uv.y * (1.0 - uv.x) * (1.0 - uv.y) * iTime * 8192.0) * 65536.0));
    fragColor.rgb *= clamp(noiseContent + 1.0 - NOISE_CONTENT_STRENGTH, 0.0, 1.0);
    fragColor.rgb = clamp(fragColor.rgb + noiseUniform * NOISE_UNIFORM_STRENGTH, 0.0, 1.0);

    // Remove output outside of screen bounds
    if (uv.x < 0.0 || uv.x > 1.0)
        fragColor.rgb *= 0.0;
    if (uv.y < 0.0 || uv.y > 1.0)
        fragColor.rgb *= 0.0;

    #ifdef BLOOM_SPREAD
    // Add bloom
    vec2 step = BLOOM_SPREAD * vec2(1.414) / iResolution.xy;

    for (int i = 0; i < 24; i++) {
        vec3 bloom_sample = bloom_samples[i];
        vec4 neighbor = texture(iChannel0, uv + bloom_sample.xy * step);
        float luminance = 0.299 * neighbor.r + 0.587 * neighbor.g + 0.114 * neighbor.b;

        fragColor += luminance * bloom_sample.z * neighbor * BLOOM_STRENGTH;
    }

    fragColor = clamp(fragColor, 0.0, 1.0);
    #endif

    // Add fade effect to smoothen out color transitions
    // NOTE: May need to be iTime/iTimeDelta dependent
    fragColor = vec4(FADE_FACTOR * fragColor.rgb, FADE_FACTOR);
}
