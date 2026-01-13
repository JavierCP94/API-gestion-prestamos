#!/bin/bash

# ============================================
# Ejemplos de uso de la Loan Management API
# Usando curl desde terminal
# ============================================

# BASE_URL
BASE_URL="http://localhost:8080"

echo "🚀 Loan Management API - Ejemplos con curl"
echo "==========================================="
echo ""

# 1. CREAR UNA SOLICITUD
echo "1️⃣ CREAR SOLICITUD DE PRÉSTAMO (HTTP 201)"
echo "-------------------------------------------"
curl -X POST "$BASE_URL/loans" \
  -H "Content-Type: application/json" \
  -d '{
    "nombreSolicitante": "Juan García López",
    "importeSolicitado": 5000.00,
    "divisa": "EUR",
    "documentoIdentificativo": "12345678A"
  }' | jq '.'
echo ""
echo ""

# 2. LISTAR TODAS
echo "2️⃣ LISTAR TODAS LAS SOLICITUDES (HTTP 200)"
echo "------------------------------------------"
curl -X GET "$BASE_URL/loans" \
  -H "Content-Type: application/json" | jq '.'
echo ""
echo ""

# 3. OBTENER POR ID
echo "3️⃣ OBTENER SOLICITUD POR ID (HTTP 200)"
echo "--------------------------------------"
curl -X GET "$BASE_URL/loans/1" \
  -H "Content-Type: application/json" | jq '.'
echo ""
echo ""

# 4. CAMBIAR ESTADO A APROBADA (VÁLIDO)
echo "4️⃣ CAMBIAR ESTADO A APROBADA (HTTP 200) ✅"
echo "-------------------------------------------"
curl -X PATCH "$BASE_URL/loans/1/status" \
  -H "Content-Type: application/json" \
  -d '{
    "status": "APROBADA"
  }' | jq '.'
echo ""
echo ""

# 5. CAMBIAR ESTADO A CANCELADA (VÁLIDO desde APROBADA)
echo "5️⃣ CAMBIAR ESTADO A CANCELADA (HTTP 200) ✅"
echo "-------------------------------------------"
curl -X PATCH "$BASE_URL/loans/1/status" \
  -H "Content-Type: application/json" \
  -d '{
    "status": "CANCELADA"
  }' | jq '.'
echo ""
echo ""

# 6. CREAR SEGUNDA SOLICITUD
echo "6️⃣ CREAR OTRA SOLICITUD (HTTP 201)"
echo "---------------------------------"
curl -X POST "$BASE_URL/loans" \
  -H "Content-Type: application/json" \
  -d '{
    "nombreSolicitante": "María Rodríguez",
    "importeSolicitado": 15000.00,
    "divisa": "EUR",
    "documentoIdentificativo": "87654321B"
  }' | jq '.'
echo ""
echo ""

# 7. TRANSICIÓN INVÁLIDA (PENDIENTE -> CANCELADA)
echo "7️⃣ TRANSICIÓN INVÁLIDA (HTTP 400) ❌"
echo "------------------------------------"
echo "Intentando: PENDIENTE -> CANCELADA"
curl -X PATCH "$BASE_URL/loans/2/status" \
  -H "Content-Type: application/json" \
  -d '{
    "status": "CANCELADA"
  }' | jq '.'
echo ""
echo ""

# 8. OBTENER SOLICITUD INEXISTENTE (404)
echo "8️⃣ OBTENER SOLICITUD INEXISTENTE (HTTP 404) ❌"
echo "---------------------------------------------"
curl -X GET "$BASE_URL/loans/999" \
  -H "Content-Type: application/json" | jq '.'
echo ""
echo ""

# 9. VALIDACIÓN: IMPORTE NEGATIVO
echo "9️⃣ VALIDACIÓN: IMPORTE NEGATIVO (HTTP 400) ❌"
echo "---------------------------------------------"
curl -X POST "$BASE_URL/loans" \
  -H "Content-Type: application/json" \
  -d '{
    "nombreSolicitante": "Test Usuario",
    "importeSolicitado": -1000.00,
    "divisa": "EUR",
    "documentoIdentificativo": "11111111C"
  }' | jq '.'
echo ""
echo ""

# 10. VALIDACIÓN: NOMBRE EN BLANCO
echo "🔟 VALIDACIÓN: NOMBRE EN BLANCO (HTTP 400) ❌"
echo "-------------------------------------------"
curl -X POST "$BASE_URL/loans" \
  -H "Content-Type: application/json" \
  -d '{
    "nombreSolicitante": "",
    "importeSolicitado": 5000.00,
    "divisa": "EUR",
    "documentoIdentificativo": "22222222D"
  }' | jq '.'
echo ""
echo ""

echo "✅ Tests completados!"
echo ""
echo "NOTAS:"
echo "- Asegúrate de que la API esté corriendo: mvn spring-boot:run"
echo "- Este script usa 'jq' para formatear JSON. Instálalo con: apt install jq (Linux) o brew install jq (Mac)"
echo "- En Windows, puedes usar PowerShell o eliminar '| jq .' de cada comando"
