THREE.DistortShader = {
    uniforms: {
        "tDiffuse": {type: "t", value: null},
        "time": {type: "f", value:.0},

        "rgbAmt": {type: "f", value:.005},
        "rgbAng": {type: "f", value:1.}
    },

    vertexShader: [
        "varying vec2 vUv;",
        "void main() ",
        "{",
            "vUv = uv;",
            "gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);",
        "}"
    ].join("\n"),

    fragmentShader: [
        "uniform float time;",
        "uniform sampler2D tDiffuse;",
        "uniform float rgbAmt;",
        "uniform float rgbAng;",
        "varying vec2 vUv;",

        "void main()",
        "{",
            "vec4 color = texture2D(tDiffuse, vUv);",

            // Distort the shit out of that r and b!
            "vec2 offset = rgbAmt * vec2(cos(rgbAng), sin(rgbAng));",
            "vec4 cr = texture2D(tDiffuse, vUv + offset);",
            "vec4 cga = texture2D(tDiffuse, vUv);",
            "vec4 cb = texture2D(tDiffuse, vUv - offset);",
            "color.r = cr.r; color.g = cga.g; color.b = cb.b; color.a = cga.a;",

            // Make some noise!
            "float x = vUv.x * vUv.y * time *  1000.;",
            "x = mod(x, 13.) * mod(x, 123.);",
            "float dx = mod(x, .01);",
            "vec3 noise = color.rgb + color.rgb * clamp(.1 + dx * 100., 0., 1.);",
            "color.rgb = noise;",

            "gl_FragColor = color;",
        "}"
    ].join("\n")
};