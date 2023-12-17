document.addEventListener('turbo:load', function() {

  let shoppingListContainer = document.getElementById('complete-button');
  if (!shoppingListContainer) return;

  // 全てのチェックボックスを取得
  let checkboxes = document.querySelectorAll('.custom-checkbox');
  // チェックボックスの総数を取得
  let boxCount = checkboxes.length;
  // ボタン要素を取得
  let button = document.getElementById('complete-button');
  // チェックされたチェックボックスの数をカウント
  let checkedCount = document.querySelectorAll('.custom-checkbox:checked').length;

  // チェックボックスが0個の場合、ボタンを有効化してスタイルを適用し、処理を終了
  if (boxCount === 0) {
    button.style.backgroundColor = '#1E9AF4';
    button.style.cursor = 'pointer';
    return;
  }

  if (boxCount === checkedCount){
    button.style.backgroundColor = '#1E9AF4';
    button.style.cursor = 'pointer';
    button.addEventListener('mouseover', onMouseOver);
    button.addEventListener('mouseout', onMouseOut);
  }else{
    button.disabled = true;
    button.style.backgroundColor = '';
    button.style.cursor = 'auto';
    button.removeEventListener('mouseover', onMouseOver);
    button.removeEventListener('mouseout', onMouseOut);
  }

  // 各チェックボックスにイベントリスナーを設定
  checkboxes.forEach(checkbox => {
    checkbox.addEventListener('change', () => {

      let checkedCount = document.querySelectorAll('.custom-checkbox:checked').length;

      // 全てのチェックボックスがチェックされていればボタンを有効化
      button.disabled = !(checkedCount === boxCount);

      // ボタンが有効の場合、特定の背景色に変更
      if (!button.disabled) {
        button.style.backgroundColor = '#1E9AF4';
        button.style.cursor = 'pointer';
        button.addEventListener('mouseover', onMouseOver);
        button.addEventListener('mouseout', onMouseOut);
      } else {
        // ボタンが無効の場合、SCSSで設定された背景色を使う
        button.style.backgroundColor = '';
        button.style.cursor = 'auto';
        button.removeEventListener('mouseover', onMouseOver);
        button.removeEventListener('mouseout', onMouseOut);
      }
    });
  });
});

function onMouseOver() {
  this.style.backgroundColor = '#9dd2f9';
}

function onMouseOut() {
  this.style.backgroundColor = '#1E9AF4';
}
