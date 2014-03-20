{Icon}= require 'bootstrap'

# Public: Application loading page component.
class LoadingPage extends React.Component

  render: ->
    (@h1 null, 
      (Icon fa:'rotate-left fa-spin')
      " One moment..."
    )

module.exports= LoadingPage.reactify()