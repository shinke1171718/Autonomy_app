import { validateInput, validatePasswordConfirmation } from './form_validation.js';

document.addEventListener('turbo:load', function() {

  // "password-validation-area" idを持つ要素が存在するか確認
  if (!document.getElementById('password-validation-area')) return;

  let validationTimeout; // タイマーを格納する変数
  const currentPasswordInput = document.querySelector('input[name="user[current_password]"]');
  const newPasswordInput = document.querySelector('input[name="user[password]"]');
  const newPasswordConfirmationInput = document.querySelector('input[name="user[password_confirmation]"]');

  if (currentPasswordInput) {
    // 現在のパスワードの検証
    currentPasswordInput.addEventListener('input', function() {
      // 前のタイマーをクリア
      clearTimeout(validationTimeout);

      // 新しいタイマーを設定
      validationTimeout = setTimeout(function() {
        validateInput(currentPasswordInput)
      }, 500);
    });
  }

  if (newPasswordInput) {
    // 新しいパスワードの検証
    newPasswordInput.addEventListener('input', function() {
      clearTimeout(validationTimeout);

      validationTimeout = setTimeout(function() {
        validateInput(newPasswordInput)
      }, 500);
    });
  }

  if (newPasswordConfirmationInput) {
    // 確認用パスワードの検証
    newPasswordConfirmationInput.addEventListener('input', function() {
      clearTimeout(validationTimeout);

      validationTimeout = setTimeout(function() {
        validatePasswordConfirmation(newPasswordConfirmationInput, newPasswordInput)
      }, 500);
    });
  }

  document.addEventListener('submit', function(event) {
    // イベントのトリガーとなった要素を取得
    const triggerElement = event.submitter;
    // トリガー要素が "back-button" クラスを持っているか確認
    if (triggerElement && triggerElement.classList.contains('back-button')) return;

    // すべてのフォームフィールドに対してバリデーションを実行
    validateInput(currentPasswordInput);
    validateInput(newPasswordInput);
    validatePasswordConfirmation(newPasswordConfirmationInput, newPasswordInput)

    // すべてのエラーメッセージ要素を取得
    const errorMessages = document.querySelectorAll('.error-message');
    let hasError = false;

    // エラーメッセージがあるかどうかをチェック
    errorMessages.forEach(function(errorMessage) {
      if (errorMessage.textContent.trim() !== '') {
        hasError = true;
      }
    });

    // エラーがある場合は送信を防止
    if (hasError) {
      event.preventDefault();
    }
  });
});