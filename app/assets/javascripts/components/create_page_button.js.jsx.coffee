class @CreatePageButton extends React.Component
  @propTypes =
    rootFolderId: React.PropTypes.number

  click: ->
    newFile = prompt I18n.t 'enter_new_page'

  render: ->
    `<button className='btn btn-primary' onClick={this.click}>
        <span className='glyphicon glyphicon-plus' aria-hidden='true'></span> {I18n.t('new_page')}
    </button>`
