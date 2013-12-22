# Example of use CoffeeScript to create React Components:
{button, div, h3, i, span}= React.DOM


# Class: Bootstrap
# Simple Bootstrap Grid Components
# INCOMPLETE!

# Class: Row
# <Row> ... </Row>
Row= React.createClass
  render: ->
    @transferPropsTo(
      (div className:"row", @props.children)
    )

# Class: Column
# <Column md="5" mdOffset="3"> ... </Column>
Column= React.createClass

  _buildClass: (prop)->
    classname= ""
    if val= @props[prop]
      classname += " col-#{ prop }-#{ val }"
    if val= @props["#{ prop }Offset"]
      classname += " col-#{prop}-offset-#{ val }"
    classname
  
  _buildClassNames: ->
    @_buildClass('xs') + @_buildClass('sm') + @_buildClass('md') + @_buildClass('lg')
  
  render: ->
    @transferPropsTo(
      (div className:@_buildClassNames(), @props.children)
    )

# Class: Alert
# <Alert dismissable={Boolean:false} type={String:'default'} onClose={Function}> ... </Alert>
Alert= React.createClass
  render: ->
    alertType= @props.type or 'default'
    btn= null
    
    if String(@props.dismissable) is 'true'
      alertType += ' alert-dismissable'
      btn= button 
        type:"button"
        onClick:@props.onClose
        className:"close"
        ariaHidden:"true"
        dangerouslySetInnerHTML:{__html:'&times;'}

    @transferPropsTo(
      (div className:"alert alert-#{ alertType }",
        btn
        @props.children
      )
    )


Icon= React.createClass
  render: ->
    
    icon= if @props.glyph?
      "glyphicon glyphicon-#{ @props.glyph }"
    else
      "fa fa-#{ @props.fa }"    
    @transferPropsTo (i className:icon)

IconStack= React.createClass
  render: ->
    size= @props.size or 'lg'
    @transferPropsTo(
      (span className:"fa-stack fa-#{ size }", @props.children)
    )

Button= React.createClass
  render: ->
    tag= if @props.href? then 'a' else 'button'
    type= @props.type or 'default'
    @transferPropsTo(React.DOM[tag] className:"btn btn-#{ type }", type:'button', @props.children)


Panel= React.createClass
  render: ->
    panelType= @props.type or 'default'
    title= @props.title

    unless _.isEmpty(title)
      title= (h3 className:'panel-title', title) if _.isString(title)
      title= (div className:'panel-heading', title)
    
    @transferPropsTo(
      (div className:"panel panel-#{ panelType }",
        title
        (div className:"panel-body",
          @props.children
        )
      )
    )

module.exports= {
  Alert
  Button
  Column
  Icon
  IconStack
  Panel
  Row
}
