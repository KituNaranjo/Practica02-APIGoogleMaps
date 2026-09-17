workspace "LogiTech - Sistema de Ruteo de Última Milla" "Modelo C4 aplicando patrones de resiliencia (Circuit Breaker, Cache-Aside, Fallback, Retry Queue) sobre el consumo de Google Maps Platform" {

    model {
        cliente = person "Cliente" "Solicita entregas de última milla y consulta su estado"
        repartidor = person "Repartidor" "Ejecuta las rutas de entrega asignadas"

        googleMaps = softwareSystem "Google Maps Platform" "Geocoding API y Distance Matrix API" "External"
        openStreetMap = softwareSystem "OpenStreetMap" "Proveedor de respaldo (Nominatim + OSRM)" "External"

        logitech = softwareSystem "Sistema LogiTech" "Optimiza rutas de entrega de última milla para reducir costos de combustible" {

            mobileApp = container "App Móvil del Repartidor" "Muestra rutas optimizadas al repartidor" "React Native" "Mobile"
            webApp = container "Portal Web de Administración" "Gestión de entregas y flota" "React"
            gateway = container "API Gateway / BFF" "Enruta y autentica peticiones" "Spring Cloud Gateway"

            routing = container "Servicio de Ruteo y Geocodificación" "Aplica Circuit Breaker, Cache-Aside y Fallback" "Spring Boot" {

                geocodingController = component "Geocoding Controller" "Expone el endpoint de geocodificación" "REST Controller"
                distanceController = component "Distance Matrix Controller" "Expone el endpoint de cálculo de distancia" "REST Controller"
                cacheManager = component "Cache Manager" "Implementa el patrón Cache-Aside" "Component"
                circuitBreaker = component "Circuit Breaker" "Controla fallos hacia proveedores externos" "Resilience4j"
                providerInterface = component "Geocoding Provider Interface" "Abstracción tipo Strategy / Adapter" "Interface"
                gmapsAdapter = component "Google Maps Client Adapter" "Implementación primaria (Google Maps)" "Adapter"
                osmAdapter = component "OpenStreetMap Client Adapter" "Implementación de respaldo (Fallback)" "Adapter"
                retryPublisher = component "Retry Queue Publisher" "Publica mensajes de reintento" "Component"

                geocodingController -> cacheManager "Consulta"
                distanceController -> cacheManager "Consulta"
                cacheManager -> circuitBreaker "Invoca si no hay caché"
                circuitBreaker -> providerInterface "Invoca"
                providerInterface -> gmapsAdapter "Implementación primaria"
                providerInterface -> osmAdapter "Implementación de respaldo"
                circuitBreaker -> retryPublisher "Publica en caso de fallo"
            }

            cache = container "Caché de Direcciones y Rutas" "Cache-Aside de resultados geocodificados" "Redis" "Database"
            queue = container "Cola de Reintentos" "Reprocesa peticiones fallidas tras una caída" "RabbitMQ" "Queue"
            database = container "Base de Datos de Entregas" "Persiste entregas, rutas y estados" "PostgreSQL" "Database"

            cliente -> webApp "Usa" "HTTPS"
            repartidor -> mobileApp "Usa" "HTTPS"
            mobileApp -> gateway "Solicita rutas" "HTTPS/JSON"
            webApp -> gateway "Gestiona entregas" "HTTPS/JSON"
            gateway -> routing "Enruta" "HTTPS/JSON"
            routing -> cache "Lee / Escribe" "Redis Protocol"
            routing -> queue "Encola fallos" "AMQP"
            queue -> routing "Reprocesa" "AMQP"
            routing -> database "Persiste" "JDBC"
        }

        gmapsAdapter -> googleMaps "Llama" "HTTPS/JSON"
        osmAdapter -> openStreetMap "Llama" "HTTPS/JSON"
        routing -> googleMaps "Consume vía Circuit Breaker" "HTTPS/JSON"
        routing -> openStreetMap "Fallback si el circuito está abierto" "HTTPS/JSON"
    }

    views {
        systemContext logitech "DiagramaContexto" {
            include *
            autoLayout lr
            title "Diagrama de Contexto del Sistema - LogiTech"
            description "Nivel 1 C4: Sistema LogiTech y sus dependencias externas (Google Maps Platform, OpenStreetMap)."
        }

        container logitech "DiagramaContenedores" {
            include *
            autoLayout lr
            title "Diagrama de Contenedores - Sistema LogiTech"
            description "Nivel 2 C4: contenedores internos de LogiTech y su relación con Google Maps Platform / OpenStreetMap."
        }

        component routing "DiagramaComponentes" {
            include *
            autoLayout lr
            title "Diagrama de Componentes - Servicio de Ruteo y Geocodificación"
            description "Nivel 3 C4: aplicación de los patrones Strategy/Adapter, Circuit Breaker, Cache-Aside y Retry Queue."
        }

        styles {
            element "Person" {
                shape person
                background #08427b
                color #ffffff
            }
            element "Software System" {
                background #1168bd
                color #ffffff
            }
            element "External" {
                background #999999
                color #ffffff
            }
            element "Container" {
                background #438dd5
                color #ffffff
            }
            element "Database" {
                shape cylinder
            }
            element "Queue" {
                shape pipe
            }
            element "Mobile" {
                shape mobileDevicePortrait
            }
            element "Component" {
                background #85bbf0
                color #000000
            }
        }
    }
}
