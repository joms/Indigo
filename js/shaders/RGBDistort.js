THREE.RGBDistortShader = {
    uniforms: {
        "tDiffuse": {type: "t", value:null},
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

            "gl_FragColor = color;",
        "}"
    ].join("\n")
};