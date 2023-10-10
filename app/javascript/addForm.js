var formCount_view = 0;
var formCount_back = -1;
var maxFormCount_view = 15;

document.addEventListener("turbo:load", function(event) {
  // 一度数値をリセット
  formCount_view = 0;
  formCount_back = -1;

  // コードを５つ構成
  for (var i = 0; i < 5; i++) {
    createNewForm();
  }
  updateMaxCountText()
});

document.addEventListener("turbo:load", function(event) {
  var count_up_bottom = document.getElementById("form-count-up");
  count_up_bottom.addEventListener("click", function(event) {
    event.preventDefault();
    createNewForm();
    updateMaxCountText()
  });
});

document.addEventListener("click", function (event) {
  if (event.target.classList.contains("form-count-down")) {
    event.preventDefault();
    var container = event.target.closest(".custom-ingredient-fields");
    container.remove();
    updateFormNumbers();
    formCount_view--;
    formCount_back--;
    updateMaxCountText()
  }
});


function createNewForm() {
  var formContainer = document.getElementById("ingredient-form-add-container");
  var newFormCount_view = formCount_view + 1;
  var paddedNewFormCount = newFormCount_view < 10 ? '0' + newFormCount_view : newFormCount_view;
  paddedNewFormCount = paddedNewFormCount.toString().padStart(2, '0');

  var newFormCount_back = formCount_back + 1;

  if (formCount_view < maxFormCount_view) {
    var newForm =
      `<div class="custom-ingredient-fields">\
        <div class ="form-delete_button">\
          <a href="#" class="form-count-down" data-action="decrement",  id="form-count-down">❌</a>\
        </div>\
        <input value="${paddedNewFormCount}" autocomplete="off" type="hidden" name="menu[ingredients][[${newFormCount_back}]form_number]" id="menu_ingredients_[${newFormCount_back}]form_number">\
        <span class="form-number">${paddedNewFormCount}</span>\
        <input id="ingredient_name[${newFormCount_back}]" autofocus="autofocus" autocomplete="name" placeholder=" 食材名 (上限15文字)" maxlength="15" class="ingredient-name" value="" size="15" type="text" name="menu[ingredients][[${newFormCount_back}]name]">\
        <input type="text" id="ingredient_quantity[${newFormCount_back}]" name="menu[ingredients][[${newFormCount_back}]quantity]" autofocus="true" autocomplete="quantity" placeholder=" 数量" maxlength="4" oninput="this.value = this.value.replace(/[^0-9.]/g, '')" class="ingredient-quantity">\
        <select id="menu_ingredients_[${newFormCount_back}]unit" name="menu[ingredients][[${newFormCount_back}]unit]" class="ingredient-unit">\
          <option value="" selected>単位</option>\
          <option value="g">g</option>\
          <option value="kg">kg</option>\
          <option value="ml">ml</option>\
          <option value="L">L</option>\
          <option value="個">個</option>\
          <option value="枚">枚</option>\
          <option value="匹">匹</option>\
          <option value="切れ">切れ</option>\
          <option value="杯">杯</option>\
          <option value="缶">缶</option>\
          <option value="本">本</option>\
          <option value="袋">袋</option>\
          <option value="束">束</option>\
          <option value="合">合</option>\
          <option value="大さじ">大さじ</option>\
          <option value="小さじ">小さじ</option>\
        </select>\
      </div>`;

    formContainer.insertAdjacentHTML("beforeend", newForm);
    formCount_view++;
    formCount_back++;
  }
}

function updateFormNumbers() {
  var formContainers = document.querySelectorAll(".custom-ingredient-fields");
  formContainers.forEach(function (container, index) {
    // 各フォームの番号を更新
    var formNumber = container.querySelector(".form-number");
    if (formNumber) {
      var paddedFormNumber = (index + 1 < 10) ? '0' + (index + 1) : (index + 1);
      formNumber.textContent = paddedFormNumber;
    }
  });
}

function updateMaxCountText() {
  var formCountLimit = document.getElementById("formCountLimit");
  var countLimit = maxFormCount_view - formCount_view;
  formCountLimit.textContent = "+作成あと(" + countLimit + "個)";
}