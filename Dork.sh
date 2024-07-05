#!/bin/bash

search_dork() {
    local dork="$1"
    local query=$(echo "$dork" | sed 's/ /+/g' | sed 's/"/%22/g')
    local url="https://www.google.com/search?q=${query}"
    echo "Accessing URL: $url"

    # Realizar la solicitud HTTP con curl y guardar la respuesta y el código de estado HTTP
    response=$(curl -s -A "Mozilla/5.0" -w "%{http_code}" -o temp.html "$url")
    http_code="${response: -3}"  # Los últimos 3 caracteres son el código de estado HTTP

    if [ "$http_code" -eq "200" ]; then
        echo "Successful HTTP request. Parsing..."
        cat temp.html | grep -oP '(?<=<a href="/url\?q=)(.*?)(?=&amp;sa=U)' | while read -r link ; do
          echo "URL: $link"
        done
    else
        echo "Failed HTTP request. Status Code: $http_code"
    fi
    rm temp.html  # Limpiar archivo temporal
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
