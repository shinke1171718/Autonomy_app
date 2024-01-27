import { validateNameInput } from './form_validation.js';

document.addEventListener('turbo:load', function() {
  // "user-name-validation-area" idを持つ要素が存在するか確認
  if (!document.getElementById('user-name-validation-area')) return;

  let validationTimeout;
  // メールアドレスの入力フィールドを取得
  const nameInput = document.querySelector('input[name="user[name]"]');

  // 名前入力フィールドのバリデーション
  nameInput.addEventListener('input', function() {
    clearTimeout(validationTimeout);
    validationTimeout = setTimeout(function() {
      validateNameInput(nameInput);
    }, 500);
  });

  document.addEventListener('submit', function(event) {
    // "email-validation-area" idを持つ要素が存在するか確認
    if (!document.getElementById('user-name-validation-area')) return;

    // イベントのトリガーとなった要素を取得
    const triggerElement = event.submitter;
    // トリガー要素が "back-button" クラスを持っているか確認
    if (triggerElement && triggerElement.classList.contains('back-button')) return;

    // フォームフィールドに対してバリデーションを実行
    validateNameInput(nameInput);

    // すべてのエラーメッセージ要素を取得
    const errorMessage = nameInput.parentNode.querySelector('.error-message');
    let hasError = false;

    // エラーメッセージがあるかどうかをチェック
    if (errorMessage.textContent.trim() !== '') {
      hasError = true;
    }

    // エラーがある場合は送信を防止
    if (hasError) {
      event.preventDefault();
    }
  });
});