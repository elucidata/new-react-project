{article,h3,blockquote,p,code}= React.DOM
{Icon}= require('bootstrap')

# Public: Missing page component
class MissingPage extends React.Component

  render: ->
    (article className:"missing-page",
      (h3 null, "Not Found")
      (blockquote null,
        (p null,
          (Icon fa:"bug")
          " 404! Can't find "
          (code null, location.hash)
        )
      )
    )

module.exports= MissingPage.reactify()