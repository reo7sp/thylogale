require 'core-js/shim'

$ = require 'jquery'
window.jQuery = $
require 'jquery-ujs'

Turbolinks = require 'turbolinks'
Turbolinks.start()

I18n = require 'i18n-js'
window.I18n = I18n

require 'bootstrap-sass'

require './swal_config.coffee'
require './ujs.coffee'
require './views.coffee'
