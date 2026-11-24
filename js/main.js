// Menú móvil
const toggle = document.querySelector('.nav-toggle');
const nav = document.querySelector('.nav');

if (toggle && nav) {
  toggle.addEventListener('click', () => {
    const open = toggle.getAttribute('aria-expanded') === 'true';
    toggle.setAttribute('aria-expanded', String(!open));
    nav.classList.toggle('is-open', !open);
  });
}

// Año actual en el pie
document.querySelectorAll('[data-year]').forEach((el) => {
  el.textContent = new Date().getFullYear();
});

// Formulario de contacto: de momento solo evita el envío.
// Cuando haya servicio de formularios (Formspree, Netlify Forms...), sustituir aquí.
const form = document.querySelector('.form');
if (form) {
  form.addEventListener('submit', (e) => {
    e.preventDefault();
    const msg = form.querySelector('.form__msg');
    if (msg) msg.hidden = false;
    form.reset();
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
    // Pequeño escalonado entre elementos hermanos
    const i = Array.from(el.parentElement.children).indexOf(el);
    el.style.transitionDelay = `${Math.min(i, 4) * 0.12}s`;
    el.classList.add('reveal');
    io.observe(el);
  });
}

// Banner de cookies (solo recuerda la elección; aún no hay cookies de analítica)
const banner = document.querySelector('.cookie-banner');
if (banner) {
  let choice = null;
  try { choice = localStorage.getItem('mente-cookies'); } catch (e) {}
  if (!choice) banner.hidden = false;
  banner.addEventListener('click', (e) => {
    const btn = e.target.closest('[data-cookies]');
    if (!btn) return;
    try { localStorage.setItem('mente-cookies', btn.dataset.cookies); } catch (e) {}
    banner.hidden = true;
  });
}
