// ホーム画面のハンバーガーメニューの設定
let content = document.querySelector(".mobile-menu-content");
let btn = document.querySelector(".mobile-menu-botton");
let mask = document.querySelector("#mask");

// イベントリスナーの付与
function toggleMenu() {
  content.classList.toggle("open");
}

btn.addEventListener("click", toggleMenu);
mask.addEventListener("click", toggleMenu);