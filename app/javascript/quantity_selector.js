
document.addEventListener('DOMContentLoaded', function() {
  let container = document.querySelector('.quantity-selector');

  container.addEventListener('click', function(e) {
    let button = e.target;
    let input = document.querySelector('.quantity-input');
    let currentValue = parseInt(input.value) || 0;

    if (button.dataset.action === 'increase') {
      input.value = currentValue + 1;
    } else if (button.dataset.action === 'decrease') {
      let newValue = currentValue - 1;
      input.value = newValue >= parseInt(input.min) ? newValue : currentValue;
    }
  });
});
