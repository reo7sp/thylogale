_ = require 'lodash'


handlerClasses = [
  require './page_handlers/html_md_erb.coffee'
]

handlerInstances = _.map(handlerClasses, (c) -> new c)

module.exports = _.zipObject(
  _.map(handlerInstances, (it) -> it.fileExtension)
  handlerInstances
)
