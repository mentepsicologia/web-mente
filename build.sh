#!/bin/bash
# Genera las páginas HTML uniendo cabecera + contenido + pie.
# Edita los archivos de partials/ y ejecuta:  ./build.sh
#
# SEO: cada página tiene su propio título (máx. ~60 caracteres) y
# descripción (máx. ~155 caracteres). Si añades una página nueva,
# añádela aquí y también a sitemap.xml.
cd "$(dirname "$0")"

# Versión de CSS/JS: cambia cuando cambian, para que el navegador no use la copia antigua
V=$(cat css/styles.css js/main.js | md5 | cut -c1-8)

build() { # archivo  body  menú-activo  título  descripción  [noindex]
  local file="$1" cur="$3" robots="index, follow" path="$1"
  [ "$file" = "index.html" ] && path=""
  [ "$6" = "noindex" ] && robots="noindex, follow"
  sed -e "s#{{TITLE}}#$4#g" -e "s#{{DESC}}#$5#g" -e "s#{{ROBOTS}}#$robots#" -e "s#{{PATH}}#$path#g" partials/head.html \
    | sed -e "s|{{CUR_${cur}}}| aria-current=\"page\"|" -e 's|{{CUR_[a-z]*}}||g' > "$file"
  cat "partials/body/$2" partials/foot.html >> "$file"
  sed -i '' "s#{{V}}#$V#g" "$file"
}

build index.html          index.html     none \
  "Psicóloga Online · Terapia de Trauma, Apego y EMDR | Mente" \
  "Centro de psicología online con perspectiva integradora. Terapia para adultos y pareja especializada en trauma, apego y EMDR. Primera llamada gratuita."

build servicios.html      servicios.html servicios \
  "Terapia Online para Adultos y Pareja | Mente Psicología" \
  "Terapia online individual y de pareja, y grupos de supervisión para psicólogos. Enfoque integrador, en trauma, apego y EMDR. Consulta sin compromiso."

build sobre-nosotras.html sobre.html     sobre \
  "Sobre Nosotras · Psicólogas Sanitarias Online | Mente" \
  "Mente es un espacio de psicoterapia online cercano y libre de juicios. Enfoque integrador basado en la evidencia: IFS, EMDR y terapia somática."

build dudas.html          dudas.html     dudas \
  "Preguntas Frecuentes sobre Terapia Online | Mente Psicología" \
  "Resolvemos tus dudas sobre la terapia online: cómo funciona, eficacia, EMDR, duración de las sesiones, tarifas y la primera llamada gratuita."

build contacto.html       contacto.html  contacto \
  "Contacto · Pide tu Primera Llamada Gratuita | Mente Psicología" \
  "Escríbenos y te contactamos para una primera llamada gratuita y sin compromiso. Terapia online desde cualquier lugar."

# Páginas legales y de error: no interesan en Google
build privacidad.html     legal-privacidad.html none "Política de Privacidad | Mente Psicología Online" "Política de privacidad de Mente Psicología Online." noindex
build cookies.html        legal-cookies.html    none "Política de Cookies | Mente Psicología Online" "Política de cookies de Mente Psicología Online." noindex
build aviso-legal.html    legal-aviso.html      none "Aviso Legal | Mente Psicología Online" "Aviso legal de Mente Psicología Online." noindex
build 404.html            404.html              none "Página no encontrada | Mente Psicología Online" "La página que buscas no existe." noindex

# Portada: el formulario de contacto sustituye a la franja "Agenda tu llamada gratuita"
sed -i '' '/<section class="cta-band">/,/<\/section>/d' index.html

# La 404 puede mostrarse en cualquier ruta: rutas absolutas para que cargue el estilo
sed -i '' 's#<head>#<head>\n  <base href="/">#' 404.html

echo "Páginas generadas."
