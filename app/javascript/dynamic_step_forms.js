// 現在のビューにおけるフォームの数を追跡するカウンター。
// このカウンターは、新しいフォーム要素が追加されるたびに増加します。
var INITIAL_FORM_COUNT_VIEW = 0;
// バックエンドにおけるフォームの数を追跡するためのカウンター。
// -1から始まり、新しいフォーム要素が追加されるたびに増加します。
// これは通常、フォーム要素の一意のID生成などに使用されます。
var INITIAL_FORM_COUNT_BACK = -1;
// ビューに表示可能なフォームの最大数。
// この数値は、ユーザーが追加できるフォーム要素の上限を定義します。
var MAX_FORM_COUNT_VIEW = 15;
// ユーザー表示用のオフセット値（1始まりのカウント用）
var FORM_INDEX_OFFSET = 1;
// 二桁表示が必要になる数値のしきい値（9を超えたら二桁が必要）
var TWO_DIGIT_DISPLAY_THRESHOLD = 10;
// デフォルトで表示されるフォームの最大数
var DEFAULT_MAX_FORM_COUNT = 3;
// 工程未登録時に生成するフォームの数
var INGREDIENT_NO_FORM_STEPS_COUNT = 0;
// フォームが少なくとも1つ存在することを示す最小フォームカウント
var INGREDIENT_MIN_FORM_STEPS_COUNT = 1;

var stepFormCountView = INITIAL_FORM_COUNT_VIEW;
var stepFormCountBack = INITIAL_FORM_COUNT_BACK;
var maxStepFormCountView = MAX_FORM_COUNT_VIEW;

updateStepForm()

var step_count_up_bottom = document.getElementById("step-form-count-up");
if (step_count_up_bottom) {
  step_count_up_bottom.addEventListener("click", function(event) {
    event.preventDefault();
    createNewStepForm()
    updateMaxStepCountText(stepFormCountView, maxStepFormCountView)
  });
}

document.addEventListener("click", function(event) {
  if (event.target.classList.contains("step-form-count-down")) {
    handleStepCountDownClick(event);
  }
});

function updateStepForm(){
  const maxStepCount = DEFAULT_MAX_FORM_COUNT;
  let stepsDate = document.getElementById('steps-date');
  // data-ingredients 属性の値を取得
  let stepsDataAttribute = stepsDate.getAttribute('data-steps');
  // JSON文字列をオブジェクトに変換
  let parsedSteps = JSON.parse(stepsDataAttribute);

  // 食材未登録の状態で確認画面へ移動し、そこから再編集で入力画面に戻った時の処理
  if (parsedSteps === null) {
    createNewStepForms(maxStepCount)
    return;
  }

  // parsedSteps から null でない値のみを抽出し、その数をカウント
  let formStepCount = Object.values(parsedSteps).filter(value => value !== null).length;
  // 最小フォームカウント：この値は、フォームが存在している（つまりフォームの数が0より大きい）ことを確認するために使用される。
  // 1は、少なくとも1つのフォームが存在することを意味し、この条件を満たした場合のみフォームの再作成を行う。
  const minFormStepCount = INGREDIENT_MIN_FORM_STEPS_COUNT;
  // menuを設定された状態で確認画面へ移動し、そこから再編集で入力画面に戻った時の処理
  if (formStepCount >= minFormStepCount) {
    // 編集時に設定されていたフォームの数を設定
    const StepCount = formStepCount
    createNewStepForms(StepCount, parsedSteps)

  // 新規で登録フォームを表示する場合の処理
  }else{
    // 新規で登録フォームを表示する場合、デフォルトのフォーム数（ここでは5）を設定してフォームを生成
    const defaultStepCount = DEFAULT_MAX_FORM_COUNT
    createNewStepForms(defaultStepCount, parsedSteps)
  }
}

function createNewStepForms(createFormCount, Data){
  for (var i = 0; i < createFormCount ; i++) {
    createNewStepForm()
    // Dataが存在しない、またはData[i]が存在しない場合、以降の処理をスキップ
    if (!Data || !Data[i]) continue;
    let currentStepData = Data[i];
    let currentStepForm = document.querySelectorAll('.step-form-field')[i];
    // ステップカテゴリIDを取得するためのセレクタ
    let stepCategoryField = currentStepForm .querySelector(`#recipe_step_category_id\\[${i}\\]`);
    // ステップの説明を取得するためのセレクタ
    let stepDescriptionField = currentStepForm .querySelector(`#recipe_steps_description\\[${i}\\]`);

    // ステップカテゴリIDを設定
    if (stepCategoryField && currentStepData.recipe_step_category_id) {
      stepCategoryField.value = currentStepData.recipe_step_category_id;
    }

    // ステップの説明を設定
    if (stepDescriptionField && currentStepData.description) {
      stepDescriptionField.value = currentStepData.description;
    }
  }
  updateMaxStepCountText(stepFormCountView, maxStepFormCountView)
}

// フォームにあるフォーム追加ボタンで表示されるカウントについての処理
function updateMaxStepCountText(stepFormCountView, maxStepFormCountView) {
  // formCountLimit 要素を取得
  let stepFormCountLimit = document.getElementById("step-form-count-limit");

  // 作成可能なフォームの残り数を計算
  let stepCountLimit = maxStepFormCountView - stepFormCountView;

  // formCountLimit 要素のテキストを更新して、残りのフォーム数を表示
  stepFormCountLimit.textContent = "+工程追加(あと" + stepCountLimit + "個)";
}


function createNewStepForm() {
  const displayOffset = FORM_INDEX_OFFSET;
  let newFormCount_view = stepFormCountView + displayOffset;

  let stepFormCount_Back = stepFormCountBack + displayOffset;

  const twoDigitThreshold = TWO_DIGIT_DISPLAY_THRESHOLD;
  let paddedNewFormCount = newFormCount_view < twoDigitThreshold ? '0' + newFormCount_view : newFormCount_view;

  // 新しいフォームのHTML構造
  // 新しいフォームのHTMLを生成
  let newFormHtml = `
    <div class="step-form-container">
      <div id="step-error[${stepFormCount_Back}]" class="step-error-message"></div>
      <div class="step-form-field">

        <div class="step-delete-button">
          <a href="#" class="step-form-count-down" data-action="decrement",  id="step-form-count-down[${stepFormCount_Back}]">❌</a>
        </div>

        <div class="step-field-wrapper">
          <div class="step-form-number">
            ${paddedNewFormCount}
          </div>

          <div class="step-fields">
            <div class="step-category-dropdown">
              <select id="recipe_step_category_id[${stepFormCount_Back}]" name="menu[recipe_steps][${stepFormCount_Back}][recipe_step_category_id]" class="select-dropdown">
                <option value="">工程ジャンルを選択</option>
                <option value="1">野菜の下準備（切る/剥くなど）</option>
                <option value="2">肉の下準備（切る/解凍など）</option>
                <option value="3">その他の下準備（切る/解凍など）</option>
                <option value="4">調理（焼く/煮る/蒸すなど）</option>
                <option value="5">その他（混ぜる/盛り付けなど）</option>
              </select>
            </div>
            <div class="step-description">
              <textarea id="recipe_steps_description[${stepFormCount_Back}]" name="menu[recipe_steps][${stepFormCount_Back}][description]" class="text-field" placeholder="メモ（最大60文字）" rows="2"></textarea>
            </div>
          </div>
        </div>
      </div>
    </div>
  `;

  // IDが'step_form'の要素に新しいフォームを追加
  let stepFormContainer = document.getElementById("step_form");
  stepFormContainer.insertAdjacentHTML('beforeend', newFormHtml);

  // ビューとバックエンドの両方のカウンターを増やす
  stepFormCountView++;
  stepFormCountBack++;
}

function handleStepCountDownClick(event) {
  event.preventDefault();

  // クリックされた要素の最も近い ".step-form-field" 要素を取得
  let container = event.target.closest(".step-form-field");
  if (!container) return;

  container.remove(); // 該当する要素を削除
  stepFormCountView--; // 表示中のフォーム数をデクリメント
  stepFormCountBack--; // バックエンド用のフォーム数をデクリメント
  updateStepFormNumbers(); // フォーム番号を更新
  updateMaxStepCountText(stepFormCountView, maxStepFormCountView) // 最大フォーム数テキストを更新
}

function updateStepFormNumbers() {
  let formField = document.querySelectorAll(".step-form-field");
  formField.forEach(function (container, index) {
    let formNumber = container.querySelector(".step-form-number");

    // 配列のインデックスは0から始まるが、ユーザーには1から数える形で表示するための調整
    const displayOffset = FORM_INDEX_OFFSET;
    const twoDigitThreshold = TWO_DIGIT_DISPLAY_THRESHOLD;

    // formNumber が存在しない場合は処理終了
    if (!formNumber) return;

    // indexに1を加えた値が twoDigitThreshold 未満の場合は先頭に0を付けて2桁に、そうでなければそのままの値を paddedFormNumber に格納
    let paddedFormNumber = (index + displayOffset < twoDigitThreshold) ? '0' + (index + displayOffset) : (index + displayOffset).toString();
    // formNumber 要素のテキスト内容を paddedFormNumber で更新
    formNumber.textContent = paddedFormNumber;
  });
}
