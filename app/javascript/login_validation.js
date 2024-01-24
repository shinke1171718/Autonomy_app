import {validateInput, validateEmailInput } from './form_validation.js';

document.addEventListener('turbo:load', function() {
  // "login-validation-area" idを持つ要素が存在するか確認
  if (!document.getElementById('login-validation-area')) return;

  let validationTimeout;
  // メールアドレスの入力フィールドを取得
  const emailInput = document.querySelector('input[name="user[email]"]');
  const newPasswordInput = document.querySelector('input[name="user[password]"]');

  // 名前入力フィールドのバリデーション
  emailInput.addEventListener('input', function() {
    clearTimeout(validationTimeout);
    validationTimeout = setTimeout(function() {
      validateEmailInput(emailInput);
    }, 500);
  });

  newPasswordInput.addEventListener('input', function() {
    clearTimeout(validationTimeout);

    validationTimeout = setTimeout(function() {
      validateInput(newPasswordInput)
    }, 500);
  });

  document.addEventListener('submit', function(event) {
    // "email-validation-area" idを持つ要素が存在するか確認
    if (!document.getElementById('email-validation-area')) return;

    // イベントのトリガーとなった要素を取得
    const triggerElement = event.submitter;
    // トリガー要素が "back-button" クラスを持っているか確認
    if (triggerElement && triggerElement.classList.contains('back-button')) return;

    // フォームフィールドに対してバリデーションを実行
    validateEmailInput(emailInput);
    validateInput(newPasswordInput)

    // すべてのエラーメッセージ要素を取得
    const errorMessage = emailInput.parentNode.querySelector('.error-message');
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