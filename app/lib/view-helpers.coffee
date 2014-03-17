

helpers= 

  pp: (obj)->
    if arguments.length > 1
      JSON.stringify arguments, null, 2
    else
      JSON.stringify obj, null, 2

  shortDate: (date)->
    @formatDate date, 'l'

  longDate: (date)->
    @formatDate date, 'LL'

  formatDate: (date, format='LL')->
    moment(date).format(format)

  cancelEvent: (e)->
    e?.preventDefault?()
    false

  # Requires marked library: bower install marked --save 
  markdown: (args...)->
    if args.length is 1
      opts= {}
      block= args[0]
    else
      [opts, block]= args
    Object.defaults opts, 
      gfm: yes
      smartypants: yes
      smartLists: yes
      tables: yes
    @safe marked block(), opts

applyTo= (target)-> Object.defaults(target, helpers)

module.exports= {helpers, applyTo}


React.Helpers= Object.extend {}, React.addons,
  _: null
  __: null
  nbsp: '\u00a0'
  _nbsp: '\u00a0'
  times: '\u00d7'
  _times: '\u00d7'
  copy: '\u00a9'
  _copy: '\u00a9'
