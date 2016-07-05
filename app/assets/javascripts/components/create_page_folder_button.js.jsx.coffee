class @CreatePageFolderButton extends React.Component
  @propTypes =
    rootFolderId: React.PropTypes.number

  click: ->
    newFile = prompt I18n.t 'enter_new_folder'

  render: ->
    `<button className='btn btn-default' onClick={this.click}>
        {I18n.t('new_folder')}
    </button>`
