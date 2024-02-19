import { validateEmailInput } from 'form_validation';

document.addEventListener('turbo:load', function() {
  // "email-validation-area" idを持つ要素が存在するか確認
  if (!document.getElementById('email-validation-area')) return;

  let validationTimeout;
  // メールアドレスの入力フィールドを取得
  const emailInput = document.querySelector('input[name="user[email]"]');

  // 名前入力フィールドのバリデーション
  emailInput.addEventListener('input', function() {
    console.log("きている01");
    clearTimeout(validationTimeout);
    validationTimeout = setTimeout(function() {
      validateEmailInput(emailInput);
      console.log("きている0");
    }, 500);
  });

  document.addEventListener('submit', function(event) {
    console.log("きている1");
    // "email-validation-area" idを持つ要素が存在するか確認
    if (!document.getElementById('email-validation-area')) return;

    console.log("きている2");
    // イベントのトリガーとなった要素を取得
    const triggerElement = event.submitter;
    // トリガー要素が "back-button" クラスを持っているか確認
    if (triggerElement && triggerElement.classList.contains('back-button')) return;

    console.log("きている3");
    // フォームフィールドに対してバリデーションを実行
    validateEmailInput(emailInput);

    // すべてのエラーメッセージ要素を取得
    const errorMessage = emailInput.parentNode.querySelector('.error-message');
    let hasError = false;

    // エラーメッセージがあるかどうかをチェック
    if (errorMessage.textContent.trim() !== '') {
      hasError = true;
      console.log("きている4");
    }

    console.log("きている5");
    // エラーがある場合は送信を防止
    if (hasError) {
      event.preventDefault();
      console.log("きている6");
    }
  });
});