let formCount_view = 0;
let formCount_back = -1;
let maxFormCount_view = 15;

updateForm()

let count_up_bottom = document.getElementById("form-count-up");
if (count_up_bottom) {
  count_up_bottom.addEventListener("click", function(event) {
    event.preventDefault();
    createNewForm();
    updateMaxCountText(formCount_view, maxFormCount_view)
  });
}

document.addEventListener("DOMContentLoaded", function() {
  document.addEventListener("click", function(event) {
    if (!event.target.classList.contains("form-count-down")) return;

    event.preventDefault();

    let container = event.target.closest(".custom-ingredient-fields");
    if (!container) return;

    container.remove();
    formCount_view--;
    formCount_back--;
    updateFormNumbers();
    updateMaxCountText(formCount_view, maxFormCount_view)
  });
});


function createNewForm() {
  let ingredient_form = document.getElementById("ingredient_form");
  let newFormCount_view = formCount_view + 1;
  let paddedNewFormCount = newFormCount_view < 10 ? '0' + newFormCount_view : newFormCount_view;
  paddedNewFormCount = paddedNewFormCount.toString().padStart(2, '0');

  let newFormCount_back = formCount_back + 1;

  if (formCount_view < maxFormCount_view) {
    let newForm = `
      <div class="custom-ingredient-fields">
        <div class="form-delete-button">
          <a href="#" class="form-count-down" data-action="decrement",  id="form-count-down[${newFormCount_back}]">❌</a>
        </div>
        <span class="form-number">${paddedNewFormCount}</span>
        <input id="ingredient_name[${newFormCount_back}]" class="ingredient-name" placeholder="食材名を選択" type="text" name="menu[ingredients][${newFormCount_back}][material_name]" readonly>
        <input type="hidden" id="ingredient_id[${newFormCount_back}]" name="menu[ingredients][${newFormCount_back}][material_id]", class="hidden-ingredient-id">
        <input type="text" id="ingredient_quantity[${newFormCount_back}]" name="menu[ingredients][${newFormCount_back}][quantity]" autocomplete="quantity" placeholder="数量" maxlength="4" oninput="this.value = this.value.replace(/[^0-9.]/g, '')" class="ingredient-quantity">
        <select id="menu_ingredients_unit[${newFormCount_back}]" name="menu[ingredients][${newFormCount_back}][unit_id]" class="ingredient-unit" tabindex="-1">
        </select>
      </div>`;

    ingredient_form.insertAdjacentHTML("beforeend", newForm);
    formCount_view++;
    formCount_back++;
  }
}

function updateFormNumbers() {
  let formContainers = document.querySelectorAll(".custom-ingredient-fields");
  formContainers.forEach(function (container, index) {
    let formNumber = container.querySelector(".form-number");
    if (formNumber) {
      let paddedFormNumber = (index + 1 < 10) ? '0' + (index + 1) : (index + 1);
      formNumber.textContent = paddedFormNumber;
    }
  });
}

function updateMaxCountText(formCount_view, maxFormCount_view) {
  let formCountLimit = document.getElementById("formCountLimit");
  let countLimit = maxFormCount_view - formCount_view;
  formCountLimit.textContent = "+作成あと(" + countLimit + "個)";
}

function createNewForms(defaultMaxCount, Data){
  for (let i = 0; i < defaultMaxCount ; i++) {
    createNewForm();

    if (!Data || !Data[i]) continue;
    let currentData = Data[i];
    let currentForm = document.querySelectorAll('.custom-ingredient-fields')[i];

    let ingredientNameField = currentForm.querySelector(`#ingredient_name\\[${i}\\]`);
    let ingredientIdField = currentForm.querySelector(`#ingredient_id\\[${i}\\]`);
    let ingredientQuantityField = currentForm.querySelector(`#ingredient_quantity\\[${i}\\]`);

    // // 材料名、数量、単位IDを設定
    if (ingredientNameField) {
      // readonly 属性を一時的に解除
      ingredientNameField.removeAttribute('readonly');
      // 値を設定
      ingredientNameField.value = currentData.material_name || '';
      // 再び readonly 属性を設定
      ingredientNameField.setAttribute('readonly', true);
    }

    if (ingredientIdField) ingredientIdField.value = currentData.material_id || '';
    if (ingredientQuantityField) ingredientQuantityField.value = currentData.quantity || '';

    let ingredientUnitSelect = currentForm.querySelector(`#menu_ingredients_unit\\[${i}\\]`);
    if (ingredientUnitSelect) {
      // 単位のセットアップ（ingredient_dropdown.jsにコードあります。）
      handleIngredientNameChange(ingredientUnitSelect, currentData.material_name);

      // 既に選択されている単位IDがあれば、それを選択する
      setTimeout(() => {
        ingredientUnitSelect.value = currentData.unit_id || '';
      }, 500);
    }
  }
  updateMaxCountText(formCount_view, maxFormCount_view)
}

function updateForm(){
  let ingredientsDate = document.getElementById('ingredientsDate');
  // data-ingredients 属性の値を取得
  let dataAttr = ingredientsDate.getAttribute('data-ingredients');
  // JSON文字列をオブジェクトに変換
  let parsedIngredients = JSON.parse(dataAttr);
  // オブジェクトのすべての値を取得し、null値をフィルタリング
  let formCount = Object.values(parsedIngredients).filter(value => value !== null).length;

  if (formCount >= 1) {
    const maxCount = formCount
    createNewForms(maxCount, parsedIngredients)
  }else{
    const maxCount = 5
    createNewForms(maxCount, parsedIngredients)
  }
}