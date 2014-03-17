# Example of use CoffeeScript to create React Components:
{button, div, h3, h4, i, span}= React.DOM
types= React.PropTypes


# Class: Bootstrap
# Simple Bootstrap Grid Components
# INCOMPLETE!

# Class: Row
# <Row> ... </Row>
Row= React.createClass
  displayName: 'Row'
  
  render: ->
    @transferPropsTo(
      (div className:"row", @props.children)
    )

# Class: Column
# <Column md="5" mdOffset="3"> ... </Column>
Column= React.createClass
  displayName: 'Column'

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
  displayName: 'Alert'

  propTypes:
    type: types.string
    size: types.string
    dismissable: types.bool
    onClose: types.func

  render: ->
    alertType= @props.type or 'info'
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
  displayName: 'Icon'

  render: ->
    icon= if @props.glyph?
      "glyphicon glyphicon-#{ @props.glyph }"
    else
      "fa fa-#{ @props.fa }"
    
    if @props.spin
      icon += " fa-spin"

    @transferPropsTo (i className:icon)

IconStack= React.createClass
  displayName: 'IconStack'

  render: ->
    size= @props.size or 'lg'
    @transferPropsTo(
      (span className:"fa-stack fa-#{ size }", @props.children)
    )

ButtonGroup= React.createClass
  displayName: 'ButtonGroup'
  
  render: ->
    @transferPropsTo(
      (div className:'btn-group',
        (@props.children)
      )
    )

Button= React.createClass
  displayName: 'Button'

  render: ->
    tag= if @props.href? then 'a' else 'button'
    type= @props.type or 'default'
    size= @props.size or 'md'
    btnType= if @props.submit then 'submit' else 'button'
    @transferPropsTo(React.DOM[tag] className:"btn btn-#{ type } btn-#{size}", type:btnType, @props.children)


Panel= React.createClass
  displayName: 'Panel'

  render: ->
    panelType= @props.type or 'default'
    title= @props.title
    body= if @props.noBody
        (@props.children)
      else
        (div className:"panel-body",
          @props.children
        )

    unless type.isEmpty(title)
      title= (h3 className:'panel-title', title) if type.isString(title)
      title= (div className:'panel-heading', title)
    
    @transferPropsTo(
      (div className:"panel panel-#{ panelType }", title:'',
        (title)
        (body)
        (@props.footer)
      )
    )

PanelHeading= React.createClass
  displayName: 'PanelHeading'

  render: ->
    @transferPropsTo(
      (div className:'panel-heading',
        (@props.children)
      )
    )
    
PanelFooter= React.createClass
  displayName: 'PanelFooter'

  render: ->
    @transferPropsTo(
      (div className:'panel-footer',
        (@props.children)
      )
    )
    
Panel.Heading= PanelHeading
Panel.Footer= PanelFooter


{Dialog}= require './dialog'


Dialog.Wrap= React.createClass
  displayName: 'DialogWrapper'
  mixins: [Dialog.mixin]
  
  render: ->
    @transferPropsTo(Modal null, @props.children)
    

Modal= React.createClass
  displayName: 'Modal'
  mixins: [Dialog.mixin]
  
  getDefaultProps: ->
    closable: yes
    closeLabel: '\u00D7'
    titleLabel: null
  
  render: ->
    clsEx= switch @props.size
      when 'large',  'lg' then 'modal-lg'
      when 'small', 'sm' then 'modal-sm'
      else ''
    title= if @props.titleLabel?
        (ModalHeader
          onCloseClick: @props.onCloseClick or @hideDialog
          closable: @props.closable
          closeLabel: @props.closeLabel
          titleLabel: @props.titleLabel
        )
      else
        null
    @transferPropsTo(
      (div className:"modal fade bs-#{clsEx}", tabIndex:"-1", role:"dialog", ariaLabelledBy:"overlay-label", ariaHidden:"true",
        (div className:"modal-dialog #{clsEx}",
          (div className:"modal-content",
            title
            @props.children
          )
        )
      )
    )

ModalHeader= React.createClass
  displayName: 'ModalHeader'
  
  getDefaultProps: ->
    closable: yes
    closeLabel: '\u00D7'
    titleLabel: '\u00a0'
  
  render: ->
    closeBtn= if @props.closable
        (button type:"button", className:"close", dataDismiss:"modal", ariaHidden:"true", onClick:@props.onCloseClick, @props.closeLabel)
      else
        null
    content= if @props.children?
        @props.children
      else
        if typeof @props.titleLabel is 'string'
          (h4 className:"modal-title", id:'overlay-label', @props.titleLabel)
        else
          @props.titleLabel

    @transferPropsTo(
      (div className:"modal-header",
        closeBtn
        content
      )
    )

ModalBody= React.createClass
  displayName: 'ModalBody'

  render: ->
    @transferPropsTo(
      (div className:"modal-body",
        @props.children
      )
    )
    

ModalFooter= React.createClass
  displayName: 'ModalFooter'

  render: ->
    @transferPropsTo(
      (div className:"modal-footer",
        @props.children
      )
    )

Modal.support= Dialog.support
Modal.mixin= Dialog.mixin
Modal.Header= ModalHeader
Modal.Body= ModalBody
Modal.Footer= ModalFooter

{Popover}= require './popover'
Col= Column
ModalDialog= Dialog
module.exports= {
  Alert
  Button
  ButtonGroup
  Column
  Col
  Icon
  IconStack
  Panel
  Row
  Modal
  ModalDialog
  ModalHeader
  ModalBody
  ModalFooter
  Popover
  Dialog
}
