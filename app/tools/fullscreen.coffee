# Abstracts vendor prefixes for Fullscreen support.

isSupported= no

prefix= do ->
  if document['requestFullScreen']?
    isSupported= yes
  else
    for testPrefix in ["webkit", "moz", "ms", "o"]
      if document["#{testPrefix}RequestFullScreen"]?
        isSupported= yes
        return testPrefix
  return ''

execute= (cmd, el=document)->
  throw new Error("Fullscreen isn't supported by this browser.") unless isSupported
  cmd = "#{ prefix }#{ _.str.capitalize cmd }" if prefix isnt ''
  el[cmd]?()

api=
  isSupported: isSupported
  prefix: prefix
  requestFullScreen: (el)-> execute('requestFullScreen', el)
  cancelFullScreen: (el)-> execute('cancelFullScreen', el)
  fullScreen: (el)-> execute('cancelFullScreen', el)

module.exports= api