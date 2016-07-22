_ = require 'lodash'

handlerClasses = [
  require './page_handlers/md_handler.coffee'
  require './page_handlers/md_liquid_handler.coffee'
]

handlerInstances = _.map(handlerClasses, (c) -> new c)

module.exports = _.zipObject(
  _.map(handlerInstances, (it) -> it.fileExtension)
  handlerInstances
)
