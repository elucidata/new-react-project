
without= (source, target)->
  item for item in source when item not in target

module.exports= {
  without
}

Array.without or= without

# Array::without or= (target)-> without this, target