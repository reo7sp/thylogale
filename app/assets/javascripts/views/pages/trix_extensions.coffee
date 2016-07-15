_ = require 'lodash'
Map = require 'core-js/library/fn/Map'

module.exports = -> new class
  attributesCache: new Map

  constructor: ->
    @createTextAttribures()
    @createEvents()

  createTextAttribures: ->
    Trix.config.textAttributes = _.extend Trix.config.textAttributes,
      h1:
        tagName: 'h1'
      h2:
        tagName: 'h2'
      h3:
        tagName: 'h3'

  createEvents: ->
    document.addEventListener 'trix-attributes-change', (e) =>
      getHeadersFrom = (coll) ->
        _(coll).pick(['h1', 'h2', 'h3']).keys().value()

      headers = getHeadersFrom e.attributes

      if headers.length > 1
        prevHeaders = getHeadersFrom @attributesCache.get(e.target)
        e.target.editor.deactivateAttribute(attribute) for attribute in prevHeaders

      @attributesCache.set(e.target, _.cloneDeep(e.attributes))

