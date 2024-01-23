
document.addEventListener('turbo:load', function() {
  let validationTimeout;
  // メールアドレスの入力フィールドを取得
  const emailInput = document.querySelector('input[name="user[email]"]');

  // 名前入力フィールドのバリデーション
  emailInput.addEventListener('input', function() {
    clearTimeout(validationTimeout);
    validationTimeout = setTimeout(function() {
      validateEmailInput(emailInput);
    }, 500);
  });

  document.addEventListener('submit', function(event) {
    // フォームフィールドに対してバリデーションを実行
    validateEmailInput(emailInput);

    // すべてのエラーメッセージ要素を取得
    const errorMessage = emailInput.parentNode.querySelector('.error-message');
    console.log(errorMessage);
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


function clearErrorMessages(input) {
  // inputに関連するエラーメッセージ要素を探し、それらを削除
  // input要素にあるerror-message要素を取得
  const errorMessage = input.parentNode.querySelector('.error-message');
  errorMessage.textContent = '';

  // 対象の入力フィールドの背景色をリセット
  input.style.backgroundColor = "";
}

function validateEmailInput(emailInput) {
  clearErrorMessages(emailInput);

  // メールアドレスの形式を確認する正規表現
  const emailPattern = /^[\w+\-.]+@[a-z\d\-.]+\.[a-z]+$/i;

  if (!emailInput.value.trim()) {
    createErrorMessage(emailInput, "⚠️入力してください。");
    emailInput.style.backgroundColor = "rgb(255, 184, 184)";
  } else if (!emailPattern.test(emailInput.value)) {
    createErrorMessage(emailInput, "⚠️メールアドレスの形式が不正です");
    emailInput.style.backgroundColor = "rgb(255, 184, 184)";
  } else {
    emailInput.style.backgroundColor = ""; // エラーがない場合は背景色をリセット
  }
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