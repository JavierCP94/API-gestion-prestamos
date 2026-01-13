# ============================================
# Ejemplos de uso de la Loan Management API
# Usando PowerShell en Windows
# ============================================

$BASE_URL = "http://localhost:8080"

Write-Host "🚀 Loan Management API - Ejemplos con PowerShell" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Green
Write-Host ""

# 1. CREAR UNA SOLICITUD
Write-Host "1️⃣ CREAR SOLICITUD DE PRÉSTAMO (HTTP 201)" -ForegroundColor Cyan
Write-Host "-------------------------------------------" -ForegroundColor Cyan
$body1 = @{
    nombreSolicitante = "Juan García López"
    importeSolicitado = 5000.00
    divisa = "EUR"
    documentoIdentificativo = "12345678A"
} | ConvertTo-Json

Invoke-WebRequest -Uri "$BASE_URL/loans" `
    -Method POST `
    -Headers @{"Content-Type"="application/json"} `
    -Body $body1 | ConvertFrom-Json | ConvertTo-Json -Depth 3

Write-Host ""
Write-Host ""

# 2. LISTAR TODAS
Write-Host "2️⃣ LISTAR TODAS LAS SOLICITUDES (HTTP 200)" -ForegroundColor Cyan
Write-Host "------------------------------------------" -ForegroundColor Cyan
Invoke-WebRequest -Uri "$BASE_URL/loans" `
    -Method GET `
    -Headers @{"Content-Type"="application/json"} | ConvertFrom-Json | ConvertTo-Json -Depth 3

Write-Host ""
Write-Host ""

# 3. OBTENER POR ID
Write-Host "3️⃣ OBTENER SOLICITUD POR ID (HTTP 200)" -ForegroundColor Cyan
Write-Host "--------------------------------------" -ForegroundColor Cyan
Invoke-WebRequest -Uri "$BASE_URL/loans/1" `
    -Method GET `
    -Headers @{"Content-Type"="application/json"} | ConvertFrom-Json | ConvertTo-Json -Depth 3

Write-Host ""
Write-Host ""

# 4. CAMBIAR ESTADO A APROBADA (VÁLIDO)
Write-Host "4️⃣ CAMBIAR ESTADO A APROBADA (HTTP 200) ✅" -ForegroundColor Green
Write-Host "-------------------------------------------" -ForegroundColor Green
$body4 = @{
    status = "APROBADA"
} | ConvertTo-Json

Invoke-WebRequest -Uri "$BASE_URL/loans/1/status" `
    -Method PATCH `
    -Headers @{"Content-Type"="application/json"} `
    -Body $body4 | ConvertFrom-Json | ConvertTo-Json -Depth 3

Write-Host ""
Write-Host ""

# 5. CAMBIAR ESTADO A CANCELADA (VÁLIDO desde APROBADA)
Write-Host "5️⃣ CAMBIAR ESTADO A CANCELADA (HTTP 200) ✅" -ForegroundColor Green
Write-Host "-------------------------------------------" -ForegroundColor Green
$body5 = @{
    status = "CANCELADA"
} | ConvertTo-Json

Invoke-WebRequest -Uri "$BASE_URL/loans/1/status" `
    -Method PATCH `
    -Headers @{"Content-Type"="application/json"} `
    -Body $body5 | ConvertFrom-Json | ConvertTo-Json -Depth 3

Write-Host ""
Write-Host ""

# 6. CREAR SEGUNDA SOLICITUD
Write-Host "6️⃣ CREAR OTRA SOLICITUD (HTTP 201)" -ForegroundColor Cyan
Write-Host "---------------------------------" -ForegroundColor Cyan
$body6 = @{
    nombreSolicitante = "María Rodríguez"
    importeSolicitado = 15000.00
    divisa = "EUR"
    documentoIdentificativo = "87654321B"
} | ConvertTo-Json

Invoke-WebRequest -Uri "$BASE_URL/loans" `
    -Method POST `
    -Headers @{"Content-Type"="application/json"} `
    -Body $body6 | ConvertFrom-Json | ConvertTo-Json -Depth 3

Write-Host ""
Write-Host ""

# 7. TRANSICIÓN INVÁLIDA (PENDIENTE -> CANCELADA)
Write-Host "7️⃣ TRANSICIÓN INVÁLIDA (HTTP 400) ❌" -ForegroundColor Red
Write-Host "------------------------------------" -ForegroundColor Red
Write-Host "Intentando: PENDIENTE -> CANCELADA" -ForegroundColor Red
$body7 = @{
    status = "CANCELADA"
} | ConvertTo-Json

try {
    Invoke-WebRequest -Uri "$BASE_URL/loans/2/status" `
        -Method PATCH `
        -Headers @{"Content-Type"="application/json"} `
        -Body $body7
} catch {
    $_.Exception.Response | ForEach-Object {
        Write-Host "Status Code: $($_.StatusCode.value__)" -ForegroundColor Red
    }
    $_.Content | ConvertFrom-Json | ConvertTo-Json -Depth 3
}

Write-Host ""
Write-Host ""

# 8. OBTENER SOLICITUD INEXISTENTE (404)
Write-Host "8️⃣ OBTENER SOLICITUD INEXISTENTE (HTTP 404) ❌" -ForegroundColor Red
Write-Host "---------------------------------------------" -ForegroundColor Red
try {
    Invoke-WebRequest -Uri "$BASE_URL/loans/999" `
        -Method GET `
        -Headers @{"Content-Type"="application/json"}
} catch {
    $_.Exception.Response | ForEach-Object {
        Write-Host "Status Code: $($_.StatusCode.value__)" -ForegroundColor Red
    }
    $_.Content | ConvertFrom-Json | ConvertTo-Json -Depth 3
}

Write-Host ""
Write-Host ""

# 9. VALIDACIÓN: IMPORTE NEGATIVO
Write-Host "9️⃣ VALIDACIÓN: IMPORTE NEGATIVO (HTTP 400) ❌" -ForegroundColor Red
Write-Host "---------------------------------------------" -ForegroundColor Red
$body9 = @{
    nombreSolicitante = "Test Usuario"
    importeSolicitado = -1000.00
    divisa = "EUR"
    documentoIdentificativo = "11111111C"
} | ConvertTo-Json

try {
    Invoke-WebRequest -Uri "$BASE_URL/loans" `
        -Method POST `
        -Headers @{"Content-Type"="application/json"} `
        -Body $body9
} catch {
    $_.Exception.Response | ForEach-Object {
        Write-Host "Status Code: $($_.StatusCode.value__)" -ForegroundColor Red
    }
    $_.Content | ConvertFrom-Json | ConvertTo-Json -Depth 3
}

Write-Host ""
Write-Host ""

# 10. VALIDACIÓN: NOMBRE EN BLANCO
Write-Host "🔟 VALIDACIÓN: NOMBRE EN BLANCO (HTTP 400) ❌" -ForegroundColor Red
Write-Host "-------------------------------------------" -ForegroundColor Red
$body10 = @{
    nombreSolicitante = ""
    importeSolicitado = 5000.00
    divisa = "EUR"
    documentoIdentificativo = "22222222D"
} | ConvertTo-Json

try {
    Invoke-WebRequest -Uri "$BASE_URL/loans" `
        -Method POST `
        -Headers @{"Content-Type"="application/json"} `
        -Body $body10
} catch {
    $_.Exception.Response | ForEach-Object {
        Write-Host "Status Code: $($_.StatusCode.value__)" -ForegroundColor Red
    }
    $_.Content | ConvertFrom-Json | ConvertTo-Json -Depth 3
}

Write-Host ""
Write-Host "✅ Tests completados!" -ForegroundColor Green
Write-Host ""
Write-Host "NOTAS:" -ForegroundColor Yellow
Write-Host "- Asegúrate de que la API esté corriendo: mvn spring-boot:run" -ForegroundColor Yellow
Write-Host "- Este script usa PowerShell 5.1+ y Invoke-WebRequest" -ForegroundColor Yellow
Write-Host "- Si tienes errores de certificado SSL, usa: -SkipCertificateCheck" -ForegroundColor Yellow
