#!/bin/bash
# Genera las páginas HTML uniendo cabecera + contenido + pie.
# Edita los archivos de partials/ y ejecuta:  ./build.sh
cd "$(dirname "$0")"
build() { # archivo  body  marcador-activo  título  descripción
  local cur="$3"
  sed -e "s|{{TITLE}}|$4|" -e "s|{{DESC}}|$5|" partials/head.html \
    | sed -e "s|{{CUR_${cur}}}| aria-current=\"page\"|" -e 's|{{CUR_[a-z]*}}||g' > "$1"
  cat "partials/body/$2" partials/foot.html >> "$1"
}
D="Terapia online con perspectiva integradora y enfoque en trauma, apego y EMDR."
build index.html          index.html     none      "Mente · Centro de Psicología Online" "$D"
build servicios.html      servicios.html servicios "Servicios · Mente Psicología Online" "$D"
build sobre-nosotras.html sobre.html     sobre     "Sobre Nosotras · Mente Psicología Online" "$D"
build dudas.html          dudas.html     dudas     "Dudas · Mente Psicología Online" "$D"
build contacto.html       contacto.html  contacto  "Contacto · Mente Psicología Online" "$D"
echo "Páginas generadas."
