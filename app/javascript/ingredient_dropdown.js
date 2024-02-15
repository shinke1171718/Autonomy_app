
// 'click'イベントをingredient_formに追加し、クリックがあるたびに関数を実行
ingredient_form.addEventListener("click", function(event) {
  // 材料選択のドロップダウン要素を取得
  let ingredientList = document.getElementById(`ingredient-select`);
  // ドロップダウンの背景要素を取得
  let dropdownBg = document.getElementById('dropdownBackground');
  // 検索結果のタイトル要素を取得
  let searchResultsTitle = document.querySelector(".search-results-title");
  const clickedElement = event.target;

  // クリックされた要素が「材料量の入力フィールド」「数量減少ボタン」であれば処理を終了
  if (clickedElement.classList.contains("ingredient-quantity")) return;
  if (clickedElement.classList.contains("form-count-down")) return;

  // クリックされた要素が材料単位の選択肢であれば処理を行い終了
  if (clickedElement.classList.contains("ingredient-unit")) {
    handleIngredientUnitChange(clickedElement);
    return;
  }

  // クリックされた要素に対応する材料名の要素を取得
  ingredientName = document.getElementById(clickedElement.id);
  if (!ingredientName) return;
  // ドロップダウンを開く処理を実行
  openDropdown(ingredientList, dropdownBg, searchResultsTitle);
  event.stopPropagation();
  // 検索入力フィールドを取得
  const searchInput = document.getElementById('ingredientSearchInput');

  // searchInputの中にエンターで別のアクションを発生させないための処理
  searchInput.addEventListener("keydown", function(event) {
    if (event.key === "Enter") {
        event.preventDefault();
    }
  });

  // 'input'イベントをsearchInputに追加し、入力があるたびに関数を実行
  searchInput.addEventListener("input", function(e) {
    // 材料リストからすべてのリストアイテムを取得
    const ingredientItems = ingredientList.querySelectorAll('li');

    e.preventDefault();
    // 一致したアイテムを保持する配列を初期化
    matchedItems = [];
    // 検索結果コンテナの内容を空にする
    searchResultsContainer.innerHTML = '';
    // 入力された検索テキストを取得し、前後の空白を削除
    const searchText = searchInput.value.trim();

    // 検索テキストが空の場合、検索結果をクリアして処理を終了
    if (searchText === '') {
      clearSearchResults(searchResultsTitle);
      return;
    }

    // 各材料アイテムに対してループ処理
    ingredientItems.forEach(function(item) {
      // アイテムのひらがなデータを取得
      const itemHiragana = item.getAttribute('data-hiragana');
      // アイテムの漢字データを取得
      const itemValue = item.getAttribute('data-material-name');

      // 検索テキストでひらがなが前方一致する場合、アイテムを配列に追加
      if (itemHiragana.startsWith(searchText)) {
        matchedItems.push(item);
        return;
      }

      // 検索テキストでひらがなが部分一致する場合、アイテムを配列に追加
      if (itemHiragana.includes(searchText)) {
        matchedItems.push(item);
        return;
      }

      // 検索テキストで漢字が前方一致する場合、アイテムを配列に追加
      if (itemValue.startsWith(searchText)) {
        matchedItems.push(item);
        return;
      }

      // 検索テキストで漢字が部分一致する場合、アイテムを配列に追加
      if (itemValue.includes(searchText)) {
        matchedItems.push(item);
        return;
      }
    });

    // ソートされたアイテムを結果として表示
    matchedItems.forEach(function(item) {
      // アイテムのテキストを取得し、トリミング
      const itemText = item.textContent.trim();
      searchResultsTitle.style.display = "block";
      // 新しいdiv要素を作成し、検索結果アイテムとして設定
      const resultDiv = document.createElement('div');
      resultDiv.textContent = itemText;
      resultDiv.classList.add('search-result-item');

      // material_idを取得してdate要素として追加
      const dataValue = item.getAttribute('data-value');
      resultDiv.setAttribute('data-value', dataValue);

      // 作成したdivを検索結果コンテナに追加
      searchResultsContainer.appendChild(resultDiv);
    });

    // 材料リストを表示
    ingredientList.style.display = "block";
  });

  // 食材を選んだらフォームに値をセットする
  ingredientList.addEventListener("click", function(e) {
    if (e.target.tagName !== 'LI') return;
    matchedItems = [];

    let parentElement = ingredientName.parentElement;
    ingredientName.value = e.target.textContent.trim();

    let hiddenElement = parentElement.querySelector(".hidden-ingredient-id");
    hiddenElement.value = e.target.getAttribute('data-value');

    let selectElement = parentElement.querySelector(".ingredient-unit");
    closeDropdown(ingredientList, searchInput, dropdownBg, searchResultsTitle)
    handleIngredientNameChange(selectElement, ingredientName.value);
  });

  // 検索した食材を選んだらフォームに値をセットする
  searchResultsContainer.addEventListener("click", function(e) {
    if (!searchResultsContainer) return;

    matchedItems = [];
    let parentElement = ingredientName.parentElement;
    ingredientName.value = e.target.textContent.trim();

    let hiddenElement = parentElement.querySelector(".hidden-ingredient-id");
    hiddenElement.value = e.target.getAttribute('data-value');

    let selectElement = parentElement.querySelector(".ingredient-unit");
    closeDropdown(ingredientList, searchInput, dropdownBg, searchResultsTitle)
    handleIngredientNameChange(selectElement, ingredientName.value);
  });
});

document.body.addEventListener("click", function(event) {
  let ingredientList = document.getElementById('ingredient-select');
  const searchInput = document.getElementById('ingredientSearchInput');
  let dropdownBg = document.getElementById('dropdownBackground');
  let searchResultsTitle = document.querySelector(".search-results-title");

  // クローズボタンまたは背景がクリックされたか確認
  if (event.target.matches('.close-icon') || event.target === dropdownBg) {
    closeDropdown(ingredientList, searchInput, dropdownBg, searchResultsTitle);
  }
});

selectCategory()


function clearSearchResults(searchResultsTitle) {
  searchResultsContainer.innerHTML = '';
  searchResultsTitle.style.display = "none";
}

// 全てのingredients-listを表示する
function openDropdown(ingredientList, dropdownBg, searchResultsTitle) {
  const categoryLists = document.querySelectorAll('.ingredient-category ul');
  categoryLists.forEach(list => {
    list.style.display = 'none';
  });

  dropdownBg.style.display = "block";
  ingredientList.style.display = "block";
  clearSearchResults(searchResultsTitle);
  document.body.style.overflow = 'hidden';
}

// 全てのingredients-listの表示を非表示にする
function closeDropdown(ingredientList, searchInput, dropdownBg, searchResultsTitle) {
  dropdownBg.style.display = "none";
  ingredientList.style.display = "none";
  searchInput.value = "";
  clearSearchResults(searchResultsTitle);
  document.body.style.overflow = '';
}

// ingredient_unitに値が変更された時の処理
function handleIngredientUnitChange(clickedElement) {
  clickedElement.addEventListener('change', function() {
    if (clickedElement.selectedIndex < 0) return;
    const selectedOptionText = clickedElement.options[clickedElement.selectedIndex].textContent;
    const inputElement = clickedElement.closest('div').querySelector(".ingredient-quantity");

    // ingredient_unitに「少々」がセットされた時の処理
    if (selectedOptionText === "少々") {
      inputElement.style.backgroundColor = "#e0e0e0";
      inputElement.style.pointerEvents = "none";
      inputElement.setAttribute("readonly", true);
      inputElement.setAttribute("tabindex", "-1");
      inputElement.value = "";
      inputElement.placeholder = "";
    } else {
      inputElement.style.backgroundColor = "";
      inputElement.style.pointerEvents = "";
      inputElement.removeAttribute("readonly");
      inputElement.removeAttribute("tabindex");
      inputElement.placeholder = "数量";
    }
  });
}

// 食材セット時にunitフォームへ専用の単位を設定する（addForm.jsでも使用しています。）
function handleIngredientNameChange(selectElement, value) {
  const material_name = value;
  const userId = document.querySelector('.menu-form-container').getAttribute('data-user-id');
  const token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

  const url = `/users/${userId}/menus/units`;
  fetch(url, {
    method: 'POST',
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'X-CSRF-Token': token
    },
    body: JSON.stringify({ material_name: material_name })
  })
  .then(response => response.json())
  .then(data => {

    while (selectElement.firstChild) {
      selectElement.removeChild(selectElement.firstChild);
    }

    data.forEach(item => {
      const option = document.createElement('option');
      option.value = item.id;
      option.textContent = item.name;
      selectElement.appendChild(option);
      selectElement.style.pointerEvents = 'auto';
      selectElement.removeAttribute('tabindex');
    });
  });
}

// 食材リストを表示/非表示に切り替える
function selectCategory(){
  let ingredientList = document.getElementById('ingredient-select');
  const categoryElements = ingredientList.querySelectorAll('.ingredient-category p');
  categoryElements.forEach((categoryElement, index) => {
    categoryElement.addEventListener("click", function() {
      const ulElement = document.getElementById(`ingredients-list-${index}`);

      if (ulElement.style.display === "none") {
        ulElement.style.display = "block";
      } else {
        ulElement.style.display = "none";
      }
    });
  });
}