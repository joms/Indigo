THREE.OverlayShader = {
    uniforms: {
        "tDiffuse": { type: "t", value: null },
        "time": { type: "f", value: 0.0 },
        "nIntensity": { type: "f", value: 0.2 },
        "sIntensity": { type: "f", value: 0.4 },
        "sCount": { type: "f", value: 1000 },

        "offset":   { type: "f", value: 1.0 },
        "darkness": { type: "f", value: 1.0 }
    },

    vertexShader: [
        "varying vec2 vUv;",
        "void main() {",
            "vUv = uv;",
            "gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);",
        "}"
    ].join("\n"),

    fragmentShader: [
        "uniform float time;",
        "uniform float nIntensity;", // noise effect intensity value (0 = no effect, 1 = full effect)
        "uniform float sIntensity;", // scanlines effect intensity value (0 = no effect, 1 = full effect)
        "uniform float sCount;", // scanlines effect count value (0 = no effect, 4096 = full effect)

        "uniform float offset;",
        "uniform float darkness;",

        "uniform sampler2D tDiffuse;",
        "varying vec2 vUv;",

        "void main() {",
            "vec4 color = texture2D(tDiffuse, vUv);",

            // Make some noise
            "float x = vUv.x * vUv.y * time *  1000.0;",
            "x = mod(x, 13.0) * mod(x, 123.0);",
            "float dx = mod(x, 0.01);",
            "vec3 cResult = color.rgb + color.rgb * clamp(0.1 + dx * 100.0, 0.0, 1.0);",

            // Make some scanlines
            "vec2 sc = vec2(sin(vUv.y * sCount), cos(vUv.y * sCount));",
            "cResult += color.rgb * vec3(sc.x, sc.y, sc.x)* sIntensity;",
            "cResult = color.rgb + clamp(nIntensity, 0.0,1.0) * (cResult - color.rgb);",

            // Vignette effect
            "float dist = distance( vUv, vec2( 0.5 ) );",
            "cResult.rgb *= smoothstep( 2., offset * 0.799, dist *( darkness + offset ) );",

            "gl_FragColor =  vec4(cResult, color.a);",
        "}"
    ].join("\n")
}