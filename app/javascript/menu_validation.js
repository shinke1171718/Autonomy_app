document.addEventListener('turbo:load', function(event) {
  var form = document.getElementById('menu_form');

  form.addEventListener('submit', function(event) {

    var menu_name = form.elements['menu_name'];
    var menu_contents = form.elements['menu_contents'];
    var contents = form.elements['contents'];
    var errorMessage_1 = document.getElementById('menu-error_name');
    var errorMessage_2 = document.getElementById('menu-error-contents-1');
    var errorMessage_3 = document.getElementById('menu-error-contents-2');
    var inputName = document.querySelector(".name-registration-field input");
    var inputContent = document.querySelector(".menu-registration-field input");
    var inputText = document.querySelector("textarea");

    // menu_nameがnullの場合にエラーメッセージを代入
    validateAndHighlightInput(menu_name, errorMessage_1, inputName, 20, event)
    // menu_contentsがnullの場合にエラーメッセージを代入
    validateAndHighlightInput(menu_contents, errorMessage_2, inputContent, 20, event)
    // contentsがnullの場合にエラーメッセージを代入
    validateAndHighlightInput(contents, errorMessage_3, inputText, 700, event)

  });


  form.addEventListener('submit', function(event) {
    var minForm = 0;
    var maxForm = 14;
    var errorMessage_ingredient = document.getElementById('ingredients-error');

    for (var i = minForm; i < maxForm; i++) {
      validateInput("ingredient_name[" + i + "]", 15, errorMessage_ingredient);
      validateInput("ingredient_quantity[" + i + "]", 3, errorMessage_ingredient);
      validateInput("menu_ingredients_[" + i + "]unit", 3, errorMessage_ingredient);
    }
  });
});


function validateAndHighlightInput(element, errorMessage, inputElement, maxLength, event) {
  if (element.value === "" || element.value.length > maxLength) {
    event.preventDefault();
    errorMessage.textContent = "⚠️必須項目です。";
    inputElement.style.backgroundColor = "rgb(255, 184, 184)";
  } else {
    errorMessage.textContent = "";
    inputElement.style.backgroundColor = "";
  }
}


function validateInput(inputId, maxLength, errorMessageElement) {
  var input = document.getElementById(inputId);
  if (input && input.value === "" || element.value.length > maxLength) {
    event.preventDefault();
    input.style.backgroundColor = "rgb(255, 184, 184)";
    errorMessageElement.textContent = "⚠️未入力があります。";
  } else if (input) {
    input.style.backgroundColor = "";
  }
}


