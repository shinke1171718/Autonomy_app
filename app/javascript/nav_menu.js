
document.addEventListener('turbo:load', function() {
  let mobileMenuButton = document.querySelector('.mobile-menu-button');
  let mobileMenuContent = document.querySelector('.mobile-menu-content');
  let mask = document.querySelector('#mask');

  if (mobileMenuButton) {
    mobileMenuButton.addEventListener('click', function() {
      mobileMenuContent.classList.toggle('open');
      mask.classList.toggle('open');
    });
  }

  if (mask) {
    mask.addEventListener('click', function() {
      mobileMenuContent.classList.remove('open');
      mask.classList.remove('open');
    });
  }
});
