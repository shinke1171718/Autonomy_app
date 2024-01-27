import { validateInput, validateEmailInput, validateNameInput, validatePasswordConfirmation } from 'form_validation';

document.addEventListener('turbo:load', function() {

  // "new-account-validation" idを持つ要素が存在するか確認
  if (!document.getElementById('new-account-validation')) return;

  let validationTimeout; // タイマーを格納する変数

  const nameInput = document.querySelector('input[name="user[name]"]');
  const emailInput = document.querySelector('input[name="user[email]"]');
  const newPasswordInput = document.querySelector('input[name="user[password]"]');
  const newPasswordConfirmationInput = document.querySelector('input[name="user[password_confirmation]"]');

  // ユーザー名の検証
  nameInput.addEventListener('input', function() {
    clearTimeout(validationTimeout);

    validationTimeout = setTimeout(function() {
      validateNameInput(nameInput)
    }, 500);
  });

  // 新しいパスワードの検証
  newPasswordInput.addEventListener('input', function() {
    clearTimeout(validationTimeout);

    validationTimeout = setTimeout(function() {
      validateInput(newPasswordInput)
    }, 500);
  });

  // 確認用パスワードの検証
  newPasswordConfirmationInput.addEventListener('input', function() {
    clearTimeout(validationTimeout);

    validationTimeout = setTimeout(function() {
      validatePasswordConfirmation(newPasswordConfirmationInput, newPasswordInput)
    }, 500);
  });

  // メールアドレスフィールドのバリデーション
  emailInput.addEventListener('input', function() {
    clearTimeout(validationTimeout);
    validationTimeout = setTimeout(function() {
      validateEmailInput(emailInput);
    }, 500);
  });

  document.addEventListener('submit', function(event) {
    // イベントのトリガーとなった要素を取得
    const triggerElement = event.submitter;
    // トリガー要素が "back-button" クラスを持っているか確認
    if (triggerElement && triggerElement.classList.contains('back-button')) return;

    // すべてのフォームフィールドに対してバリデーションを実行
    validateNameInput(nameInput)
    validateEmailInput(emailInput);
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