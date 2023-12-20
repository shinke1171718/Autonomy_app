# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "jquery", to: "https://ga.jspm.io/npm:jquery@3.7.0/dist/jquery.js"
pin_all_from "app/javascript/controllers", under: "controllers"
# pin "nav_menu", to: "app/javascript/nav_menu.js"
pin "nav_menu", to: "nav_menu.js", preload: true
pin "checkbox_button_control", to: "checkbox_button_control.js", preload: true
pin "menu_button_style_update", to: "menu_button_style_update.js", preload: true
