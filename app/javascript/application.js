// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"


let content = document.querySelector(".mobile-menu-content");
let btn = document.querySelector(".mobile-menu-botton");
let mask = document.querySelector("#mask");

btn.onclick = () => {
  content.classList.toggle("open")
}

mask.onclick = () => {
  content.classList.toggle("open")
}