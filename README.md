# Práctica 02 - API Google Maps

**Maestría en Ingeniería de Software - Universidad Politécnica Salesiana**
**Asignatura:** Patrones de Diseño de APIs
**Docente:** Ing. Patsy Prieto, MSc.
**Estudiante:** Christian Naranjo
**Período Lectivo:** Septiembre 2026

## Descripción

Práctica de consumo, análisis arquitectónico y evaluación del impacto económico del uso de la **Geocoding API** y la **Distance Matrix API** de Google Maps Platform, en el contexto del caso de negocio de la startup logística "LogiTech".

Como complemento, se implementó una página web (`map.html`) que consume la **Maps Embed API** para mostrar un mapa interactivo y Street View de El Panecillo, sitio turístico de Quito.

## Contenido del repositorio

```
.
├── README.md
├── Informe_Practica02_GoogleMaps_ChristianNaranjo.docx   # Informe completo de la práctica
├── map.html                                               # Mapa y Street View de El Panecillo (Maps Embed API)
└── evidencias/                                            # Capturas de pantalla usadas como evidencia en el informe
    ├── 00_panecillo_mapa.png
    ├── 01_gcp_proyecto.png
    ├── 02_error_facturacion.png
    ├── 03_fondos_insuficientes.png
    ├── 04_geocoding_success.png
    ├── 05_geocoding_zero_results.png
    └── 06_distance_matrix_success.png
```

## Resumen técnico

- **Geocoding API**: conversión de la dirección del campus UPS más cercano (Av. Morán Valverde y Rumichaca, Quito) a coordenadas geográficas. Se documentó tanto el caso exitoso (`status: "OK"`) como el caso `ZERO_RESULTS`.
- **Distance Matrix API**: cálculo de distancia y tiempo estimado entre el centro de distribución y un punto de destino (`10.2 km`, `25 mins`, `mode: driving`).
- **Maps Embed API**: mapa y Street View interactivos de El Panecillo, Quito.
- Análisis de resiliencia (patrón Circuit Breaker + Fallback) y análisis financiero (costo operativo mensual y punto de equilibrio) incluidos en el informe.

## Cómo ejecutar `map.html`

1. Clona este repositorio.
2. Abre `map.html` con la extensión **Live Server** de VS Code (clic derecho > "Open with Live Server"), o cualquier servidor local.
3. No abrir directamente como `file://` en el navegador, ya que algunos entornos bloquean el iframe por políticas de carpeta confiable.
