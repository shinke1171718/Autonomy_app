let searchResultsTitle = document.querySelector(".search-results-title");
let dropdownBg = document.getElementById('dropdownBackground');
let closeButton = document.querySelector('.close-button');
const searchResultsContainer = document.getElementById('searchResultsContainer');
const ingredientList = document.getElementById(`ingredient-select`);

document.addEventListener("turbo:load", function() {
  let ingredientName = null;
  let matchedItems = [];
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

    // 50音順にソート
    matchedItems.sort(function(a, b) {
      const aHiragana = a.getAttribute('data-hiragana');
      const bHiragana = b.getAttribute('data-hiragana');
      if (aHiragana < bHiragana) return -1;
      if (aHiragana > bHiragana) return 1;
      return 0;
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
    closeDropdown()
  });

  // 検索した食材を選んだらフォームに値をセットする
  searchResultsContainer.addEventListener("click", function(e) {
    if (!searchResultsContainer) return;

    matchedItems = [];
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
function katakanaToHiragana(src) {
  return src.replace(/[\u30a1-\u30f6]/g, function(match) {
    const chr = match.charCodeAt(0) - 0x60;
    return String.fromCharCode(chr);
  });
}

// ひらがなをカタカナに変換する関数
function hiraganaToKatakana(hiragana) {
  return hiragana.replace(/[\u3041-\u3096]/g, function(match) {
      const chr = match.charCodeAt(0) + 0x60;
      return String.fromCharCode(chr);
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