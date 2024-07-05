#!/bin/bash

# Función para buscar un dork específico en Google
search_dork() {
  local dork="$1"
  # Codificar URL para manejar caracteres especiales
  local query=$(echo "$dork" | sed 's/ /+/g' | sed 's/"/%22/g')
  local url="https://www.google.com/search?q=${query}"
  # Realizar la solicitud HTTP con curl
  response=$(curl -s -A "Mozilla/5.0" "$url")
  # Imprimir respuesta para diagnóstico
  echo "Response from curl:"
  echo "$response"
  # Verificar si la respuesta contiene HTML de página válida
  if [[ "$response" == *'<!DOCTYPE html>'* ]]; then
    echo "Received HTML response. Handling..."
    # Filtrar y mostrar los resultados relevantes
    echo "$response" | grep -oP '(?<=<a href="/url\?q=)(.*?)(?=&amp;sa=U)' | while read -r link ; do
      echo "URL: $link"
    done
  else
    echo "Unexpected response or error. Please check the URL and parameters."
  fi
}

# Lista de dorks a buscar
dorks=(
  'intext:"powered by Adyen" "buy toys" inurl:checkout',
  'intext:"powered by Adyen" "juguetes" inurl:checkout',
  'intext:"powered by Adyen" "toy store" inurl:cart'
)

# Iterar sobre los dorks y buscar cada uno
for dork in "${dorks[@]}"; do
  echo "Results for dork: $dork"
  search_dork "$dork"
  echo "=================================================="
done
