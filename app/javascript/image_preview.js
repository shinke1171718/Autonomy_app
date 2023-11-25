createPreview()

function createPreview() {
  var imageInput = document.getElementById('menu_image');
  console.log(imageInput);

  if (imageInput) {
    imageInput.addEventListener('change', function(event) {
      let file = event.target.files[0];
      let reader = new FileReader();

      reader.onload = function(e) {
        let imagePreview = document.getElementById('image-preview');

        if (imagePreview) {
          imagePreview.src = e.target.result;
          imagePreview.style.display = 'block';
        }
      };

      reader.readAsDataURL(file);
    });
  }
}