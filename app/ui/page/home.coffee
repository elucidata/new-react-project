tag= React.DOM

# Public: Home page component
class HomePage extends React.Component

  render: ->
    (tag.div className:"home-page",
      (tag.h3 null, "Welcome Home")
      (tag.p null, "HOME PAGE")
    )

module.exports= HomePage.reactify()