Popover=
  support:

    statics:
      popoverSupport: yes

    componentWillMount: ->
      @popoverSupport= yes
      @popoverActive= null

    componentWillUnmount: ->
      @hidePopover()

    # If a popover is already active, false is returned. Otherwise true.
    showPopover: (component, opts={})->
      if @popoverActive?
        console.log "Already an active popover!!!"
        return no
      unless component.type.isPopover or component.isPopover
        component= Popover.Wrap(null, component)
      opts= Popover.mixin.getPopoverSettings.call(component, opts)
      opts.target or= this.getDOMNode()
      opts.content= component
      opts.caller= this
      component.popoverOpts= opts
      $(opts.target)
        .data('po.opts', opts)
        .one('show.bs.popover', @_popoverWillShow)
        .popover(opts)
        .popover('show')
      return yes

    hidePopover: ->
      @popoverActive?.content?.hidePopover?()

    # Experimental!
    getPopoverDOMNode: ->
      @popoverActive?.content?.getPopoverDOMNode?()

    _popoverWillShow: (e)->
      return if @popoverActive?
      # console.log "_popoverWillShow"
      @popoverActive= opts= $(e.target)
        .on('hide.bs.popover', @_popoverWillHide)
        .on('shown.bs.popover', @_popoverDidShow)
        .on('hidden.bs.popover', @_popoverDidHide)
        .data('po.opts')

      # TODO: Should these callbacks allow cancel of popover?
      @popoverActive.content?.popoverWillShow?(e)
      @popoverWillShow?(e)

      if opts.transient
        color= opts.screenColor or 'rgba(255,255,255,0)'
        depth= opts.screenZIndex or 1199
        opacity= opts.screenOpacity or 1
        # color= opts.screenColor or 'rgba(255,0,0,0.5)'
        @popoverScreen= $('<div class="popover-overlay"> </div>')
        @popoverScreen
          .on('click', @_screenOnClick)
          .css(
            position: 'fixed'
            background: color
            top: 0
            bottom: 0
            left: 0
            right: 0
            zIndex: depth
            opacity: opacity
            # border:'1px solid red'
          )
        $('body').append @popoverScreen

    _popoverDidShow: (e)->
      @popoverDidShow?(e)
      @popoverActive.content?.popoverDidShow?(e)

    _screenOnClick: (e)->
      unless $(e.target).parents('.popover').length > 0
        e.preventDefault()
        e.stopPropagation()
        @hidePopover()
        false

    _popoverWillHide: (e)->
      shouldProceed= @popoverActive.content.popoverWillHide?(e)
      if shouldProceed isnt false
        shouldProceed= @popoverWillHide?(e)
      if shouldProceed is false
        @_popoverIsClosing= no
        @popoverActive.content?._popoverIsClosing= no
        e.preventDefault()
        e.stopPropagation()
        return false

      @_popoverIsClosing= yes
      @popoverScreen
        .off('click', @_screenOnClick)
        .remove()

    _popoverDidHide: (e)->
      # HACK: Not great
      # _.delay @_destroyPopover, 250, e
      @popoverDidHide?(e)
      @popoverActive.content.popoverDidHide?(e)
      @_destroyPopover(e)
      @popoverDidClose?(e)

    _destroyPopover: (e)->
      popover= $(e.target).data('bs.popover')
      $tip= popover.tip()
      opts= $(e.target).data('po.opts')
      $(e.target).data('po.opts', null)

      $content= $tip.find('.popover-content')
      $title= $tip.find('.popover-title')
      
      try
        # console.log '$content', $content.innerWidth(), 'x', $content.innerHeight()
        $content.css
          width: $content.innerWidth()
          height: $content.innerHeight()
          overflow: 'hidden'
        # console.log '$tip', $tip.innerWidth(), 'x', $tip.innerHeight()
        $title.css
          width: $title.innerWidth()
          height: $title.innerHeight()
          overflow: 'hidden'
      catch ex
        console.error "sizer error", ex

      React.unmountComponentAtNode $title.get(0)
      React.unmountComponentAtNode $content.get(0)
      # console.log 'destroy!'
      opts.content= null
      opts.component= null
      opts.caller= null
      @popoverActive= null
      @_popoverIsClosing= no

      $(e.target)
        .off('shown.bs.popover', @_popoverDidShow)
        .off('hide.bs.popover', @_popoverWillHide)
        .off('hidden.bs.popover', @_popoverDidHide)
        .popover('destroy')
        .trigger('destroy.bs.popover')


  mixin:
    statics:
      isPopover: yes
    
    popoverOpts: null

    getPopoverDefaults: ->
      title: ''
      animation: yes
      placement: 'auto top'  
      trigger: 'manual'
      popoverTitle: ''
      delay: 0
      container: false
      transient: yes
      react: true
      container: 'body'
      #screenColor: 'transparent'

    getPopoverSettings: (opts={})->
      copts= @type.popover or @popover
      inlineOpts= if copts? then resultsFrom(copts, this) else {} #if @popover? then _.result(@, 'popover') else {}
      _.defaults opts, inlineOpts, Popover.mixin.getPopoverDefaults()

    getPopoverDOMNode: ->
      @getPopoverTip()?.get(0)

    getPopoverTip: ->
      tgt= @popoverOpts?.target
      if tgt 
        popover= $(tgt).data('bs.popover')
        popover?.tip()
      else
        console.log "No target found to fetch popover DOM node from."
        null

    hidePopover: ->
      return if @_popoverIsClosing
      if @popoverOpts?.target?
        @_popoverIsClosing= yes
        $(@popoverOpts.target).popover('hide')



Popover.Wrap= React.createClass
    displayName: 'PopoverWrapper'
    mixins: [Popover.mixin]
    render: ->
      (@props.children)


module.exports= {
  Popover
}



# Based on code from: http://jsfiddle.net/spicyj/q6hj7/

# Patch Bootstrap popover to take a React component instead of a plain HTML string
$.extend $.fn.popover.Constructor.DEFAULTS, react:no

oldSetContent= $.fn.popover.Constructor.prototype.setContent

$.fn.popover.Constructor.prototype.setContent= ->
  return oldSetContent.call(@) if !@options.react

  $tip= @tip()
  title= @getTitle()
  content= @getContent()
  
  $tip.removeClass('fade top bottom left right in')

  # If we've already rendered, there's no need to render again
  unless $tip.find('.popover-content').html()
    # Render title, if any
    $title= $tip.find('.popover-title')
    
    if (title)
      if (typeof title == 'string')
        $title.html(title) # Might should use .text(), but whatever.
      else
        React.renderComponent(title, $title[0])
    else
      $title.hide()

    # Render content
    mounted= React.renderComponent( content, $tip.find('.popover-content')[0] )
    # console.log 'mounted', mounted is content

    $tip.css( zIndex:1200 )
  
