
defer= (fn, args...)->
  setTimeout (-> fn.apply null, args), 0

module.exports= {
  defer
}

Function.defer or= defer

Function::defer or= (args...)-> defer(this, args...)

