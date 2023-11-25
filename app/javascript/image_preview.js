createPreview()

function createPreview() {
  let imageInput = document.getElementById('menu_image');

  if (!imageInput) return;

  imageInput.addEventListener('change', function(event) {
    // ユーザーが選択したファイルを取得
    let file = event.target.files[0];
    // Base64エンコードされたデータURLを作成して格納
    let reader = new FileReader();

    reader.onload = function(e) {
      let imagePreview = document.getElementById('image-preview');

      // Base64エンコードされたデータURLをsrc属性に代入
      imagePreview.src = e.target.result;
      imagePreview.style.display = 'block';
    };

    // 画像データを取得するための命令
    reader.readAsDataURL(file);
  });
}
