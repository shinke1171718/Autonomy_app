import jquery from "jquery"
window.$ = jquery


$(document).on('turbo:load', function() {
  $('.mobile-menu-botton').on('click', function () {
    $(".mobile-menu-content").toggleClass("open");
    $("#mask").toggleClass("open");
  });

  $("#mask").on('click', function () {
    $(".mobile-menu-content").removeClass("open");
    $("#mask").removeClass("open");
  });
});