let searchResultsTitle = document.querySelector(".search_results_title");
let dropdownBg = document.getElementById('dropdownBackground');
let closeButton = document.querySelector('.close-button');
const searchResultsContainer = document.getElementById('searchResultsContainer');
const ingredientList = document.getElementById(`ingredient_select`);

document.addEventListener("turbo:load", function() {
  let ingredientName = null;
  const ingredient_form = document.getElementById("ingredient_form");
  const ingredientItems = ingredientList.querySelectorAll('li');
  const categoryElements = ingredientList.querySelectorAll('.ingredient-category p');
  const searchResultsDiv = document.createElement('div');
  ingredientList.insertBefore(searchResultsDiv, ingredientList.firstChild);
  const searchInput = document.getElementById('ingredientSearchInput');

  // フォーカスが発生したときにリストを展開
  ingredient_form.addEventListener("click", function(event) {
    const clickedElement = event.target;

    if (!clickedElement.classList.contains("ingredient-name")) return;

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
    searchResultsContainer.innerHTML = '';
    const searchText = searchInput.value.trim();

    if (searchText === '') {
      clearSearchResults();
      return;
    }

    ingredientItems.forEach(function(item) {
      const itemText = item.textContent.trim();
      const katakanaText = hiraganaToKatakana(searchText);

      if (normalizeAndCompare(katakanaText, itemText))  {
        handleSearchResult(itemText);
      }
    });

    showIngredientList();
  });

  // 食材を選んだらフォームに値をセットする
  ingredientList.addEventListener("click", function(e) {
    if (e.target.tagName !== 'LI') return;

    ingredientName.value = e.target.textContent.trim();
    closeDropdown()
  });

  // 検索した食材を選んだらフォームに値をセットする
  searchResultsContainer.addEventListener("click", function(e) {
    if (!searchResultsContainer) return;

    ingredientName.value = e.target.textContent.trim();
    closeDropdown()
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
  searchResultsContainer.appendChild(resultDiv);
}

// リストをnoneからblockへ変更
function showIngredientList() {
  ingredientList.style.display = "block";
}

// 文字列を正規化して比較する関数
function normalizeAndCompare(searchText, itemText) {
  const normalizedSearchText = normalizeText(searchText);
  const normalizedItemText = normalizeText(itemText);
  return normalizedItemText.includes(normalizedSearchText);
}

// テキストを正規化する関数
function normalizeText(text) {
  return text.toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "");
}

// ひらがなをカタカナに変換する関数
function hiraganaToKatakana(input) {
  return input.replace(/[\u3041-\u3096]/g, function(match) {
    const charCode = match.charCodeAt(0) + 0x60;
    return String.fromCharCode(charCode);
  });
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
  clearSearchResults();
}