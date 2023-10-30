let searchResultsTitle = document.querySelector(".search-results-title");
let dropdownBg = document.getElementById('dropdownBackground');
let closeButton = document.querySelector('.close-button');
const searchResultsContainer = document.getElementById('searchResultsContainer');
const ingredientList = document.getElementById(`ingredient-select`);
const searchInput = document.getElementById('ingredientSearchInput');
const ingredient_form = document.getElementById("ingredient_form");
let validIngredients = [];

document.addEventListener("turbo:load", function() {
  let ingredientName = null;
  let matchedItems = [];

  const ingredientItems = ingredientList.querySelectorAll('li');
  const categoryElements = ingredientList.querySelectorAll('.ingredient-category p');
  const searchResultsDiv = document.createElement('div');
  ingredientList.insertBefore(searchResultsDiv, ingredientList.firstChild);


  // フォームの「食材フォーム」「単位フォーム」をクリックした場合の処理
  ingredient_form.addEventListener("click", function(event) {
    const clickedElement = event.target;
    if (!clickedElement.classList.contains("ingredient-name")) {
      handleIngredientUnitChange(clickedElement)
      return;
    }
    ingredientName = document.getElementById(clickedElement.id);
    if (!ingredientName) return;

    openDropdown();
    event.stopPropagation();
  });

  // クローズボタンでドロップダウンを非表示にする
  closeButton.addEventListener("click", closeDropdown);

  // フォーム入力で値を検索し、ヒットしたら表示する
  searchInput.addEventListener("keydown", function(e) {
    if (e.key !== "Enter") {
      return;
    }

    e.preventDefault();
    matchedItems = [];
    searchResultsContainer.innerHTML = '';
    const searchText = searchInput.value.trim();

    if (searchText === '') {
      clearSearchResults();
      return;
    }

    ingredientItems.forEach(function(item) {
      const itemHiragana = item.getAttribute('data-hiragana');
      const itemValue = item.getAttribute('data-value');

      // ひらがな前方一致（例：検索→さや 結果→さやえんどう）
      if (itemHiragana.startsWith(searchText)) {
        matchedItems.push(item);
        return;
      }

      // ひらがな部分一致（例：検索→どう 結果→さやえんどう）
      if (itemHiragana.includes(searchText)) {
        matchedItems.push(item);
        return;
      }

      // 漢字の前方一致（例：検索→大ば 結果→大場）
      if (itemValue.startsWith(searchText)) {
        matchedItems.push(item);
        return;
      }

      // 漢字の部分一致（例：検索→魚 結果→秋刀魚）
      if (itemValue.includes(searchText)) {
        matchedItems.push(item);
        return;
      }
    });

    // ソートされたアイテムを結果として表示
    matchedItems.forEach(function(item) {
      handleSearchResult(item.textContent.trim());
    });

    showIngredientList();
  });

  // 食材を選んだらフォームに値をセットする
  ingredientList.addEventListener("click", function(e) {
    if (e.target.tagName !== 'LI') return;

    matchedItems = [];
    ingredientName.value = e.target.textContent.trim();
    let parentElement = ingredientName.parentElement;
    let selectElement = parentElement.querySelector(".ingredient-unit");
    closeDropdown()

    handleIngredientNameChange(selectElement, ingredientName.value);
  });

  // 検索した食材を選んだらフォームに値をセットする
  searchResultsContainer.addEventListener("click", function(e) {
    if (!searchResultsContainer) return;

    // validIngredientsに該当する場合、処理をキャンセル
    if (validIngredients.includes(e.target.textContent.trim())) {
      e.preventDefault();
      return false;
    }

    matchedItems = [];
    ingredientName.value = e.target.textContent.trim();
    let parentElement = ingredientName.parentElement;
    let selectElement = parentElement.querySelector(".ingredient-unit");
    closeDropdown()

    handleIngredientNameChange(selectElement, ingredientName.value);
  });

  // 食材リストを表示/非表示に切り替える
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

  // ドロップダウンリストの各項目とフォームの内容を比較して一致するものがあるか確認
  ingredientName.addEventListener('blur', function() {
    const matchFound = Array.from(ingredientItems).some(item => item.textContent.trim() === ingredientName.value.trim());
    if (!matchFound) {
        ingredientName.value = '';
    }
  });
});


// 検索結果を非表示にする
function clearSearchResults() {
  searchResultsContainer.innerHTML = '';
  searchResultsTitle.style.display = "none";
}

// 検索結果を表示する
function handleSearchResult(itemText) {
  searchResultsTitle.style.display = "block";
  const resultDiv = document.createElement('div');
  resultDiv.textContent = itemText;
  resultDiv.classList.add('search-result-item');

  // validIngredientsの中に該当する値があるかチェック
  if (validIngredients.includes(itemText)) {
    resultDiv.style.opacity = '0.5';
  }

  searchResultsContainer.appendChild(resultDiv);
}

// リストをnoneからblockへ変更
function showIngredientList() {
  getAllIngredientTexts()
  ingredientList.style.display = "block";
}

// 全てのingredients-listを表示する
function openDropdown() {
  const categoryLists = document.querySelectorAll('.ingredient-category ul');
  categoryLists.forEach(list => {
    list.style.display = 'none';
  });

  dropdownBg.style.display = "block";
  ingredientList.style.display = "block";
  clearSearchResults();
}

// 全てのingredients-listの表示を非表示にする
function closeDropdown() {
  dropdownBg.style.display = "none";
  ingredientList.style.display = "none";
  searchInput.value = "";
  getAllIngredientTexts()
  clearSearchResults();
}

// ingredient_quantityに「少々」がセットされた時の処理
function handleIngredientUnitChange(clickedElement) {
  if (!clickedElement.matches(".ingredient-unit")) return;

  clickedElement.addEventListener('change', function() {
    const selectedOptionText = clickedElement.options[clickedElement.selectedIndex].textContent;
    const inputElement = clickedElement.closest('div').querySelector(".ingredient-quantity");
    if (selectedOptionText === "少々") {
        inputElement.value = "1";
        inputElement.setAttribute("readonly", true);
    } else {
      inputElement.value = "";
        inputElement.removeAttribute("readonly");
    }
  });
}

// 全てのingredientNameフォームのテキストデータを更新する関数
function getAllIngredientTexts() {
  let elements = document.querySelectorAll('.ingredient-name');
  let values = Array.from(elements).map(element => element.value);
  validIngredients = values.filter(value => value !== '');

  refreshIngredientList();
  return validIngredients;
}

// セットした値を再度入力できないように設定
function refreshIngredientList() {
  let ingredients = document.querySelectorAll('[data-value]');

  ingredients.forEach(ingredient => {
    if (validIngredients.includes(ingredient.getAttribute('data-value'))) {
        ingredient.style.opacity = '0.5';
        ingredient.style.pointerEvents = 'none';
    } else {
        ingredient.style.color = 'black';
        ingredient.style.pointerEvents = 'auto';
    }
  });
}

// 食材セット時にunitフォームへ専用の単位を設定する
function handleIngredientNameChange(selectElement, value) {
  const material_name = value;
  const userId = document.querySelector('.menu-registration-container').getAttribute('data-user-id');
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
    });
  });
}
