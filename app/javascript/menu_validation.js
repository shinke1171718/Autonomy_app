document.addEventListener("turbo:load", function(event) {
  var form = document.getElementById("menu_form");
  var minForm = 0;
  var maxForm = 14;

  form.addEventListener('submit', function(event) {
    var menu_name = form.elements["menu_name"];
    var menu_contents = form.elements["menu_contents"];
    var contents = form.elements["contents"];
    var errorMessage_name = document.getElementById("menu-error_name");
    var errorMessage_contents = document.getElementById("menu-error-contents-1");
    var errorMessage_contents_2 = document.getElementById("menu-error-contents-2");
    var inputName = document.querySelector(".name-registration-field input");
    var inputContent = document.querySelector(".menu-registration-field input");
    var inputText = document.querySelector("textarea");

    validateAndHighlightInput(menu_name, errorMessage_name, inputName, event)
    validateAndHighlightInput(menu_contents, errorMessage_contents, inputContent, event)
    validateAndHighlightInput(contents, errorMessage_contents_2, inputText, event)
  });



  form.addEventListener('submit', function(event) {
    for (var i = minForm; i < maxForm; i++) {
      validateInput("ingredient_name[" + i + "]");
      validateInput("ingredient_quantity[" + i + "]");
      validateInput("menu_ingredients_[" + i + "]unit");
    }
  });


  form.addEventListener('submit', function(event) {
    var names = [];
    var duplication_error = document.getElementById("ingredients-name-duplication-error");
    function isNameValid(name) {
      return name.trim() !== "" && !names.includes(name);
    }

    for (var i = minForm; i < maxForm; i++) {
      var ingredient_name = document.getElementById("ingredient_name[" + i + "]");
      if (ingredient_name.value.trim() === "") {
        continue;
      }

      var name = ingredient_name.value.trim();
      if (isNameValid(name)) {
        names.push(name);
        ingredient_name.style.backgroundColor = '';
      } else {
        ingredient_name.style.backgroundColor = "rgb(255, 184, 184)";
        duplication_error.textContent = "⚠️重複登録された食材があります。";
      }
    }


  });
});


function validateAndHighlightInput(element ,sub_errorMessage, inputElement, event) {
  var menu_main_errorMessage = document.getElementById("main-menu-error");
  if (element.value === "" ) {
    event.preventDefault();
    menu_main_errorMessage.textContent = "⚠️未入力があります。";
    sub_errorMessage.textContent = "⚠️必須";
    inputElement.style.backgroundColor = "rgb(255, 184, 184)";
  } else {
    errorMessage.textContent = "";
    inputElement.style.backgroundColor = "";
  }
}


function validateInput(inputId) {
  var errorMessage_ingredient = document.getElementById('ingredients-error');
  var input = document.getElementById(inputId);
  if (input && input.value === "" ) {
    event.preventDefault();
    input.style.backgroundColor = "rgb(255, 184, 184)";
    errorMessage_ingredient.textContent = "⚠️未入力があります。";
  } else if (input) {
    input.style.backgroundColor = "";
  }
}

