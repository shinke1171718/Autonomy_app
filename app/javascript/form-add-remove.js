import jquery from "jquery"
window.$ = jquery

$(function() {
  var maxCount = 9;
  var formPlusButton = $('#ingredient-plus');
  var registrationField = $('.custom-ingredient-fields');
  var formContainer = $('.ingredient-form-container');
  var formCount = 0;

  formPlusButton.on('click', function() {
    // // maxCount以内の場合
    if (formCount < maxCount) {
      var newForm = $('<div class="custom-ingredient-fields">\
      <div id="ingredient-delete">\
        <a class="ingredient-delete-actions">❌</a>\
      </div>\
      <input type="text" name="ingredient_name[]" autofocus="true" autocomplete="name" placeholder=" 食材名 (上限15文字)" maxlength="15" class="ingredient-name">\
      <input type="text" name="ingredient_quantity[]" autofocus="true" autocomplete="quantity" placeholder=" 数量" maxlength="4" class="ingredient-quantity">\
      <select name="ingredient_unit[]" class="ingredient-unit">\
        <option value="" selected>単位</option>\
        <option value="g">g</option>\
        <option value="kg">kg</option>\
        <option value="ml">ml</option>\
        <!-- 他のオプションも同様に記述 -->\
      </select>\
    </div>');



      var newFormInputs = newForm.find('input, select');
      newFormInputs.each(function() {
        $(this).val('');
      });

      // $('.custom-ingredient-fields').last().after(newForm);
      formContainer.append(newForm);
      formCount++;
    }
  });

  $(document).on('click', '#ingredient-delete', function() {
    $(this).closest('.custom-ingredient-fields').remove();
    formCount--;
  });
});


