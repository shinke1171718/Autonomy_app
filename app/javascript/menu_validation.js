
setTimeout(initializeRealtimeValidation, 500);

document.addEventListener('submit', function(event) {
  // イベントが発生したフォーム内の 'next_step_button' を探し、ない場合には処理を行わない。
  let nextStepButton = event.target.querySelector('#next_step_button');
  if (!nextStepButton) return;

  let hasError = false; // エラーを追跡するためのフラグ
  let menu_name = document.getElementById("menu_name");
  let menu_contents = document.getElementById("menu_contents");
  let errorMessage_name = document.getElementById("menu-error_name");
  let errorMessage_menu_contents = document.getElementById("menu-error-menu-contents");
  let inputName = document.querySelector(".name-form-field input");
  let inputContent = document.querySelector(".menu-contents-field input");


  if (!validateAndHighlightInput(menu_name, errorMessage_name, inputName, event)) {
    hasError = true;
  }

  if (!validateAndHighlightInput(menu_contents, errorMessage_menu_contents, inputContent, event)) {
    hasError = true;
  }

  if (!ValidateStepFormFields(event)) {
    hasError = true;
  }

  // ingredientフォームのバリデーション
  const ingredientFormContainers = document.querySelectorAll('.ingredient-form-container');
  ingredientFormContainers.forEach((ingredientFormContainer, index) => {
    const nameInput = ingredientFormContainer.querySelector('.ingredient-name');
    const quantityInput = ingredientFormContainer.querySelector('.ingredient-quantity');
    const errorDiv = ingredientFormContainer.querySelector('.ingredient-error-message');
    if (nameInput.value.trim() == "") return;
    if (!validateIngredientQuantity(quantityInput, errorDiv)) {
      hasError = true;
    }
  });

  if (hasError) {
    event.preventDefault();
  }
});

function initializeRealtimeValidation() {
  const menuNameInput = document.getElementById("menu_name");
  const menuContentsInput = document.getElementById("menu_contents");
  const stepFormContainers = document.querySelectorAll('.step-form-container');
  let errorMessage_name = document.getElementById("menu-error_name");
  let errorMessage_menu_contents = document.getElementById("menu-error-menu-contents");
  let inputName = document.querySelector(".name-form-field input");
  let inputContent = document.querySelector(".menu-contents-field input");

  // メニュー名のリアルタイムバリデーション
  menuNameInput.addEventListener('input', function() {
    setupDelayedValidation(menu_name, () => validateAndHighlightInput(menu_name, errorMessage_name, inputName));
  });

  // メニュー内容のリアルタイムバリデーション
  menuContentsInput.addEventListener('input', function() {
    setupDelayedValidation(menu_contents, () => validateAndHighlightInput(menu_contents, errorMessage_menu_contents, inputContent));
  });

  // 各ステップのリアルタイムバリデーション
  stepFormContainers.forEach((stepFormContainer) => {
    const dropdown = stepFormContainer.querySelector('.step-category-dropdown select');
    const textarea = stepFormContainer.querySelector('.step-description textarea');

    // ドロップダウンの変更をリアルタイムでバリデーション（500ms遅延）
    setupDelayedValidation(dropdown, () => ValidateStepFormFields(stepFormContainer));

    // テキストエリアの入力をリアルタイムでバリデーション（500ms遅延）
    setupDelayedValidation(textarea, () => ValidateStepFormFields(stepFormContainer));
  });

  let ingredientFormContainers = document.querySelectorAll('.ingredient-form-container');

  ingredientFormContainers.forEach((ingredientFormContainer) => {
    const ingredientQuantityInput = ingredientFormContainer.querySelector('.ingredient-quantity');
    const errorDiv = ingredientFormContainer.querySelector('.ingredient-error-message');
    setupDelayedValidation(ingredientQuantityInput, () => validateIngredientQuantity(ingredientQuantityInput, errorDiv));
  });
}

function setupDelayedValidation(inputElement, validationFunction) {
  let validationTimeout;
  inputElement.addEventListener('input', function() {
    clearTimeout(validationTimeout);
    validationTimeout = setTimeout(validationFunction, 500);
  });
  inputElement.addEventListener('change', function() {
    clearTimeout(validationTimeout);
    validationTimeout = setTimeout(validationFunction, 500);
  });
}


function validateAndHighlightInput(element, sub_errorMessage, inputElement) {
  // 入力値が空、または20文字を超えている場合にエラーメッセージを表示
  if (element.value.trim() === "" || element.value.trim().length > 20) {
    sub_errorMessage.textContent = "⚠️必須：20文字以内で入力してください。";
    inputElement.style.backgroundColor = "rgb(255, 184, 184)";
    return false;
  } else {
    // 条件を満たしている場合はエラーメッセージと背景色をクリア
    sub_errorMessage.textContent = "";
    inputElement.style.backgroundColor = "";
    return true;
  }
}

function ValidateStepFormFields(event) {
  const stepFormContainers = document.querySelectorAll('.step-form-container');
  let hasError = false;

  stepFormContainers.forEach((stepFormContainer) => {
    const dropdown = stepFormContainer.querySelector('.step-category-dropdown select');
    const textarea = stepFormContainer.querySelector('.step-description textarea');
    const errorDiv = stepFormContainer.querySelector('.step-error-message');

    // エラーメッセージの初期化
    errorDiv.textContent = '';
    errorDiv.style.color = 'red';
    errorDiv.style.backgroundColor = "";

    // ドロップダウンまたはテキストエリアのいずれかが入力されているかをチェック
    const isDropdownEntered = dropdown && dropdown.value;
    const isTextareaEntered = textarea && textarea.value.trim();

    // 両方が未入力の場合はバリデーションをスキップ
    if (!isDropdownEntered && !isTextareaEntered) {
      dropdown.style.backgroundColor = "";
      textarea.style.backgroundColor = "";
      return;
    }

    // ドロップダウンの選択を検証
    if (!isDropdownEntered) {
      dropdown.style.backgroundColor = "rgb(255, 184, 184)";
      errorDiv.textContent += "⚠️必須：工程ジャンルを選択してください。";
      hasError = true;
    }else {
      dropdown.style.backgroundColor = "";
    }

    // テキストエリアの入力を検証
    if (textarea && (!textarea.value.trim() || textarea.value.trim().length > 60)) {
      textarea.style.backgroundColor = "rgb(255, 184, 184)";
      errorDiv.textContent = "⚠️必須：60文字以内で入力してください。";
      hasError = true;
    }else {
      textarea.style.backgroundColor = "";
    }
  });

  return !hasError;
}

function validateIngredientQuantity(quantityInput, errorDiv) {
  const quantityValue = quantityInput.value.trim();

  // 数量が半角数字ではない、または空の場合にエラーメッセージを表示
  if (!quantityValue || !isHalfWidthNumber(quantityValue)) {
    errorDiv.textContent = "⚠️必須：半角数字で数量の設定をしてください。";
    quantityInput.style.backgroundColor = "rgb(255, 184, 184)";
    errorDiv.style.color = "red";
    return false;
  } else {
    errorDiv.textContent = "";
    quantityInput.style.backgroundColor = "";
    errorDiv.style.color = "";
  }
}

// 半角数字のみかどうかをチェックするヘルパー関数
function isHalfWidthNumber(value) {
  return /^[0-9]+$/.test(value);
}
