import $ from 'jquery';

console.log("動いたよ");

document.addEventListener('turbo:load', function()  {
  var maxCount = 9;
  var formPlusButton = $('#ingredient-plus');
  var formContainer = $('.ingredient-form-container');
  var formCount = 0;

  formPlusButton.on('click', function() {
    if (formCount < maxCount) {
      var newForm = $('<div class="custom-ingredient-fields">\
      <div id="ingredient-delete">\
        <a class="ingredient-delete-actions">❌</a>\
      </div>\
      <input type="text" name="ingredient[][name]" autofocus="true" autocomplete="name" placeholder=" 食材名 (上限15文字)" maxlength="15" class="ingredient-name">\
      <input type="text" name="ingredient[][quantity]" autofocus="true" autocomplete="quantity" placeholder=" 数量" maxlength="4" class="ingredient-quantity">\
      <select name="ingredient[][unit]" class="ingredient-unit">\
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
      </select>\
    </div>');



      var newFormInputs = newForm.find('input[name="ingredient[][name]"], input[name="ingredient[][quantity]"], select[name="ingredient[][unit]"]');
      newFormInputs.each(function() {
        $(this).val('');
      });

      formContainer.append(newForm);
      formCount++;
    }
  });

  $(document).on('click', '#ingredient-delete', function() {
    $(this).closest('.custom-ingredient-fields').remove();
    formCount--;
  });
});