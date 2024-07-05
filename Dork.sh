
#!/bin/bash

# FunciÃ³n para buscar un dork especÃ­fico en Google
search_dork() {
  local dork="$1"
  local query=$(echo "$dork" | sed 's/ /+/g' | sed 's/"/%22/g')
  local url="https://www.google.com/search?q=${query}"
  local temp_file="response.html"

  echo "Accessing URL: $url" # Diagnostic output

  # Realizar la solicitud HTTP con curl y guardar la respuesta en un archivo temporal
  curl -s -A "Mozilla/5.0" -o "$temp_file" "$url"

  # Diagnosticar la respuesta inicial
  echo "Curl Response (first 10 lines):"
  head -n 10 "$temp_file" # Muestra las primeras 10 lÃ­neas del archivo para diagnÃ³stico

  # Comprobar si el archivo contiene HTML (por ejemplo, buscando '<html')
  if grep -q '<html' "$temp_file"; then
    echo "HTML content detected in response. Parsing..."
    # Filtrar y mostrar los resultados relevantes
    grep -oP '(?<=<a href="/url\?q=)(.*?)(?=&amp;sa=U)' "$temp_file" | while read -r link ; do
      echo "URL: $link"
    done
  else
    echo "No valid HTML content found, please check the response."
  fi

  # Limpiar: eliminar el archivo temporal
  rm "$temp_file"
}

# Lista de dorks a buscar
dorks=(
  'intext:"powered by Adyen" "buy toys" inurl:checkout'
  'intext:"powered by Adyen" "juguetes" inurl:checkout'
  'intext:"powered by Adyen" "toy store" inurl:cart'
)

# Iterar sobre los dorks y buscar cada uno
for dork in "${dorks[@]}"; do
  echo "Results for dork: $dork"
  search_dork "$dork"
  echo "=================================================="
done
