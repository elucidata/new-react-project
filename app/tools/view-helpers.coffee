View= require 'framework/view'

helpers= 

  shortDate: (date)->
    @formatDate date, 'l'

  longDate: (date)->
    @formatDate date, 'LL'

  formatDate: (date, format='LL')->
    moment(date).format(format)

  # Requires marked library: bower install marked --save 
  markdown: (args...)->
    if args.length is 1
      opts= {}
      block= args[0]
    else
      [opts, block]= args
    _.defaults opts, 
      gfm: yes
      smartypants: yes
      smartLists: yes
      tables: yes
    @safe marked block(), opts



applyTo= (target)->
  _.defaults(target, helpers)

applyTo View::

module.exports= {helpers, applyTo}
