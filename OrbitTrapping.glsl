uniform vec2 iResolution;

uniform float scale;
uniform float iterations;
uniform vec2 transl;

dvec2 multComplex(dvec2 p1, dvec2 p2) {
    return dvec2(p1.x * p2.x - p1.y * p2.y, p1.x * p2.y + p1.y * p2.x);
}

vec4 iterate(dvec2 c) {
    float bailout = 2.0;
    dvec2 z = vec2(0);
    float i = 0.0;
    
    for(; i < iterations; i++) {
        z = multComplex(z, z) + c;
        if(length(z) > bailout) {
            break;
        }
    }
    
    float gray = i/iterations;
    
    return vec4(gray, gray, gray, 1.0);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
    dvec2 c = (dvec2(fragCoord) - dvec2(iResolution.xy)/2.0)/dvec2(iResolution.x);
    
    c *= dvec2(scale);
    c += dvec2(transl);
    
    fragColor = iterate(c);
}

void main() {
	mainImage(gl_FragColor,gl_FragCoord.xy);
}
