document.addEventListener("turbo:load", function(event) {
  let form = document.getElementById("menu_form");
  let minForm = 0;
  let maxForm = 14;

  form.addEventListener('submit', function(event) {
    let menu_name = form.elements["menu_name"];
    let menu_contents = form.elements["menu_contents"];
    let contents = form.elements["contents"];
    let errorMessage_name = document.getElementById("menu-error_name");
    let errorMessage_contents = document.getElementById("menu-error-contents-1");
    let errorMessage_contents_2 = document.getElementById("menu-error-contents-2");
    let inputName = document.querySelector(".name-registration-field input");
    let inputContent = document.querySelector(".menu-registration-field input");
    let inputText = document.querySelector("textarea");

    // menuモデルのバリデーション
    validateAndHighlightInput(menu_name, errorMessage_name, inputName, event)
    validateAndHighlightInput(menu_contents, errorMessage_contents, inputContent, event)
    validateAndHighlightInput(contents, errorMessage_contents_2, inputText, event)

    // ingredientモデルのバリデーション
    for (let i = minForm; i < maxForm; i++) {
      const EXCEPTIONAL_UNIT_IDS = ["17"];
      const ingredientNameInput = document.getElementById("ingredient_name[" + i + "]");
      const ingredientUnitInput = document.getElementById("menu_ingredients_unit[" + i + "]");
      const selectedUnitId = ingredientUnitInput.value;

      // 「少々」の場合にはバリデーションを行わない
      if (EXCEPTIONAL_UNIT_IDS.includes(selectedUnitId)) return;
      if (ingredientNameInput.value.trim() === "") return;
      validateInput("ingredient_quantity[" + i + "]");
    }
  });
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

