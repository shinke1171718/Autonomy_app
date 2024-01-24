export function createErrorMessage(input, message) {
  // inputの兄弟要素の中から最初のerror-messageクラスを持つ要素を見つける
  const errorDiv = input.parentNode.querySelector('.error-message');
  if (errorDiv) {
    // エラーメッセージを設定
    errorDiv.textContent = message;
    errorDiv.style.color = 'red';
  }
}

export function clearErrorMessages(input) {
  // inputに関連するエラーメッセージ要素を探し、それらを削除
  const errorMessage = input.parentNode.querySelector('.error-message');
  errorMessage.textContent = '';

  // 対象の入力フィールドの背景色をリセット
  input.style.backgroundColor = "";
}

export function validateInput(input) {
  if (!input) return;
  clearErrorMessages(input); // このフィールドの既存のエラーメッセージをクリア

  if (!input.value.trim()) {
    createErrorMessage(input, "⚠️入力してください。");
    input.style.backgroundColor = "rgb(255, 184, 184)";
  } else if (!isPasswordValid(input.value)) {
    createErrorMessage(input, "⚠️8~128文字、大小英字、数字、記号を含んでください。");
    input.style.backgroundColor = "rgb(255, 184, 184)";
  }
}

export function isPasswordValid(password) {
  // パスワードの長さを検証
  if (password.length < 8 || password.length > 128) {
    return false;
  }

  // 正規表現を使ってパスワードの形式を検証
  const regex = /^(?=.*?[a-z])(?=.*?[A-Z])(?=.*?\d)(?=.*?[\W_])[a-zA-Z\d\W_]{8,128}$/;
  return regex.test(password);
}

export function validateEmailInput(emailInput) {
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