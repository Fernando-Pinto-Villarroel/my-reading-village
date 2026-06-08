#import "@preview/minimal-presentation:0.7.0": *

#let pink = rgb("#FFB3BA")
#let lavender = rgb("#B5B3FF")
#let mint = rgb("#B3FFD9")
#let cream = rgb("#FFF8F0")
#let darkText = rgb("#4A4A4A")
#let darkPink = rgb("#E8637A")
#let darkLavender = rgb("#7B79E8")
#let darkMint = rgb("#2E9E6B")
#let peach = rgb("#FFDFC4")

#let cbox(fill: cream, body) = block(
  width: 100%,
  fill: fill,
  inset: 11pt,
  radius: 6pt,
  body,
)

#let tag(body, fill: darkPink) = box(
  fill: fill,
  inset: (x: 8pt, y: 4pt),
  radius: 20pt,
  text(fill: white, size: 12pt, weight: "semibold", body),
)

#show: project.with(
  title: "My Reading Village",
  sub-title: "Lab 3 - Actividad 1 - Presentación y Crítica de Startup Lean",
  author: "Fernando Pinto Villarroel",
  date: "17 de mayo de 2026",
  index-title: "Contenido",
  logo: image("./images/logo.png"),
  logo-light: image("./images/logo.png"),
  cover: image("./images/logo.png"),
  main-color: darkPink,
  lang: "es",
)

#show heading.where(level: 2): it => {
  section-page.update(_ => false)
  pagebreak()
  place(
    top + left,
    dy: -3.3cm,
    block(
      height: 3.3cm,
      width: 100% - 3cm,
      align(horizon, text(size: 38pt, weight: "regular", it.body)),
    ),
  )
}

// ─── PROBLEMA ────────────────────────────────────────────────────────────────

= El Problema

== El punto de dolor del cliente

#columns-content()[
  #cbox(fill: darkPink)[
    #set text(fill: white, size: 15pt, weight: "bold")
    #set align(center)
    ¿Cuál es el problema real?
  ]

  #v(8pt)
  #set text(size: 13pt)

  Los adolescentes, universitarios y adultos jóvenes *quieren o necesitan leer más*, pero la lectura compite con el entretenimiento pasivo: redes sociales, streaming, videojuegos.

  #v(8pt)

  #cbox(fill: pink)[
    #set text(size: 13pt)
    *La lectura carece del bucle de retroalimentación inmediata* que sí tienen las apps de entretenimiento. No hay recompensas visibles, no hay progresión, no hay razón para volver mañana. @eyal-hooked
  ]

  #v(8pt)
  #cbox(fill: lavender)[
    #set text(size: 12pt)
    #text(weight: "bold")[Dato clave:] Según estudios de hábitos digitales, el lector promedio abandona un libro antes del capítulo 3 por falta de motivación sostenida. @nea-reading @freddy-vega-reading
  ]
][
  #v(6pt)
  #grid(
    rows: (auto, auto, auto),
    gutter: 10pt,
    cbox(fill: cream)[
      #text(fill: darkPink, size: 14pt, weight: "bold")[😩 Frustración]
      #v(4pt)
      #set text(size: 12pt)
      "Compré el libro, lo empecé, y nunca lo terminé."
    ],
    cbox(fill: cream)[
      #text(fill: darkLavender, size: 14pt, weight: "bold")[📉 Abandono]
      #v(4pt)
      #set text(size: 12pt)
      La constancia cae a la semana 2. No hay ningún estímulo externo para continuar.
    ],
    cbox(fill: cream)[
      #text(fill: darkMint, size: 14pt, weight: "bold")[🔄 Sustitución]
      #v(4pt)
      #set text(size: 12pt)
      El tiempo de lectura es reemplazado por TikTok o Netflix, que sí ofrecen dopamina inmediata.
    ],
  )
]

// ─── SOLUCIÓN ─────────────────────────────────────────────────────────────────

= La Solución

== Concepto del MVP: gamificar la lectura real

#columns-content()[
  #set text(size: 13pt)

  *My Reading Village* es una app móvil que transforma el acto de leer en un juego de construcción de aldeas.

  #v(8pt)
  El usuario registra páginas leídas de cualquier libro físico o digital. Esas páginas se convierten en recursos: monedas, madera, gemas. Con esos recursos construye edificios en una aldea que crece y cobra vida.

  #v(8pt)
  #cbox(fill: darkPink)[
    #set text(fill: white, size: 13pt)
    *Hipótesis central:* Si la lectura produce recompensas visuales e inmediatas, el usuario construye el hábito sin esfuerzo de voluntad. @duhigg-habit @kapp-gamification
  ]
][
  #cbox(fill: darkText)[
    #set text(fill: white, size: 12pt, weight: "bold")
    #set align(center)
    Bucle Principal (Game Loop)
  ]
  #v(4pt)
  #stack(dir: ttb, spacing: 8pt,
    cbox(fill: pink)[
      #set align(center)
      #set text(size: 12pt)
      *1. Leer* páginas reales\
      (cualquier libro)
    ],
    align(center, text(fill: darkPink, size: 16pt)[↓]),
    cbox(fill: lavender)[
      #set align(center)
      #set text(size: 12pt)
      *2. Ganar* recursos\
      monedas · madera · gemas
    ],
    align(center, text(fill: darkPink, size: 16pt)[↓]),
    cbox(fill: mint)[
      #set align(center)
      #set text(size: 12pt)
      *3. Construir* edificios\
      en la aldea del jugador
    ],
    align(center, text(fill: darkPink, size: 16pt)[↓]),
    cbox(fill: peach)[
      #set align(center)
      #set text(size: 12pt)
      *4. Aldea crece* y anima\
      → motivación para volver
    ],
  )
]

== Características clave del MVP

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 12pt,
  cbox(fill: pink)[
    #text(fill: darkPink, size: 14pt, weight: "bold")[📚 Registro de lectura]
    #v(6pt)
    #set text(size: 12pt)
    El usuario abre un libro en la app, registra las páginas leídas y el tiempo invertido. Funciona con cualquier libro físico o digital.
  ],
  cbox(fill: lavender)[
    #text(fill: darkLavender, size: 14pt, weight: "bold")[🏗️ Construcción de aldea]
    #v(6pt)
    #set text(size: 12pt)
    Los recursos ganados se gastan en construir casas, torres, mercados. La aldea es visible, personalizable y crece con el tiempo.
  ],
  cbox(fill: mint)[
    #text(fill: darkMint, size: 14pt, weight: "bold")[🎯 Misiones y XP]
    #v(6pt)
    #set text(size: 12pt)
    Metas alcanzables: "leer 100 páginas", "construir 3 casas". Cada misión completada otorga XP y desbloquea contenido nuevo.
  ],
)

#v(10pt)

#grid(
  columns: (1fr, 1fr),
  gutter: 12pt,
  cbox(fill: cream)[
    #set text(size: 12pt)
    #text(weight: "bold")[🎰 Rueda de la suerte]
    #v(4pt)
    Minijuego diario: una ruleta que puede dar recursos extra, potenciadores o gemas. Crea el hábito de abrir la app cada día.
  ],
  cbox(fill: cream)[
    #set text(size: 12pt)
    #text(weight: "bold")[📶 100% offline]
    #v(4pt)
    Todos los datos se guardan localmente en SQLite. No requiere cuenta ni internet. Privacidad total del usuario.
  ],
)

== Pantallas principales de la aplicación

#grid(
  columns: (1fr, 1fr),
  gutter: 20pt,
  align(center)[
    #image("./images/startup-image-1.png")
  ],
  align(center)[
    #image("./images/startup-image-2.jpeg")
  ],
)

// ─── SEGMENTO DE CLIENTE ──────────────────────────────────────────────────────

= Segmento de Cliente

== Cliente objetivo

#columns-content()[
  #set text(size: 13pt)

  #cbox(fill: darkPink)[
    #set text(fill: white, size: 14pt, weight: "bold")
    #set align(center)
    Early Adopter Principal
  ]
  #v(6pt)
  #text(size: 14pt, weight: "bold")[Adolescentes, universitarios y adultos jóvenes (12-35 años)]

  #v(6pt)
  Personas que:
  - *Quieren o necesitan leer más* pero no logran mantener el hábito
  - Ya usan apps de gaming casual o productividad (Duolingo, Habitica, Clash of Clans)
  - Tienen familiaridad con smartphones y apps freemium
  - En etapa lectora activa (escolar/universitaria) 

  #v(8pt)
  #cbox(fill: mint)[
    #set text(size: 12pt)
    *Por qué este segmento:* Desde los 12 años, los usuarios ya tienen hábitos de gaming y responden fuerte a loops de recompensa. La brecha entre "querer leer" y "leer de verdad" es igual de alta en adolescentes que en adultos jóvenes.
  ]
][
  #v(4pt)
  #cbox(fill: cream)[
    #set text(size: 12pt)
    #text(weight: "bold", fill: darkPink)[Perfil de usuario]
    #v(6pt)
    #table(
      columns: (auto, 1fr),
      inset: (x: 7pt, y: 6pt),
      stroke: luma(220),
      fill: (_, row) => if row == 0 { pink } else if calc.odd(row) { cream } else { white },
      [*Atributo*], [*Descripción*],
      [Edad], [12 - 35 años],
      [Plataforma], [Android (primero), iOS (futuro)],
      [Motivación], [Hábitos, crecimiento personal],
      [Referencia], [Duolingo, Habitica, Clash of Clans],
      [Barrera], [Tiempo, distracción digital],
      [Disposición a pagar], [Baja-media (modelo freemium)],
    )
  ]
]

// ─── SUPOSICIONES CLAVE ───────────────────────────────────────────────────────

= Suposiciones Clave

== Hipótesis que necesitamos validar

#grid(
  columns: (1fr, 1fr),
  gutter: 12pt,
  cbox(fill: pink)[
    #text(fill: darkPink, size: 14pt, weight: "bold")[🔴 Suposición crítica #1]
    #v(6pt)
    #set text(size: 12pt)
    *"Las recompensas de juego motivan al usuario a leer más páginas por día."*
    #v(6pt)
    #text(fill: luma(100), size: 11pt)[Riesgo alto: si la recompensa no se percibe como valiosa, el loop no funciona. Requiere prueba con usuarios reales en 2 semanas.]
  ],
  cbox(fill: lavender)[
    #text(fill: darkLavender, size: 14pt, weight: "bold")[🟡 Suposición crítica #2]
    #v(6pt)
    #set text(size: 12pt)
    *"El usuario acepta registrar manualmente sus páginas leídas cada día."*
    #v(6pt)
    #text(fill: luma(100), size: 11pt)[Riesgo medio: la fricción del registro manual podría hacer que el usuario abandone. Posible solución: flujo ultra rápido en menos de 10 segundos.]
  ],
  cbox(fill: mint)[
    #text(fill: darkMint, size: 14pt, weight: "bold")[🟢 Suposición secundaria #3]
    #v(6pt)
    #set text(size: 12pt)
    *"El modelo freemium (anuncios opcionales + compras) genera ingresos suficientes."*
    #v(6pt)
    #text(fill: luma(100), size: 11pt)[Riesgo bajo-medio: ya validado por apps similares (Duolingo). Requiere base de usuarios activos ≥ 10 k MAU para monetización significativa.]
  ],
  cbox(fill: peach)[
    #text(fill: darkPink, size: 14pt, weight: "bold")[🟠 Suposición de canal #4]
    #v(6pt)
    #set text(size: 12pt)
    *"La distribución orgánica via Play Store y comunidades (Reddit, Discord) es suficiente para los primeros 1.000 usuarios."*
    #v(6pt)
    #text(fill: luma(100), size: 11pt)[Riesgo medio: CAC orgánico bajo pero lento. Pivote posible: micro-influencers de libros en TikTok e Instagram.]
  ],
)

// ─── MÉTRICA DE ÉXITO ─────────────────────────────────────────────────────────

= Métrica de Éxito

== La única métrica que importa ahora

#columns-content()[
  #set text(size: 13pt)

  En metodología Lean Startup, en etapa de validación se elige *una métrica norte* (North Star Metric) que refleje si el producto está entregando valor real. @ries-lean-startup

  #v(10pt)
  #cbox(fill: darkPink)[
    #set text(fill: white, size: 15pt, weight: "bold")
    #set align(center)
    North Star Metric
    #v(6pt)
    #set text(size: 18pt)
    Páginas leídas / usuario activo / semana
  ]

  #v(10pt)
  *¿Por qué esta métrica?*
  - Mide *comportamiento real* (lectura), no uso de la app
  - Es un *leading indicator* de retención a largo plazo
  - Si sube → la app cumple su promesa de valor
  - Si no sube → el loop de gamificación no está funcionando

  #v(6pt)
  #cbox(fill: lavender)[
    #set text(size: 12pt)
    *Meta inicial (semana 8 post-lanzamiento):* ≥ 80 páginas/usuario activo/semana (equivale a \~1 libro al mes).
  ]
][
  #v(6pt)
  #grid(
    rows: (auto, auto, auto),
    gutter: 8pt,
    cbox(fill: cream)[
      #text(fill: darkPink, weight: "bold")[📊 Métricas de apoyo]
      #v(4pt)
      #set text(size: 12pt)
      - *DAU / MAU ratio* ≥ 30 % → mide hábito diario
      - *Retención día 7* ≥ 40 % → mide enganche inicial
      - *Sesiones por día* → frecuencia de apertura
    ],
    cbox(fill: cream)[
      #text(fill: darkLavender, weight: "bold")[🚫 Métricas vanidad (ignorar ahora)]
      #v(4pt)
      #set text(size: 12pt)
      - Descargas totales (no indican valor)
      - Reseñas en Play Store (sesgo positivo)
      - Impresiones de anuncios (no es la etapa)
    ],
    cbox(fill: pink)[
      #text(fill: darkPink, weight: "bold")[🔬 Método de medición]
      #v(4pt)
      #set text(size: 12pt)
      SQLite local → exportar CSV anónimo opt-in → análisis semanal manual en los primeros 50 usuarios beta.
    ],
  )
]

== Ejemplo: ¿cómo se vería el éxito?

#cbox(fill: darkText)[
  #set text(fill: white, size: 11pt, weight: "bold")
  #set align(center)
  Dashboard hipotético - Semana 1 vs Semana 8 (grupo inicial de 50 usuarios beta)
]

#v(5pt)

#set text(size: 10pt)
#table(
  columns: (1fr, 1fr, 1fr, 1fr),
  inset: (x: 7pt, y: 6pt),
  stroke: luma(220),
  fill: (_, row) =>
    if row == 0 { darkPink }
    else if calc.odd(row) { cream }
    else { white },
  table.header(
    text(fill: white)[*Métrica*],
    text(fill: white)[*Semana 1*],
    text(fill: white)[*Semana 8 (meta)*],
    text(fill: white)[*Señal*],
  ),
  [Páginas / usuario / semana],
  [12 pág],
  [≥ 80 pág],
  [✅ Loop funciona],

  [Retención día 7],
  [18 %],
  [≥ 40 %],
  [✅ Hábito formado],

  [DAU / MAU],
  [10 %],
  [≥ 30 %],
  [✅ Uso diario real],

  [Sesiones / usuario / día],
  [0.4],
  [≥ 1.2],
  [✅ Apertura habitual],

  [Libros terminados (grupo inicial)],
  [0],
  [≥ 8 libros],
  [✅ Promesa entregada],
)

#v(6pt)

#grid(
  columns: (1fr, 1fr),
  gutter: 8pt,
  cbox(fill: mint)[
    #set text(size: 10pt)
    #text(weight: "bold", fill: darkMint)[Si las métricas suben →]
    #v(3pt)
    Validar el MVP, iniciar iteración de features: social (amigos), nuevos edificios, retos de lectura grupales. Preparar lanzamiento público.
  ],
  cbox(fill: pink)[
    #set text(size: 10pt)
    #text(weight: "bold", fill: darkLavender)[Si las métricas no suben →]
    #v(3pt)
    Pivotar: entrevistar a los 50 usuarios, identificar fricción, reducir pasos de registro, o cambiar el tipo de recompensa in-game. No escalar antes de validar.
  ],
)

// ─── CONCLUSIONES ──────────────────────────────────────────────────────────────────

= Conclusiones

== Conclusiones

#cbox(fill: pink)[
  #set align(center)
  #set text(size: 16pt)
  *My Reading Village - Startup Lean*
  #v(8pt)
  *Problema:* falta de hábito lector\
  *Solución:* gamificación real de la lectura\
  *Segmento:* adolescentes y adultos jóvenes 12–35\
  *MVP:* app móvil Flutter offline-first\
  *Métrica norte:* páginas leídas / usuario activo / semana

  #v(10pt)
  #text(size: 14pt, weight: "light")[
    Lab 3 - Actividad 1 - 17 de mayo de 2026\
    Fernando Pinto Villarroel
  ]
]

// ─── REFERENCIAS ─────────────────────────────────────────────────────────────

= Bibliografía 

#text(size: 14pt, weight: "light")[
  #bibliography("bibliography.yaml")
]
