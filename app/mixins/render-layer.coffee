# Converted to coffeescript, based on: http://jsfiddle.net/LBAr8/

module.exports=

  componentDidMount: ->
    # Appending to the body is easier than managing the z-index of everything on the page.
    # It's also better for accessibility and makes stacking a snap (since components will stack
    # in mount order).
    {tag, className}= Object.defaults {}, (@type.layer or {}), tag:'div', className:'layer'
    @_targetLayer= document.createElement tag
    @_targetLayer.className= className
    document.body.appendChild @_targetLayer
    @_renderLayer()

  componentWillUnmount: ->
    @_unrenderLayer()
    document.body.removeChild @_targetLayer

  componentDidUpdate: ->
    @_renderLayer()

  _renderLayer: ->
    return unless @isMounted()
    # By calling this method in componentDidMount() and componentDidUpdate(), you're effectively
    # creating a "wormhole" that funnels React's hierarchical updates through to a DOM node on an
    # entirely different part of the page.
    React.renderComponent @renderLayer(), @_targetLayer

  _unrenderLayer: ->
    React.unmountComponentAtNode @_targetLayer

