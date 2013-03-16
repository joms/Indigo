THREE.RGBDistortShader = {
    uniforms: {
<<<<<<< HEAD
        "tDiffuse": {type: "t", value:null},
        "amount": {type: "f", value: 0.},
        "angle": {type: "f", value: 0.}
=======
        // General uniforms
        "tDiffuse": {type: "t", value: null},
        "time": {type: "f", value:.0},

        // Uniforms for distorting colors
        "rgbAmt": {type: "f", value:.005},
        "rgbAng": {type: "f", value:1.}
>>>>>>> distort
    },

    vertexShader: [
        "varying vec2 vUv;",
<<<<<<< HEAD
        "void main() {",
=======
        "void main() ",
        "{",
>>>>>>> distort
            "vUv = uv;",
            "gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);",
        "}"
    ].join("\n"),

    fragmentShader: [
        "uniform sampler2D tDiffuse;",
<<<<<<< HEAD
        "uniform float amount;",
        "uniform float angle;",

        "varying vec2 vUv;",

        "void main() {",
            "vec2 offset = amount * vec2(cos(angle), sin(angle));",
            "vec4 cr = texture2D(tDiffuse, vUv + offset);",
            "vec4 cga = texture2D(tDiffuse, vUv);",
            "vec4 cb = texture2D(tDiffuse, vUv - offset);",
            "gl_FragColor = vec4(cr.r, cga.g, cb.b, cga.a);",
=======
        "uniform float time;",
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
>>>>>>> distort
        "}"
    ].join("\n")
};