tag= React.DOM
{Icon}= require 'bootstrap'

# Public: Application loading page component.
class LoadingPage extends React.Component

  render: ->
    (tag.h1 null, 
      (Icon fa:'rotate-left fa-spin')
      " One moment..."
    )

module.exports= LoadingPage.reactify()