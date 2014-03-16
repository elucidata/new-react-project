{div, h3, p}= React.DOM

# Public: Home page component
class HomePage extends React.Component

  render: ->
    (div className:"home-page",
      (h3 null, "Welcome Home")
      (p null, "HOME PAGE")
    )

module.exports= HomePage.reactify()