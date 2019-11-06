uniform vec2 iResolution;

uniform float scale;
uniform float iterations;
uniform vec2 transl;
uniform dvec2 trap;

uniform float contrast;
uniform vec2 g1;
uniform vec2 g2;

vec2 map(vec2 value, vec2 inMin, vec2 inMax, vec2 outMin, vec2 outMax) {
  return outMin + (outMax - outMin) * (value - inMin) / (inMax - inMin);
}

//https://github.com/hughsk/glsl-hsv2rgb/blob/master/index.glsl
vec3 hsv2rgb(vec3 c) {
  vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
  vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
  return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

dvec2 multComplex(dvec2 p1, dvec2 p2) {
    return dvec2(p1.x * p2.x - p1.y * p2.y, p1.x * p2.y + p1.y * p2.x);
}

vec3 iterate(dvec2 c) {
    float minPointTrap = 100000000;
    
    float bailout = 2.0;
    dvec2 z = vec2(0);
    float i = 0.0;
    
    for(; i < iterations; i++) {
        z = multComplex(z, z) + c;
        if(length(z) > bailout) {
            break;
        }
	
	double pointTrap = length(z - trap);
	if(pointTrap < minPointTrap) {
	    minPointTrap = float(pointTrap);
	}
    }
    
    float value = i/iterations;
    vec2 gradient = map(min(vec2(minPointTrap*contrast), 1.0), vec2(0.0), vec2(1.0), g1, g2);
    
    return hsv2rgb(vec3(gradient, value));
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
    dvec2 c = (fragCoord - iResolution.xy/2.0)/iResolution.x;
    
    c *= dvec2(scale);
    c += dvec2(transl);
    
    fragColor = vec4(iterate(c), 1.0);
}

void main() {
	mainImage(gl_FragColor, gl_FragCoord.xy);
}
