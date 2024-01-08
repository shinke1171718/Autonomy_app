// ドキュメントに 'submit' イベントリスナーを追加
document.addEventListener('submit', function(event) {
  // '更新' ボタン（idが 'update-user-submit'）の要素を取得
  let updateUserSubmitButton = event.target.querySelector('#update-user-submit');
  // '更新' ボタンが存在しない場合、処理を終了
  if (!updateUserSubmitButton) return;

  // 既存のエラーメッセージをクリア
  clearErrorMessages();

  // 名前とメールアドレスの入力フィールドを取得
  const nameInput = document.querySelector('input[name="user[name]"]');
  const emailInput = document.querySelector('input[name="user[email]"]');

  // 入力バリデーションを実行し、失敗した場合はフォームの送信を阻止
  let isNameValid = validateInput(nameInput);
  let isEmailValid = validateInput(emailInput);
  // 入力バリデーションを実行し、失敗した場合はフォームの送信を阻止
  if (!isNameValid && !isEmailValid) {
    event.preventDefault();
    return;
  }

  // メールアドレスの重複チェックを非同期で行い、結果に応じて処理を行う
  event.preventDefault();
  checkEmailAvailability(emailInput.value)
    .then(isAvailable => {
      if (isAvailable) {
        // メールアドレスが重複していない場合、フォームを送信
        event.target.submit();
      } else {
        // メールアドレスが重複している場合、エラーメッセージを表示
        createErrorMessage(emailInput, "⚠️メールアドレスはすでに使用されています。");
      }
    });
});

function clearErrorMessages() {
  // 全てのエラーメッセージ要素を取得し、削除する
  document.querySelectorAll('.error-message').forEach((element) => {
    element.remove();
  });
}

function validateInput(input) {
  // 入力値が空の場合、エラーメッセージを表示し、falseを返す
  if (input.value === "") {
    createErrorMessage(input, "⚠️入力してください。");
    return false;
  }
  input.style.backgroundColor = "";
  // 入力値が有効な場合、trueを返す
  return true;
}

function createErrorMessage(input, message) {
  // エラーメッセージ要素を作成し、スタイルを設定
  const errorMessage = document.createElement('div');
  errorMessage.textContent = message;
  errorMessage.classList.add('error-message');
  errorMessage.style.color = 'red';
  // エラーメッセージを入力フィールドの前に挿入
  input.parentNode.insertBefore(errorMessage, input);
  // エラーメッセージの背景色を設定
  input.style.backgroundColor = "rgb(255, 184, 184)";
}

function checkEmailAvailability(email) {
  // CSRFトークンを取得し、サーバーへのPOSTリクエストを行う
  const token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
  // メールアドレスの重複をチェックするサーバーサイドのURL
  const url = '/registrations/check_email';

  // サーバーにメールアドレスの重複チェックをリクエスト
  return fetch(url, {
    method: 'POST',
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'X-CSRF-Token': token
    },
    body: JSON.stringify({ email: email })
  })
  .then(response => response.json())
  .then(data => !data.is_taken); // メールアドレスが既に使用されていない場合、trueを返す
}
