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
  "Terapia online individual y de pareja, sexología, psicología perinatal y supervisión para psicólogos. Enfoque integrador en trauma, apego y EMDR."

build sobre-nosotras.html sobre.html     sobre \
  "Sobre Nosotras · Psicólogas Sanitarias Online | Mente" \
  "Mente es un espacio de psicoterapia online cercano y libre de juicios. Enfoque integrador basado en la evidencia: IFS, EMDR y terapia somática."

build dudas.html          dudas.html     dudas \
  "Preguntas Frecuentes sobre Terapia Online | Mente Psicología" \
  "Resolvemos tus dudas sobre la terapia online: cómo funciona, eficacia, EMDR, duración de las sesiones, tarifas y la primera llamada gratuita."

build contacto.html       contacto.html  contacto \
  "Contacto · Pide tu Primera Llamada Gratuita | Mente Psicología" \
  "Escríbenos y te contactamos para una primera llamada gratuita y sin compromiso. Terapia online desde cualquier lugar."

# Páginas por especialidad (SEO): una búsqueda principal por página
build psicologa-perinatal-online.html perinatal.html servicios \
  "Psicóloga Perinatal Online · Embarazo y Posparto | Mente" \
  "Psicóloga perinatal online: acompañamiento en búsqueda de embarazo, embarazo, parto difícil, posparto y pérdida gestacional. Primera llamada gratuita."

# ESPECIALIDADES-INICIO (generado)
build terapia-trauma-online.html esp-trauma.html servicios \
  "Terapia de Trauma Online · Psicóloga Especialista | Mente" \
  "Terapia de trauma online con enfoque integrador y EMDR. Te acompañamos a procesar experiencias difíciles que siguen presentes hoy. Llamada gratuita."

build terapia-apego-online.html esp-apego.html servicios \
  "Terapia de Apego y Vínculos Online | Mente Psicología" \
  "Terapia online para comprender tu estilo de apego y construir vínculos más seguros. Enfoque integrador en trauma y apego. Primera llamada gratuita."

build psicologa-ansiedad-online.html esp-ansiedad.html servicios \
  "Psicóloga Online para la Ansiedad | Mente Psicología" \
  "Terapia online para la ansiedad: comprende qué hay detrás de la preocupación y la tensión constante y recupera la calma. Primera llamada gratuita."

build psicologa-depresion-online.html esp-depresion.html servicios \
  "Psicóloga Online para la Depresión | Mente Psicología" \
  "Terapia online para la depresión: te acompañamos a entender la tristeza persistente y la falta de energía y a reconectar contigo. Llamada gratuita."

build terapia-autoestima-online.html esp-autoestima.html servicios \
  "Terapia para la Autoestima Online | Mente Psicología" \
  "Terapia online para la autoestima: trabaja la autocrítica, los límites y la sensación de no ser suficiente desde un lugar más amable. Llamada gratuita."

build heridas-de-la-infancia-terapia.html esp-heridas.html servicios \
  "Heridas de la Infancia · Terapia Online | Mente Psicología" \
  "Terapia online para sanar heridas de la infancia: abandono, crítica o falta de cuidado que siguen condicionando tu presente. Llamada gratuita."

build gestion-emocional-terapia-online.html esp-gestion.html servicios \
  "Gestión Emocional · Terapia Online | Mente Psicología" \
  "Terapia online de gestión emocional: aprende a reconocer, entender y regular tus emociones sin reprimirlas. Enfoque integrador. Llamada gratuita."

build terapia-duelo-online.html esp-duelo.html servicios \
  "Terapia de Duelo Online · Acompañamiento | Mente Psicología" \
  "Terapia de duelo online: acompañamiento ante la pérdida de una persona, una relación o una etapa de la vida, respetando tus tiempos. Llamada gratuita."

build dependencia-emocional-terapia-online.html esp-dependencia.html servicios \
  "Terapia para la Dependencia Emocional Online | Mente" \
  "Terapia online para la dependencia emocional: comprende el miedo al abandono y construye relaciones desde la libertad, no desde el miedo. Llamada gratuita."

build terapia-pareja-online.html esp-pareja.html servicios \
  "Terapia de Pareja Online · Psicóloga de Pareja | Mente" \
  "Terapia de pareja online con enfoque integrador: comunicación, conflictos que se repiten, distancia, celos o crisis de confianza. Primera llamada gratuita."

# ESPECIALIDADES-FIN

build sexologa-online.html esp-sexologia.html servicios \
  "Sexóloga Online · Terapia Sexual y de Pareja | Mente" \
  "Terapia sexual online con psicóloga sexóloga: deseo, dolor, ansiedad, erección u orgasmo. Individual o en pareja, sin juicios. Primera llamada gratuita."

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
