setupCheckboxEventListeners();
setupIngredientItemClickEvents();

function setupCheckboxEventListeners() {
  // すべての '.custom-checkbox' 要素を選択し、それぞれにリスナーを追加
  document.querySelectorAll('.custom-checkbox').forEach(function(checkbox) {
    checkbox.addEventListener('change', handleCheckboxChange);
  });
}

function setupIngredientItemClickEvents() {
  // すべての '.ingredient-item' 要素を選択し、それぞれにリスナーを追加
  document.querySelectorAll('.ingredient-item').forEach(function(item) {
    item.addEventListener('click', handleIngredientItemClick);
  });
}

// ingredient-item がクリックされたときの処理
function handleIngredientItemClick(e) {
  // クリックされた要素から 'custom-checkbox' クラスを持つ要素を検索
  let checkbox = e.currentTarget.querySelector('.custom-checkbox');
  // チェックボックスの状態をトグル（切り替え）
  checkbox.checked = !checkbox.checked;

  // チェックボックスの変更イベントを手動で発火させる
  triggerCheckboxChangeEvent(checkbox);
}

// チェックボックスの状態を変更するためのメソッド
function triggerCheckboxChangeEvent(checkbox) {
  // 'change' イベントを作成
  const event = new Event('change');
  // 作成したイベントを発生させる
  checkbox.dispatchEvent(event);
}

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