document.addEventListener('turbo:load', function() {
  setupDeleteButtonListeners('.delete-button');
  setupEventListeners('.decrement-button');
});

function setupDeleteButtonListeners(buttonClass) {
  const buttons = document.querySelectorAll(buttonClass);
  buttons.forEach(button => {
    button.addEventListener('click', function(event) {
      event.preventDefault();

      const form = this.closest('form');
      const formData = new FormData(form);
      const menuId = formData.get('menu_id');

      // 数量減少ボタンでitem_countが1の場合は処理を終了
      if (buttonClass === '.decrement-button' && itemCount === '1') return;

      const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
      const url = '/shopping_lists/check_items';

      fetch(url, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrfToken
        },
        body: JSON.stringify({ menu_id: menuId })
      })
      .then(response => response.json())
      .then(data => {
        if (data.requires_attention) {
          if (confirm('献立の変更により、既にチェックされた食材の数量が変わるか、リストから削除されます。この変更を適用しますか？')) {
            form.submit();
          }
        } else {
          form.submit();
        }
      })
      .catch(error => {
        console.error('Error:', error);
      });
    });
  });
}


function setupEventListeners(buttonClass) {
  const buttons = document.querySelectorAll(buttonClass);
  buttons.forEach(button => {
    button.addEventListener('click', function(event) {
      event.preventDefault();

      const form = this.closest('form');
      const formData = new FormData(form);
      const menuId = formData.get('menu_id');
      const itemCount = formData.get('item_count');

      // 数量減少ボタンでitem_countが1の場合は処理を終了
      if (buttonClass === '.decrement-button' && itemCount === '1') return;

      const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
      const url = '/shopping_lists/check_items';

      fetch(url, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrfToken
        },
        body: JSON.stringify({ menu_id: menuId, item_count: itemCount })
      })
      .then(response => response.json())
      .then(data => {
        if (data.requires_attention) {
          if (confirm('リスト更新により、すでにチェックされている必要食材の数量が変更されますがよろしいでしょうか？')) {
            updatePagePart(form, menuId);
          }
        } else {
          updatePagePart(form, menuId);
        }
      })
      .catch(error => {
        console.error('Error:', error);
      });
    });
  });
}

function updatePagePart(form, menuId) {
  fetch(form.action, {
    method: 'POST',
    body: new FormData(form),
    headers: {
      'X-Requested-With': 'XMLHttpRequest',
      'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
    }
  })
  .then(response => response.text())
  .then(html => {
    const quantityElement = document.getElementById(`menu-item-quantity-${menuId}`);
    if (quantityElement) {
      quantityElement.innerHTML = html;
    }
  })
  .catch(error => console.error('Error:', error));
}

