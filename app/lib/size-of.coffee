_toString= Object::toString

memorySizeOf = (obj) ->
  bytes = 0

  sizeOf = (obj) ->
    if obj isnt null and obj isnt `undefined`
      switch typeof obj
        when "number"
          bytes += 8
        when "string"
          bytes += obj.length * 2
        when "boolean"
          bytes += 4
        when "object"
          objClass = _toString.call(obj).slice(8, -1)
          if objClass is "Object" or objClass is "Array"
            for key of obj
              continue  unless obj.hasOwnProperty(key)
              if typeof key is "string"
                bytes += key.length * 2
              else bytes += 8  if typeof key is "number"
              sizeOf obj[key]
          else
            bytes += obj.toString().length * 2
    bytes

  formatByteSize = (bytes) ->
    if bytes < 1024
      bytes + " bytes"
    else if bytes < 1048576
      (bytes / 1024).toFixed(3) + " KiB"
    else if bytes < 1073741824
      (bytes / 1048576).toFixed(3) + " MiB"
    else
      (bytes / 1073741824).toFixed(3) + " GiB"

  formatByteSize sizeOf(obj)

module.exports = memorySizeOf