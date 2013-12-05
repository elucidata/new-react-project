// Class: MissingPage
module.exports= React.createClass({

  render: function(){
    return (
      <article className="missing-page">
        <h3>Not Found</h3>
        <p>404! Can't find <code>{ this.props.appState.path }</code></p>
      </article>
    )
  }

})