
#!/bin/bash

# Función para buscar un dork específico en Google
search_dork() {
  local dork="$1"
  local query=$(echo "$dork" | sed 's/ /+/g' | sed 's/"/%22/g')
  local url="https://www.google.com/search?q=${query}"
  echo "URL being accessed: $url" # Diagnosticar la URL

  response=$(curl -s -A "Mozilla/5.0" "$url")
  
  echo "Curl Response: " # Diagnostico para ver la respuesta inicial de curl
  echo "$response" | head -n 5 # Muestra las primeras 5 líneas de la respuesta

  # Filtrar y mostrar los resultados relevantes
  echo "$response" | grep -oP '(?<=<a href="/url\?q=)(.*?)(?=&amp;sa=U)' | while read -r link ; do
    echo "URL: $link"
  done
}

dorks=(
  'intext:"powered by Adyen" "buy toys" inurl:checkout',
  'intext:"powered by Adyen" "juguetes" inurl:checkout',
  'intext:"powered by Adyen" "toy store" inurl:cart'
)

for dork in "${dorks[@]}"; do
  echo "Results for dork: $dork"
  search_dork "$dork"
  echo "=================================================="
done
