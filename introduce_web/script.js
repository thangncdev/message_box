const viBtn = document.getElementById('vi-btn');
const enBtn = document.getElementById('en-btn');

viBtn.addEventListener('click', () => switchLang('vi'));
enBtn.addEventListener('click', () => switchLang('en'));

function switchLang(lang) {
  const viElems = document.querySelectorAll('.vi');
  const enElems = document.querySelectorAll('.en');

  if (lang === 'vi') {
    viElems.forEach(el => el.style.display = '');
    enElems.forEach(el => el.style.display = 'none');
    viBtn.classList.add('active');
    enBtn.classList.remove('active');
  } else {
    viElems.forEach(el => el.style.display = 'none');
    enElems.forEach(el => el.style.display = '');
    enBtn.classList.add('active');
    viBtn.classList.remove('active');
  }
}
