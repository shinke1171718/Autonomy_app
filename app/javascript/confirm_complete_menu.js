confirmCompleteCooking()

function confirmCompleteCooking() {
  // 'complete-cooking-button' IDを持つ要素を取得
  const completeCookingButton = document.getElementById('complete-cooking-button');

  // ボタンが存在しない場合は関数を早期に終了
  if (!completeCookingButton) return;

  // ボタンのクリックイベントに対するリスナーを設定
  completeCookingButton.addEventListener('click', (e) => {
    e.preventDefault();

    // ボタンのデータ属性からURLを取得
    const url = completeCookingButton.getAttribute('data-url');

    console.log(url);

    // 確認ダイアログのメッセージを構築
    const confirmationMessage = "本当に" + completeCookingButton.textContent.trim() + "を調理完了してよろしいですか？";

    // 確認ダイアログを表示し、OKが押された場合のみURLに遷移
    if (confirm(confirmationMessage)) {
      window.location.href = url;
    }
  });
}