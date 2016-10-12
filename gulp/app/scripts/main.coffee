require 'core-js/shim'

$ = require 'jquery'
window.jQuery = $
require 'jquery-ujs'

Turbolinks = require 'turbolinks'
Turbolinks.start()

require 'bootstrap-sass'


require './swal_config.coffee'
require './ujs.coffee'
require './views.coffee'
