Dialog=do ->

  _active= no
  _container= $('#__overlay-root')
  _currentModal= null
  
  if _container.length is 0
    _container= $('<div id="__overlay-root"></div>')
    $ -> $('body').append _container

  isActive: -> _active

  support:
    dialogSupport: yes

    showDialog: (component, opts={})->
      if _active
        console.log "A dialog is already active!"
        return false
      
      unless component.constructor.isDialog or component.isDialog
        component= Dialog.Wrap(null, component)
      
      _currentModal= Dialog.mixin.getDialogSettings.call(component, opts)
      _active= yes

      React.renderComponent component, _container.get(0)
      yes

    hideDialog: ->
      if _currentModal?
        $(_currentModal.target).modal('hide')
        yes
      else
        no

  mixin:
    statics: 
      isDialog: yes
      dialogOpts: {}  

    # isDialog: yes
    dialogOpts: {}

    componentDidMount: ->
      _currentModal.target= @getDOMNode()
      $ _currentModal.target
        .on 'show.bs.modal', @_modalWillShow
        .on 'shown.bs.modal', @_modalDidShow
        .on 'hide.bs.modal', @_modalWillHide
        .on 'hidden.bs.modal', @_modalDidHide
        .modal _currentModal
        

    componentWillUnmount: ->
      $ _currentModal.target
        .off 'show.bs.modal', @_modalWillShow
        .off 'shown.bs.modal', @_modalDidShow
        .off 'hide.bs.modal', @_modalWillHide
        .off 'hidden.bs.modal', @_modalDidHide

    _modalWillShow: (e)->
      @dialogWillShow?(e)

    _modalDidShow: (e)->
      @dialogDidShow?(e)

    _modalWillHide: (e)->
      proceedWithHide= @dialogWillHide?(e)
      if proceedWithHide is no
        e.preventDefault()
        e.stopPropagation()
        return false
      _active= no
      return
    
    _modalDidHide: (e)->
      @dialogDidHide?(e)
      React.unmountComponentAtNode _container.get(0)
      _currentModal= null
      return

    getDialogDefaults: ->
      show: yes
      backdrop: yes #'static' # yes, no, or 'static'
      keyboard: yes

    getDialogSettings: (opts={})->
      copts= @type.dialog or @dialog
      inlineOpts= if copts? then resultsFrom(copts, this) else {} #if @dialog? then  _.result(@, 'dialog') else {}
      _.defaults opts, inlineOpts, Dialog.mixin.getDialogDefaults()

    hideDialog: ->
      if _currentModal?
        $(_currentModal.target).modal('hide')
        yes
      else
        no

module.exports= {
  Dialog
}