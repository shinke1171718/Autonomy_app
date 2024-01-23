document.addEventListener('turbo:load', function() {

  // "password-validation-area" idを持つ要素が存在するか確認
  if (!document.getElementById('password-validation-area')) return;

  let validationTimeout; // タイマーを格納する変数
  const currentPasswordInput = document.querySelector('input[name="user[current_password]"]');
  const newPasswordInput = document.querySelector('input[name="user[password]"]');
  const newPasswordConfirmationInput = document.querySelector('input[name="user[password_confirmation]"]');

  // 現在のパスワードの検証
  currentPasswordInput.addEventListener('input', function() {
    // 前のタイマーをクリア
    clearTimeout(validationTimeout);

     // 新しいタイマーを設定
    validationTimeout = setTimeout(function() {
      validateInput(currentPasswordInput)
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




function clearErrorMessages(input) {
  // inputに関連するエラーメッセージ要素を探し、それらを削除
  // input要素にあるerror-message要素を取得
  const errorMessage = input.parentNode.querySelector('.error-message');
  errorMessage.textContent = '';

  // 対象の入力フィールドの背景色をリセット
  input.style.backgroundColor = "";
}


function createErrorMessage(input, message) {
  // inputの兄弟要素の中から最初のerror-messageクラスを持つ要素を見つける
  const errorDiv = input.parentNode.querySelector('.error-message');
  if (errorDiv) {
    // エラーメッセージを設定
    errorDiv.textContent = message;
    errorDiv.style.color = 'red';
  }
}

function isPasswordValid(password) {
  // まずパスワードの長さを検証
  if (password.length < 8) {
    return false;
  }

  // 次に正規表現を使ってパスワードの形式を検証
  const regex = /^(?=.*?[a-z])(?=.*?[A-Z])(?=.*?\d)(?=.*?[\W_])[a-zA-Z\d\W_]+$/;
  return regex.test(password);
}

function validateInput(input) {
  clearErrorMessages(input); // このフィールドの既存のエラーメッセージをクリア

  if (!input.value.trim()) {
    createErrorMessage(input, "⚠️入力してください。");
    input.style.backgroundColor = "rgb(255, 184, 184)";
  } else if (!isPasswordValid(input.value)) {
    createErrorMessage(input, "⚠️8文字以上、大小英字、数字、記号を含んでください。");
    input.style.backgroundColor = "rgb(255, 184, 184)";
  }
}

// 新しいパスワードと確認用パスワードの検証関数
function validatePasswordConfirmation(input, newPasswordInput) {
  clearErrorMessages(input);

  if (!input.value.trim()) {
    createErrorMessage(input, "⚠️入力してください。");
    input.style.backgroundColor = "rgb(255, 184, 184)";
  } else if (newPasswordInput.value !== input.value) {
    createErrorMessage(input, "⚠️新しいパスワードと一致しません。");
    input.style.backgroundColor = "rgb(255, 184, 184)";
  }
}