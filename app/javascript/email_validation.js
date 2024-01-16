
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









// ドキュメントに 'submit' イベントリスナーを追加
// document.addEventListener('submit', function(event) {
//   // '更新' ボタン（idが 'update-user-submit'）の要素を取得
//   let updateUserSubmitButton = event.target.querySelector('#update-user-submit');
//   // '更新' ボタンが存在しない場合、処理を終了
//   if (!updateUserSubmitButton) return;

//   // 既存のエラーメッセージをクリア
//   clearErrorMessages();

//   // 名前とメールアドレスの入力フィールドを取得
//   const nameInput = document.querySelector('input[name="user[name]"]');
//   const emailInput = document.querySelector('input[name="user[email]"]');

//   // 入力バリデーションを実行し、失敗した場合はフォームの送信を阻止
//   let isNameValid = validateInput(nameInput);
//   let isEmailValid = validateInput(emailInput);

//   // 入力バリデーションを実行し、失敗した場合はフォームの送信を阻止
//   if (!isNameValid && !isEmailValid) {
//     event.preventDefault();
//     return;
//   }

//   // メールアドレスの重複チェックを非同期で行い、結果に応じて処理を行う
//   event.preventDefault();
//   checkEmailAvailability(emailInput.value)
//     .then(isAvailable => {
//       if (isAvailable && isNameValid && isEmailValid) {
//         // メールアドレスが重複しておらず、他のバリデーションも通過した場合、フォームを送信
//         event.target.submit();
//       } else if (!isAvailable) {
//         // メールアドレスが重複している場合、エラーメッセージを表示
//         createErrorMessage(emailInput, "⚠️メールアドレスはすでに使用されています。");
//       }
//     });
// });

// function clearErrorMessages() {
//   // 全てのエラーメッセージ要素を取得し、削除する
//   document.querySelectorAll('.error-message').forEach((element) => {
//     element.remove();
//   });
// }

// function validateInput(input) {
//   // 入力値が空の場合、エラーメッセージを表示し、falseを返す
//   if (input.value === "") {
//     createErrorMessage(input, "⚠️入力してください。");
//     return false;
//   }
//   input.style.backgroundColor = "";
//   // 入力値が有効な場合、trueを返す
//   return true;
// }
