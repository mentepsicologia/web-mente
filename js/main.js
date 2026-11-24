// Año actual en el pie
document.querySelectorAll('[data-year]').forEach((el) => {
  el.textContent = new Date().getFullYear();
});

// Formulario de contacto: envía los mensajes a hola@mentepsicologiaonline.com (Web3Forms)
const form = document.querySelector('.form');
if (form) {
  const ok = form.querySelector('.form__msg:not(.form__msg--error)');
  const err = form.querySelector('.form__msg--error');
  const btn = form.querySelector('button[type="submit"]');
  if (ok && new URLSearchParams(location.search).has('enviado')) ok.hidden = false;

  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    if (!form.checkValidity()) { form.reportValidity(); return; }
    ok.hidden = true; err.hidden = true;
    btn.disabled = true;
    const label = btn.textContent;
    btn.textContent = 'Enviando…';
    try {
      const res = await fetch(form.action, {
        method: 'POST',
        headers: { Accept: 'application/json' },
        body: new FormData(form),
      });
      const data = await res.json().catch(() => ({}));
      if (!res.ok || String(data.success) === 'false') throw new Error(data.message || res.status);
      form.reset();
      ok.hidden = false;
    } catch (error) {
      err.hidden = false;
    } finally {
      btn.disabled = false;
      btn.textContent = label;
    }
  });
}

// Aparición suave de los bloques al hacer scroll
const revealTargets = document.querySelectorAll(
  '.section .container > *, .service-list li, .card, .values > *, .team > *, .faq details, .cta-band, .site-footer .container > *'
);

if ('IntersectionObserver' in window && !matchMedia('(prefers-reduced-motion: reduce)').matches) {
  const io = new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        entry.target.classList.add('is-visible');
        io.unobserve(entry.target);
      }
    });
  }, { threshold: 0.15, rootMargin: '0px 0px -40px 0px' });

  revealTargets.forEach((el) => {
    if (el.classList.contains('topic-panels')) return; // tiene su propia animación
    // Pequeño escalonado entre elementos hermanos
    const i = Array.from(el.parentElement.children).indexOf(el);
    el.style.transitionDelay = `${Math.min(i, 4) * 0.12}s`;
    el.classList.add('reveal');
    io.observe(el);
  });
}


// Temas clicables (página Servicios): abre la explicación de cada tema
const topicBtns = document.querySelectorAll('.topic-btn');
const topicBox = document.querySelector('.topic-panels');
let closeTimer;

topicBtns.forEach((btn) => {
  btn.addEventListener('click', () => {
    const panel = document.getElementById(btn.getAttribute('aria-controls'));
    const opening = btn.getAttribute('aria-expanded') !== 'true';
    clearTimeout(closeTimer);
    topicBtns.forEach((b) => b.setAttribute('aria-expanded', 'false'));

    if (opening && panel) {
      // Abrir o cambiar de tema
      document.querySelectorAll('.topic-panel.is-open').forEach((p) => p.classList.remove('is-open'));
      btn.setAttribute('aria-expanded', 'true');
      panel.classList.add('is-open');
      topicBox.classList.add('is-open');
      setTimeout(() => {
        const r = panel.getBoundingClientRect();
        if (r.bottom > window.innerHeight) panel.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
      }, 300);
    } else {
      // Cerrar: se pliega la caja y después se oculta el texto
      topicBox.classList.remove('is-open');
      closeTimer = setTimeout(() => {
        document.querySelectorAll('.topic-panel.is-open').forEach((p) => p.classList.remove('is-open'));
      }, 600);
    }
  });
});

// Preguntas frecuentes: apertura y cierre suaves
document.querySelectorAll('.faq--numbered details').forEach((det) => {
  const summary = det.querySelector('summary');
  const content = det.querySelector('.faq__a');
  if (!summary || !content || matchMedia('(prefers-reduced-motion: reduce)').matches) return;
  summary.addEventListener('click', (e) => {
    e.preventDefault();
    if (det.dataset.animating) return;
    det.dataset.animating = '1';
    const opts = { duration: 450, easing: 'cubic-bezier(.4, 0, .2, 1)' };
    if (!det.open) {
      det.open = true;
      const h = content.scrollHeight;
      content.animate([{ height: '0px', opacity: 0 }, { height: h + 'px', opacity: 1 }], opts)
        .onfinish = () => delete det.dataset.animating;
    } else {
      const h = content.scrollHeight;
      content.animate([{ height: h + 'px', opacity: 1 }, { height: '0px', opacity: 0 }], opts)
        .onfinish = () => { det.open = false; delete det.dataset.animating; };
    }
  });
});

// Sobre nosotras: panel lateral "Saber más sobre mí"
document.querySelectorAll('[data-profile]').forEach((btn) => {
  const dlg = document.getElementById(btn.dataset.profile);
  if (!dlg || typeof dlg.showModal !== 'function') return;
  const close = () => {
    dlg.classList.remove('is-open');
    document.documentElement.classList.remove('is-locked');
    const done = () => { dlg.close(); btn.focus(); };
    if (matchMedia('(prefers-reduced-motion: reduce)').matches) done();
    else setTimeout(done, 550);
  };
  btn.addEventListener('click', () => {
    dlg.showModal();
    document.documentElement.classList.add('is-locked');
    void dlg.offsetWidth; // fuerza el punto de partida para que se vea el deslizamiento
    dlg.classList.add('is-open');
  });
  dlg.querySelector('.profile__close').addEventListener('click', close);
  dlg.addEventListener('click', (e) => { if (e.target === dlg) close(); });
  dlg.addEventListener('cancel', (e) => { e.preventDefault(); close(); });
});
