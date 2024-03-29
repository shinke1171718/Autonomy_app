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
    createErrorMessage(input, "⚠️8~128文字、英数字（記号は任意）");
    input.style.backgroundColor = "rgb(255, 184, 184)";
  }
}

export function isPasswordValid(password) {
  // パスワードの長さを検証
  if (password.length < 8 || password.length > 128) {
    return false;
  }

  // 正規表現を使ってパスワードの形式を検証
  // 大文字小文字を区別せず、記号があってもなくても良い設定
  // 最低1つの英字と1つの数字が必要
  // 記号はどちらでもいい
  const regex = /^(?=.*[a-zA-Z])(?=.*\d)[A-Za-z\d\W_]{8,128}$/;
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
    emailInput.style.backgroundColor = "";
  }
}

export function validateNameInput(nameInput) {
  clearErrorMessages(nameInput);

  // ユーザー名の形式と文字数を確認する正規表現
  const nameLengthPattern = /^.{2,15}$/;

  if (!nameInput.value.trim()) {
    createErrorMessage(nameInput, "⚠️入力してください。");
    nameInput.style.backgroundColor = "rgb(255, 184, 184)";
  } else if (!nameLengthPattern.test(nameInput.value)) {
    createErrorMessage(nameInput, "⚠️2~15文字で入力してください。");
    nameInput.style.backgroundColor = "rgb(255, 184, 184)";
  } else {
    nameInput.style.backgroundColor = "";
  }
}

// 新しいパスワードと確認用パスワードの検証関数
export function validatePasswordConfirmation(input, newPasswordInput) {
  clearErrorMessages(input);

  if (!input.value.trim()) {
    createErrorMessage(input, "⚠️入力してください。");
    input.style.backgroundColor = "rgb(255, 184, 184)";
  } else if (newPasswordInput.value !== input.value) {
    createErrorMessage(input, "⚠️新しいパスワードと一致しません。");
    input.style.backgroundColor = "rgb(255, 184, 184)";
  }
}