var Icon= require('ui/widgets/bootstrap').Icon

// Class: MissingPage
module.exports= React.createClass({

  render: function(){
    return (
      <article className="missing-page">
        <h3>Not Found</h3>
        <p>
          <Icon fa="bug"/>
          404! Can't find <code>{ location.hash }</code>
        </p>
      </article>
    )
  }

})