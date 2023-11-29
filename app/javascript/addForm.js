// formCount_view: 現在のビューにおけるフォームの数を追跡するカウンター。
// このカウンターは、新しいフォーム要素が追加されるたびに増加します。
var formCount_view = 0;

// formCount_back: バックエンドにおけるフォームの数を追跡するためのカウンター。
// -1から始まり、新しいフォーム要素が追加されるたびに増加します。
// これは通常、フォーム要素の一意のID生成などに使用されます。
var formCount_back = -1;

// maxFormCount_view: ビューに表示可能なフォームの最大数。
// この数値は、ユーザーが追加できるフォーム要素の上限を定義します。
var maxFormCount_view = 15;

updateForm()

var count_up_bottom = document.getElementById("form-count-up");
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

    // クリックされた要素の最も近い ".custom-ingredient-fields" 要素を取得
    var container = event.target.closest(".custom-ingredient-fields");
    if (!container) return;

    container.remove(); // 該当する要素を削除
    formCount_view--; // 表示中のフォーム数をデクリメント
    formCount_back--; // バックエンド用のフォーム数をデクリメント
    updateFormNumbers(); // フォーム番号を更新
    updateMaxCountText(formCount_view, maxFormCount_view) // 最大フォーム数テキストを更新
  });
});


function createNewForm() {
  var ingredient_form = document.getElementById("ingredient_form");

  // 配列のインデックスは0から始まるが、ユーザーには1から数える形で表示するための調整
  const displayOffset = 1;
  var newFormCount_view = formCount_view + displayOffset;

  // 2桁表示のためのしきい値。この値未満の場合、先頭に0を付ける
  const twoDigitThreshold = 10;
  var paddedNewFormCount = newFormCount_view < twoDigitThreshold ? '0' + newFormCount_view : newFormCount_view;

  // 文字列をパディングするための目標の長さ
  const targetLength = 2;
  paddedNewFormCount = paddedNewFormCount.toString().padStart(targetLength, '0');

  // インデックスまたはカウントを1増やすための調整値（元々formCount_backは「-1」であるためです。）
  const increment = 1;
  var newFormCount_back = formCount_back + increment;


  if (formCount_view < maxFormCount_view) {
    var newForm = `
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
  var formContainers = document.querySelectorAll(".custom-ingredient-fields");
  formContainers.forEach(function (container, index) {
    var formNumber = container.querySelector(".form-number");

    // 2桁表示のためのしきい値。この値未満の場合、先頭に0を付ける
    const twoDigitThreshold = 10;

    // 配列のインデックスは0から始まるが、ユーザーには1から数える形で表示するための調整
    const displayOffset = 1;

    // formNumber が存在しない場合は処理終了
    if (!formNumber) return;

    // indexに1を加えた値が twoDigitThreshold 未満の場合は先頭に0を付けて2桁に、そうでなければそのままの値を paddedFormNumber に格納
    var paddedFormNumber = (index + displayOffset < twoDigitThreshold) ? '0' + (index + displayOffset) : (index + displayOffset).toString();
    // formNumber 要素のテキスト内容を paddedFormNumber で更新
    formNumber.textContent = paddedFormNumber;
  });
}

// フォームにあるフォーム追加ボタンで表示されるカウントについての処理
function updateMaxCountText(formCount_view, maxFormCount_view) {
  // formCountLimit 要素を取得
  var formCountLimit = document.getElementById("formCountLimit");

  // 作成可能なフォームの残り数を計算
  var countLimit = maxFormCount_view - formCount_view;

  // formCountLimit 要素のテキストを更新して、残りのフォーム数を表示
  formCountLimit.textContent = "+作成あと(" + countLimit + "個)";
}

function createNewForms(defaultMaxCount, Data){
  for (var i = 0; i < defaultMaxCount ; i++) {
    createNewForm();

    // Dataが存在しない、またはData[i]が存在しない場合、以降の処理をスキップ
    if (!Data || !Data[i]) continue;
    var currentData = Data[i];
    var currentForm = document.querySelectorAll('.custom-ingredient-fields')[i];

    var ingredientNameField = currentForm.querySelector(`#ingredient_name\\[${i}\\]`);
    var ingredientIdField = currentForm.querySelector(`#ingredient_id\\[${i}\\]`);
    var ingredientQuantityField = currentForm.querySelector(`#ingredient_quantity\\[${i}\\]`);

    // 材料名、数量、単位IDを設定
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

    var ingredientUnitSelect = currentForm.querySelector(`#menu_ingredients_unit\\[${i}\\]`);
    if (ingredientUnitSelect) {
      // 単位のセットアップ（ingredient_dropdown.jsにコードあります。）
      handleIngredientNameChange(ingredientUnitSelect, currentData.material_name);

      // 選択された単位IDを適用するための遅延。DOMの更新後に単位を設定するために必要。
      const unitSelectionDelay = 500;

      // 既に選択されている単位IDがあれば、それを選択する
      // この処理には動的フォーム作成＋単位設定処理を行った後に処理される必要があるため、あえて遅延させています。
      setTimeout(() => {
        ingredientUnitSelect.value = currentData.unit_id || '';
      }, unitSelectionDelay);
    }
  }
  updateMaxCountText(formCount_view, maxFormCount_view)
}

function updateForm(){
  var ingredientsDate = document.getElementById('ingredientsDate');
  // data-ingredients 属性の値を取得
  var dataAttr = ingredientsDate.getAttribute('data-ingredients');
  // JSON文字列をオブジェクトに変換
  var parsedIngredients = JSON.parse(dataAttr);

  // 食材未登録の状態で確認画面へ移動し、そこから再編集で入力画面に戻った時の処理
  if (parsedIngredients === null) {
    // maxCount: 新しく生成するフォームの数を指定。
    // ここでは食材が未登録のため、0に設定してフォームを生成しない。
    const maxCount = 0;
    createNewForms(maxCount, {});
    return;
  }

  // parsedIngredients から null でない値のみを抽出し、その数をカウント
  var formCount = Object.values(parsedIngredients).filter(value => value !== null).length;

  // 最小フォームカウント：この値は、フォームが存在している（つまりフォームの数が0より大きい）ことを確認するために使用される。
  // 1は、少なくとも1つのフォームが存在することを意味し、この条件を満たした場合のみフォームの再作成を行う。
  const minFormCount = 1;

  // 献立を設定された状態で確認画面へ移動し、そこから再編集で入力画面に戻った時の処理
  if (formCount >= minFormCount) {
    const maxCount = formCount
    createNewForms(maxCount, parsedIngredients)

  // 新規で登録フォームを表示する場合の処理
  }else{
    // 新規で登録フォームを表示する場合、デフォルトのフォーム数（ここでは5）を設定してフォームを生成
    const maxCount = 5
    createNewForms(maxCount, parsedIngredients)
  }
}