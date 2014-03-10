tag= React.DOM
{Icon}= require('bootstrap')

# Public: Missing page component
class MissingPage extends React.Component

  render: ->
    (tag.article className:"missing-page",
      (tag.h3 null, "Not Found")
      (tag.blockquote null,
        (tag.p null,
          (Icon fa:"bug")
          " 404! Can't find "
          (tag.code null, location.hash)
        )
      )
    )

module.exports= MissingPage.reactify()