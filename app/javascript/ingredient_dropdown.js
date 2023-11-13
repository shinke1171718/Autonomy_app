let searchResultsTitle = document.querySelector(".search-results-title");
let dropdownBg = document.getElementById('dropdownBackground');
let closeButton = document.querySelector('.close-button');
const searchResultsContainer = document.getElementById('searchResultsContainer');
const ingredientList = document.getElementById(`ingredient-select`);
const searchInput = document.getElementById('ingredientSearchInput');
const ingredient_form = document.getElementById("ingredient_form");
let selectedUnits = [];
let ingredientUnitMapping = {};

document.addEventListener("turbo:load", function() {
  let ingredientName = null;
  let matchedItems = [];
  const ingredientItems = ingredientList.querySelectorAll('li');
  const categoryElements = ingredientList.querySelectorAll('.ingredient-category p');
  const searchResultsDiv = document.createElement('div');
  const ingredientForm = document.querySelector('#ingredient_form');
  ingredientList.insertBefore(searchResultsDiv, ingredientList.firstChild);

  // フォームの「食材フォーム」「単位フォーム」をクリックした場合の処理
  ingredient_form.addEventListener("click", function(event) {
    const clickedElement = event.target;

    if (clickedElement.classList.contains("ingredient-quantity")) return;
    if (clickedElement.classList.contains("form-count-down")) return;

    // 食材名以外の要素がクリックされた場合、単位変更ハンドラーを呼び出します。
    if (clickedElement.classList.contains("ingredient-unit")) {
      handleIngredientUnitChange(clickedElement);
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
  let searchTimer;
  searchInput.addEventListener("input", function(e) {
    // タイマーが既に設定されている場合はクリア
    if (searchTimer) {
      clearTimeout(searchTimer);
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

      // ひらがな前方一致
      if (itemHiragana.startsWith(searchText)) {
        matchedItems.push(item);
        return;
      }

      // ひらがな部分一致
      if (itemHiragana.includes(searchText)) {
        matchedItems.push(item);
        return;
      }

      // 漢字の前方一致
      if (itemValue.startsWith(searchText)) {
        matchedItems.push(item);
        return;
      }

      // 漢字の部分一致
      if (itemValue.includes(searchText)) {
        matchedItems.push(item);
        return;
      }
    });

    // ソートされたアイテムを結果として表示
    matchedItems.forEach(function(item) {
      const itemText = item.textContent.trim();
      searchResultsTitle.style.display = "block";
      const resultDiv = document.createElement('div');
      resultDiv.textContent = itemText;
      resultDiv.classList.add('search-result-item');
      searchResultsContainer.appendChild(resultDiv);
    });

    ingredientList.style.display = "block";

    // 3秒後に処理を終了
    searchTimer = setTimeout(() => {
      clearSearchResults();
    }, 3000);
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
    closeDropdown()
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
});


// 検索結果を非表示にする
function clearSearchResults() {
  searchResultsContainer.innerHTML = '';
  searchResultsTitle.style.display = "none";
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
  clearSearchResults();
}

// ingredient_quantityに「少々」がセットされた時の処理
function handleIngredientUnitChange(clickedElement) {
  clickedElement.addEventListener('change', function() {
    const selectedOptionText = clickedElement.options[clickedElement.selectedIndex].textContent;
    const inputElement = clickedElement.closest('div').querySelector(".ingredient-quantity");
    if (selectedOptionText === "少々") {
      inputElement.style.backgroundColor = "#e0e0e0";
      inputElement.style.pointerEvents = "none";
      inputElement.setAttribute("readonly", true);
      inputElement.setAttribute("tabindex", "-1");
      inputElement.placeholder = "";
    } else {
      inputElement.style.backgroundColor = "";
      inputElement.style.pointerEvents = "";
      inputElement.removeAttribute("readonly");
      inputElement.removeAttribute("tabindex");
      inputElement.placeholder = "数量";
    }

    updateAndRerunProcesses()
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
      selectElement.style.pointerEvents = 'auto';
      selectElement.removeAttribute('tabindex');
      updateAndRerunProcesses()
    });
  });
}

// すべてのユニットオプションをリセットし、各食材名に対してユニットオプションを更新する
function updateAndRerunProcesses() {
  const ingredientNames = document.querySelectorAll('.ingredient-name');

  // すべてのユニットオプションをリセットする
  document.querySelectorAll('.ingredient-unit option').forEach(option => {
    option.disabled = false;
    option.style.opacity = "1";
  });

  // 各食材名に対してユニットオプションを更新する
  ingredientNames.forEach(ingredientElement => {
    if (ingredientElement.value.trim() === "") return;

    let parentElement = ingredientElement.parentElement;
    const selectedIngredient = ingredientElement.value;
    const unitElement = parentElement.querySelector(".ingredient-unit");
    const selectedUnit = unitElement.value;

    // 同じ食材名を持つ要素を取得
    const matchingIngredients = Array.from(ingredientNames).filter(elem => elem !== ingredientElement && elem.value === selectedIngredient);
    // 対応するユニットオプションを無効にし、必要に応じて値をリセットする
    matchingIngredients.forEach(matchingIngredient => {
      const parentElement = matchingIngredient.parentElement;
      const unitElement = parentElement.querySelector(".ingredient-unit");
      const optionElems = Array.from(unitElement.querySelectorAll('option'));

      optionElems.forEach(option => {
        if (option.value !== selectedUnit) return;
        option.disabled = true;
        option.style.opacity = "0.5";
        if (unitElement.value !== selectedUnit) return;
        unitElement.value = "";
      });
    });
  });
}
