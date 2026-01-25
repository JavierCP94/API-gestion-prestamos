# API REST para gestionar solicitudes de préstamos personales.

---

## 1. Instrucciones para Ejecutar el Proyecto

#### 1.1 Compilar el proyecto

```bash
cd c:\Users\javii\Desktop\DEV\Backend
mvn clean compile
```

#### 1.2 Construir el JAR ejecutable

```bash
mvn package -DskipTests
```

Esto genera: `target/loan-api-1.0.0.jar`

#### 1.3 Ejecutar la aplicación

```bash
java -jar target\loan-api-1.0.0.jar
```

Deberías ver:

```
Tomcat started on port(s): 8080 (http)
Started LoanApiApplication
```

#### 1.4 Verificar que funciona

Abre Postman e importa: `Loan-API-Postman-Collection.json`

O en PowerShell:

```powershell
Invoke-WebRequest -Uri "http://localhost:8080/loans" -Method GET
```

En mi caso, probé los endpoints HTTP con Postman para validar las peticiones y respuestas.

---

## 2. Arquitectura y Decisiones Técnicas

### 2.1 Arquitectura de Capas

```
Presentation Layer (LoanController)
    ↓
Business Logic Layer (LoanService)
    ↓
Data Layer (ConcurrentHashMap - en memoria)
```

### 2.2 Decisiones Técnicas Clave

#### **A. DTOs (Data Transfer Objects)**

- **Por qué**: Separar el modelo interno de la API
- **Ventaja**: Cambios en BD no afectan a clientes
- **Implementación**:
  - `CreateLoanRequestDto`: Recibir datos
  - `LoanResponseDto`: Enviar datos
  - `UpdateLoanStatusDto`: Actualizar estado

#### **B. Almacenamiento en Memoria**

- **Estructura**: `ConcurrentHashMap<Long, LoanRequest>`
- **Por qué**: Simplicidad, sin dependencias externas
- **Thread-safety**: `AtomicLong` para IDs incrementales
- **Nota**: En producción usaría JPA + PostgreSQL

#### **C. Manejo Centralizado de Excepciones**

- **Patrón**: `@RestControllerAdvice`
- **Ventaja**: Un único lugar para todos los errores
- **Traduce excepciones a HTTP**:
  - `LoanNotFoundException` → 404
  - `InvalidLoanStatusTransitionException` → 400
  - Validaciones → 400

#### **D. Validaciones en Dos Niveles**

1. **Cliente**: `@Valid` + anotaciones en DTOs

   ```java
   @NotBlank(message = "El nombre es obligatorio")
   private String nombreSolicitante;
   ```

2. **Servidor**: Lógica de transiciones en `LoanService`
   ```java
   if (!isValidTransition(fromStatus, toStatus)) {
       throw new InvalidLoanStatusTransitionException(...);
   }
   ```

#### **E. Transiciones de Estado Explícitas**

```
PENDIENTE → APROBADA | RECHAZADA
APROBADA → CANCELADA
RECHAZADA, CANCELADA → (sin transiciones)
```

Cualquier otra transición = HTTP 400

#### **F. Códigos HTTP Correctos**

- **201 Created**: POST exitoso
- **200 OK**: GET/PATCH exitoso
- **400 Bad Request**: Validación o lógica fallida
- **404 Not Found**: Recurso no existe

### 2.3 Estructura de Carpetas

```
src/main/java/com/loanmanagement/
├── LoanApiApplication.java
├── controller/
│   └── LoanController.java          (4 endpoints)
├── service/
│   └── LoanService.java             (lógica de negocio)
├── model/
│   ├── LoanRequest.java
│   └── LoanStatus.java              (enum)
├── dto/
│   ├── CreateLoanRequestDto.java
│   ├── UpdateLoanStatusDto.java
│   └── LoanResponseDto.java
└── exception/
    ├── LoanNotFoundException.java
    ├── InvalidLoanStatusTransitionException.java
    └── GlobalExceptionHandler.java  (manejo centralizado)
```

---

## 3. Posibles Mejoras y Extensiones Futuras

### 3.1 Mejoras Funcionales

#### **1. Base de Datos Persistente**

- Migrar de `ConcurrentHashMap` a **JPA + Hibernate**
- Usar **PostgreSQL** o **MySQL**
- Ventaja: Datos persistentes entre reinicios

#### **2. Paginación y Filtrado**

```
GET /loans?page=0&size=10&estado=PENDIENTE
```

- Usar `Page<LoanRequest>` de Spring Data
- Filtrar por estado, fecha, nombre, importe

#### **3. Búsqueda Avanzada**

- Buscar por documento identificativo
- Buscar por rango de fechas y montos

#### **4. Auditoría**

- Campo `ultimaActualizacion`
- Campo `usuarioQueModifico`
- Registrar quién y cuándo cambió el estado

#### **5. Reportes y Estadísticas**

```
GET /loans/reports/estadisticas
```

- Contar solicitudes por estado
- Monto total solicitado/aprobado

### 3.2 Mejoras Técnicas/Seguridad

#### **1. Autenticación y Autorización**

- Implementar **JWT** o **OAuth2**
- Roles: ADMIN, EMPLEADO, CLIENTE
- Endpoints protegidos según rol

#### **2. HTTPS y Certificados SSL**

- Configurar `server.ssl.key-store` en properties

#### **3. Rate Limiting**

- Limitar requests por IP
- Proteger contra DDoS

#### **4. Logging Mejorado**

- **SLF4J + Logback**
- Logs estructurados en JSON
- Integración con **ELK Stack** o **Datadog**

#### **5. Testing Completo**

- **Unit tests**: Servicios y excepciones (80%+ coverage)
- **Integration tests**: Endpoints con `@WebMvcTest`
- **Contract tests**: Validar contrato API

### 3.3 Mejoras Arquitecturales

#### **1. Microservicios**

- Separar en: `loan-service`, `user-service`, `notification-service`
- Comunicación vía REST o gRPC
- Usar **Docker** y **Kubernetes**

#### **2. Event-Driven Architecture**

- **Apache Kafka** o **RabbitMQ**
- Eventos: `LoanCreatedEvent`, `LoanApprovedEvent`
- Servicios que escuchan y reaccionan

#### **3. Caching**

- **Redis** para caché distribuido
- Cachear consultas GET frecuentes
- Invalidar al actualizar estado

#### **4. API Gateway**

- **Spring Cloud Gateway**
- Centralizador de autenticación
- Rate limiting global

#### **5. Documentación Automática**

- **Swagger/OpenAPI**
- Documentación en `/swagger-ui.html`
- Generar cliente SDK automáticamente

---

### Proyecto realizado como prueba técnica.
