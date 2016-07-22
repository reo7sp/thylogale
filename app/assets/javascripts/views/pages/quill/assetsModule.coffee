_ = require 'lodash'
base64ToBlob = require 'base64ToBlob'

saveAsset = ({blob, page}) ->
  form = new FormData
  form.append('page_asset[data]', blob)
  form.append('page_asset[page_id]', page)

  $.ajax "/pages/#{page}/page_assets",
    method: 'POST'
    data: form
    contentType: false
    processData: false

deleteAsset = (id, {page}) ->
  $.ajax("/page_assets/#{id}", method: 'DELETE')

assetHrefToId = (href) ->
  href.match(/\d+/)?[0] if _.startsWith(href, '/page_assets/')

getImageBlobFromBase64 = (data) ->
  semicolonIndex = data.indexOf(';')
  mime = data.slice(5, semicolonIndex)
  base64ToBlob(data.slice(semicolonIndex + 8), mime)

getOpLength = (op) ->
  value = _.values(op)[0]
  if _.isInteger(value)
    value
  else if _.isString(value)
    value.length
  else
    1

getOpOnIndex = (index, ops) ->
  i = 0
  for op in ops
    i += getOpLength(op)
    return op if i > index

getIndexOfOp = (op, ops) ->
  i = 0
  for it in ops
    return i if it == op
    i += getOpLength(it)

getFirstOpsOfAllTypes = (ops) ->
  firstHasSecondDontAny = (first, second, properties) ->
    for property in properties
      return true if first[property]? and not second[property]?
    false

  result = {}
  for op in ops
    if firstHasSecondDontAny(op, result, ['retain', 'insert', 'delete'])
      _.extend(result, op)
  result

getIndexOfFirstOpOfType = (type, ops) ->
  op = _(ops).find (it) -> it[type]?
  getIndexOfOp(op, ops)

changeImageHrefInQuillOnIndex = (index, href, quill) ->
  quill.deleteText(index, 1)
  quill.insertEmbed(index, 'image', href)


Quill.register 'modules/assets', class extends Quill.import('core/module')
  constructor: (quill, options) ->
    super
    @quill.on(Quill.events.TEXT_CHANGE, @onTextChange.bind(@))

  onTextChange: (delta, oldDelta, source) ->
    return unless source == 'user'

    o = getFirstOpsOfAllTypes(delta.ops)

    if o.insert?.image?
      if _.startsWith(o.insert.image, 'data:')
        blob = getImageBlobFromBase64(o.insert.image)
        saveAsset(blob: blob, page: @options.pageId)
          .done (data) =>
            index = getIndexOfFirstOpOfType('insert', delta.ops)
            changeImageHrefInQuillOnIndex(index, "#{data.path}/raw", @quill)
          .fail =>
            console.error arguments
            index = getIndexOfFirstOpOfType('insert', delta.ops)
            @quill.deleteText(index, 1)
            toastr.error(I18n.t('cant_save_asset'), I18n.t('error'))

    if o.delete?
      retained = o.retain ? 0
      deleted = getOpOnIndex(retained, oldDelta.ops).insert ? {}
      if deleted.image?
        id = assetHrefToId(deleted.image)
        deleteAsset(id, page: @options.pageId) if id?
