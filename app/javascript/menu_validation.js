document.addEventListener('submit', function(event) {

  // フォーム送信時に、アクティブな要素が back-button なら何もしない
  if (document.activeElement.classList.contains('back-button')) {
    return;
  }

  if (document.activeElement.classList.contains('edit-button')) {
    return;
  }

  let minForm = 0;
  let maxForm = 14;
  let menu_name = document.getElementById("menu_name");
  let menu_contents = document.getElementById("menu_contents");
  let contents = document.getElementById("contents");
  let errorMessage_name = document.getElementById("menu-error_name");
  let errorMessage_menu_contents = document.getElementById("menu-error-menu-contents");
  let errorMessage_contents = document.getElementById("menu-error-contents");
  let inputName = document.querySelector(".name-form-field input");
  let inputContent = document.querySelector(".menu-contents-field input");
  let inputText = document.querySelector("textarea");

  // menuモデルのバリデーション
  validateAndHighlightInput(menu_name, errorMessage_name, inputName, event)
  validateAndHighlightInput(menu_contents, errorMessage_menu_contents, inputContent, event)
  validateAndHighlightInput(contents, errorMessage_contents, inputText, event)

  // ingredientモデルのバリデーション
  for (let i = minForm; i < maxForm; i++) {
    const EXCEPTIONAL_UNIT_IDS = ["17"]; // 17は「少々」という単位のunit_idです。
    const ingredientNameInput = document.getElementById("ingredient_name[" + i + "]");

    if (!ingredientNameInput || ingredientNameInput.value.trim() === "") continue;

    const ingredientUnitInput = document.getElementById("menu_ingredients_unit[" + i + "]");
    const selectedUnitId = ingredientUnitInput.value;

    // EXCEPTIONAL_UNIT_IDSに設定」されているIDはバリデーションを行わない
    if (EXCEPTIONAL_UNIT_IDS.includes(selectedUnitId)) continue;

    validateInput("ingredient_quantity[" + i + "]");
  }
});


function validateAndHighlightInput(element ,sub_errorMessage, inputElement, event) {
  let menu_main_errorMessage = document.getElementById("main-menu-error");
  if (element.value === "" ) {
    event.preventDefault();
    menu_main_errorMessage.textContent = "⚠️未入力があります。";
    sub_errorMessage.textContent = "⚠️必須";
    inputElement.style.backgroundColor = "rgb(255, 184, 184)";
  } else {
    menu_main_errorMessage.textContent = "";
    sub_errorMessage.textContent = "";
    inputElement.style.backgroundColor = "";
  }
}

function validateInput(inputId) {
  let errorMessage_ingredient = document.getElementById('ingredients-error');
  let input = document.getElementById(inputId);
  if (input && input.value === "" ) {
    event.preventDefault();
    input.style.backgroundColor = "rgb(255, 184, 184)";
    errorMessage_ingredient.textContent = "⚠️未入力があります。";
  } else {
    input.style.backgroundColor = "";
  }
}

