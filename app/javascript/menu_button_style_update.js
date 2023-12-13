document.addEventListener('turbo:load', function() {
  let menuIndex = document.getElementById('menu-index');
  if (!menuIndex) return;

  // 'menu-item'クラスを持つ要素をすべて選択
  let menuItems = document.querySelectorAll('.menu-item');
  let button = document.getElementById('shopping-list');

  // ボタンの初期状態を無効化に設定
  button.disabled = true;

  // 'menu-item'クラスを持つ要素があるか確認
  if (menuItems.length > 0) {
    // ボタンを有効化し、スタイルを適用
    button.disabled = false;
    button.style.backgroundColor = '#333'; // 背景色を設定
    button.style.cursor = 'pointer'; // カーソルをポインターに設定
  }
});