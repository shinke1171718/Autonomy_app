
setupCheckboxEventListeners()

// チェックボックスのイベントを設定する関数
function setupCheckboxEventListeners() {

  let checkboxes = document.querySelectorAll('.custom-checkbox');

  checkboxes.forEach(checkbox => {
    checkbox.addEventListener('change', (e) => {
      const listId = e.target.value;
      const isChecked = e.target.checked;

      const token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

      const url = `/shopping_lists/${listId}/toggle_check`;

      fetch(url, {
        method: 'POST',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'X-CSRF-Token': token
        },
        body: JSON.stringify({ is_checked: isChecked })
      })
      .then(response => {
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }
      })
    });
  });
}