{div, h1, small, footer, p}= tag= React.DOM
{Icon, IconStack, Button, Modal}= require 'bootstrap'
{__, _copy}= React.Helpers
MissingPage= require 'pages/system/missing'
LoadingPage= require 'pages/system/loading'
DebugPanel= require 'widgets/debug-panel'

# Public: Primary application layout.
# Main root element of page. It will change out any sub-pages based on the {State}.
class RootPage extends React.Component

  mixins: [
    Modal.support
  ]

  getInitialState: ->
    page: LoadingPage

  componentDidMount: ->
    @ensurePageExists()
    $ 'a[title]', @getDOMNode()
      .tooltip
        placement: 'bottom'
        container: 'body'

  componentWillReceiveProps: (props)->
    @ensurePageExists props

  componentWillUnmount: ->
    $ 'a[title]', @getDOMNode()
      .tooltip 'destroy'

  ensurePageExists: (props=@props)->
    return unless @props.app.ready
    @setState try
        page: require "pages/#{ props.page.current }"
      catch ex
        console.log "Failure loading page", JSON.stringify(props.page.current), ex
        page: MissingPage

  actionShowDebugPanel: (e)->
    @showDialog (DebugPanel null)
    cancelEvent e

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  render: ->
    page= @state.page

    (div className:"app-root",
      (div className:"container",
        (div className:"page-header",
          (div className:"btn-group btn-group-sm pull-right",
            (Button className:@navClasses('home'), href:"#/", "Home")
            (Button className:@navClasses('system/missing'), href:"#/anything", title:"This should trigger the 404 handler...", "Missing Link")
            (Button onClick:@actionShowDebugPanel,
              (Icon fa:'bug')
            )
          )
          (h1 null,
            (IconStack null,
              (Icon className:"app-icon fa-stack-2x", fa:"certificate")
              (Icon className:"fa-stack-1x fa-inverse", fa:"camera")
            )
            (@props.app.name)
            (small className:"app-version", "v#{ @props.app.version }")
          )
        )
        @transferPropsTo( page {} )
      )
      (footer className:"container",
        (p className:"text-muted text-right", "#{ @props.app.name } v#{ @props.app.version }")
      )
    )

  navClasses: (page)->
    return if page is @props.page.current then 'active' else ''


module.exports= RootPage.reactify()
