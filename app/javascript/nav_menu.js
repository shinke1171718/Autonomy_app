
document.addEventListener('turbo:load', function() {
  let mobileMenuButton = document.querySelector('.mobile-menu-button');
  let mobileMenuContent = document.querySelector('.mobile-menu-content');
  let mask = document.querySelector('#mask');
  let body = document.body;

  if (mobileMenuButton) {
    mobileMenuButton.addEventListener('click', function() {
      mobileMenuContent.classList.toggle('open');
      mask.classList.toggle('open');
      body.classList.toggle('body-no-scroll');
    });
  }

  if (mask) {
    mask.addEventListener('click', function() {
      mobileMenuContent.classList.remove('open');
      mask.classList.remove('open');
      body.classList.remove('body-no-scroll');
    });
  }
});
