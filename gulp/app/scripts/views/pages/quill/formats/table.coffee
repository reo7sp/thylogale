$ = require 'jquery'
Quill = require 'quill'
Embed = Quill.import('blots/block/embed')


class QuillTable extends Embed
  for k, v of Embed
    @[k] = v

  @blotName: 'table'
  @tagName: 'table'

  @value: (node) ->
    for row in node.rows
      for cell in row.cells
        tagName: cell.tagName
        value: cell.innerHTML

  @create: (values) ->
    table = Embed.create.apply(@, arguments)
    $table = $(table)
    $table.attr('contentEditable', false)

    for row in values
      $tr = $ "<tr></tr>"
      $table.append($tr)
      for cell in row
        $td = $ "<#{cell.tagName}>#{cell.value}</#{cell.tagName}>"
        $tr.append($td)

    $controls = $ """
        <tr class="ql-table-controls">
          <td colspan=#{values[0].length}>#{I18n.t 'change_table_size'}</td>
        </tr>
        """
    $table.append($controls)

    table


Quill.register(QuillTable, true)
module.exports = QuillTable