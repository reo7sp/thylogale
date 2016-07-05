class @PageSearchBox extends React.Component
  @propTypes =
    rootFolderId: React.PropTypes.number

  render: ->
    `<div>
      <div>Root Folder: {this.props.rootFolderId}</div>
    </div>`
