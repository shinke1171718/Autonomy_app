document.addEventListener('submit', function(event) {
  let updatePasswordSubmitButton = event.target.querySelector('#update-password-submit');
  if (!updatePasswordSubmitButton) return;

  // フォームのバリデーション状態を追跡する変数
  let PasswordIsValid = true;

  clearErrorMessages();

  const currentPasswordInput = document.querySelector('input[name="user[current_password]"]');
  const newPasswordInput = document.querySelector('input[name="user[password]"]');
  const newPasswordConfirmationInput = document.querySelector('input[name="user[password_confirmation]"]');

  // 未入力のフィールドがあるか確認し、あればエラーメッセージを表示
  [currentPasswordInput, newPasswordInput, newPasswordConfirmationInput].forEach(input => {
    if (!input.value.trim()) {
      createErrorMessage(input, "⚠️入力してください。");
      input.style.backgroundColor = "rgb(255, 184, 184)";
      event.preventDefault();
    }
  });

  // currentPasswordInputにエラーのスタイルが適用されている場合、現在のパスワードの検証をスキップ
  if (currentPasswordInput.style.backgroundColor === "rgb(255, 184, 184)") {
    PasswordIsValid = false;
  }

  // 現在のパスワードの検証
  if (PasswordIsValid) {
    validateCurrentPassword(currentPasswordInput, event);
  }

  // 新しいパスワードの長さとフォーマットを検証
  if (newPasswordInput.value.trim() !== '' && !isPasswordValid(newPasswordInput.value)) {
    createErrorMessage(newPasswordInput, "⚠️8文字以上、大小英字、数字、特殊文字を含んでください。");
    newPasswordInput.style.backgroundColor = "rgb(255, 184, 184)";
    event.preventDefault();
    PasswordIsValid = false;
  }

  // 新しいパスワードが未入力の場合、確認用パスワードにエラーメッセージを表示
  if (!newPasswordInput.value.trim() && newPasswordConfirmationInput.value.trim()) {
    createErrorMessage(newPasswordConfirmationInput, "⚠️新しいパスワードと内容が異なります。");
    newPasswordConfirmationInput.style.backgroundColor = "rgb(255, 184, 184)";
    event.preventDefault();
  }

  // 「newPasswordInput」または「newPasswordConfirmationInput」のいずれかがすでにエラーの場合は検証をスキップ
  if ([newPasswordInput, newPasswordConfirmationInput].some(input => input.style.backgroundColor === "rgb(255, 184, 184)")) return;

  // 新しいパスワードと確認用パスワードが一致するか検証
  if (newPasswordInput.value !== newPasswordConfirmationInput.value) {
    createErrorMessage(newPasswordConfirmationInput, "⚠️新しいパスワードと一致しません。");
    newPasswordConfirmationInput.style.backgroundColor = "rgb(255, 184, 184)";
    event.preventDefault();
  }
});

function clearErrorMessages() {
  document.querySelectorAll('.error-message').forEach(element => {
    element.remove();
  });
  document.querySelectorAll('input').forEach(input => {
    input.style.backgroundColor = "";
  });
}

function createErrorMessage(input, message) {
  const errorMessage = document.createElement('div');
  errorMessage.textContent = message;
  errorMessage.classList.add('error-message');
  errorMessage.style.color = 'red';
  input.parentNode.insertBefore(errorMessage, input);
}

function validateCurrentPassword(input, callback) {
  const token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
  const url = '/registrations/validate_current_password';

  fetch(url, {
    method: 'POST',
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'X-CSRF-Token': token
    },
    body: JSON.stringify({ current_password: input.value })
  })
  .then(response => response.json())
  .then(data => {
    if (!data.is_valid) {
      createErrorMessage(input, "⚠️現在のパスワードが間違っています。");
      input.style.backgroundColor = "rgb(255, 184, 184)";
      event.preventDefault();
    }
  })
  .catch(error => {
    // エラー処理
    event.preventDefault();
    formIsValid = false;
  });
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
