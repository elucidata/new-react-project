Controller= require './controller'

###

  Class: UndoManager

    Tracks changes to specified Collections (and/or Models) in
    a somewhat transactional way. 

    You don't extend your class with this,
    nor does it automatically track every model/collection in your app!
    
    You are meant to use it with discreet user interactions that the user
    can then undo if they want.


  Usage:
  (start code)
  # Assume elsewhere:
  Users= new UserCollection

  # Your undoable transaction:
  @app.undoMgr.record Users, ->
    user= Users.get id
    user.destroy()

  # To undo the changes made:
  @app.undoMgr.undo()
  
  # To redo them:
  @app.undoMgr.redo()

  # -- More complex example --

  # Posts and Comments are Collections

  newComment: (postId, commentAtts)->
    @app.undoMgr.record Posts, Comments, ->
      post= Posts.get postId
      commentAtts.postId= postId
      Comments.create commentAtts
      post.set commentCount:(Comments.find {postId}).length
      post.save()
  
  # @app.undoMgr.undo() will now rollback the changes to both collections. 
  (end)
###
module.exports= class UndoManager extends Controller
  
  constructor: ->
    @_stack= []
    @_redoStack= []
    @length= 0
    @on 'change', => @length= @_stack.length
    super

  # Method: record
  # objects... - Collections or Models to track in the undable block
  # block - Closure around model/collection operations that should be undoable
  record: (objects...)->
    block= objects.pop()
    txn= new Transaction this, objects, block
    # TODO: Implement limiting size of undo stack. Currently it will expand forever
    @_stack.push txn
    txn.execute()
    @_redoStack= []
    @trigger 'record change'
    this

  # Method: undo
  undo: ->
    return false if @_stack.length is 0
    txn= @_stack.pop()
    # roll back changes
    txn.rollback()
    @_redoStack.push txn
    @trigger 'undo change'
    this

  # Method: redo
  redo: ->
    return false if @_redoStack.length is 0
    txn= @_redoStack.pop()
    # roll back changes
    txn.execute()
    @_stack.push txn
    @trigger 'redo change'
    this

  # Method: clear
  # NOTE: This will destroy all undo and redo history!
  clear: ->
    @_stack.length = 0
    @_redoStack.length = 0
    @trigger 'clear change'

  # Method: canUndo
  canUndo: -> @_stack.length > 0
  # Method: canRedo
  canRedo: -> @_redoStack.length > 0

  # Method: dispose
  dispose: ->
    @clear()
    super

  # Method: crudHelpers
  # Static method for creating simple undoable CRUD operations.
  #
  # collection - A Collection to assign
  #
  # Returns:
  #   <CrudHelpers> instance.
  @crudHelpers: (collection)->
    new CrudHelpers collection

# Class: Transaction
# Internal class that encapsulates the tracking of all the model/collection
# changes that occur within the block of aa <UndoManager.record> call.
class Transaction
  constructor: (@manager, @objects, @block)->
    @actions= []
    @_buildLabel()

  # Method: label
  label: (value)->
    if value?
      @_label= value
    else
      @_label

  # Method: execute
  execute: ->
    object.on('all', @_logEvents) for object in @objects
    @block(this, @manager)
    object.off('all', @_logEvents) for object in @objects
    this

  # Method: rollback
  rollback: ->
    # REVIEW: Should models be autosaved on rollback?
    for action in @actions.reverse()
      {method, id, collection}= action
      
      # If we added a model, delete it
      if method is 'add'
        model= collection.get(id) or collection.findWhere(action.attributes)
        model.destroy()
      
      # If we removed a model, recreate it
      else if method is 'remove'
        restored= new collection.model action.attributes
        collection.add restored
        restored.save()
      
      # If we modified a model, restore the changes
      else if method is 'change'
        model= collection.get(id) or collection.findWhere(action.attributes)
        model.set action.changes
        model.save()
      
      else
        console.log 'Unknown model action', method
    @actions= []
    this

  getObjectName: (object)->
    object.name or object.constructor.name or 'unnamed object'

  _buildLabel: ->
    names= []
    for object in @objects
      names.push @getObjectName(object)
    @_label = "changes to #{names.join ', '}"

  _logEvents: (args...)=>
    action= args.shift()
    if handler= @["_log_#{ action }"]
      @actions.push handler(args...)
    # else
    #   console.warn "could not record event", action

  _log_add: (model, collection, changes)-> 
    { method:'add', id: model.id, attributes: _.clone(model.attributes), collection }

  _log_remove: (model, collection, changes)-> 
    { method:'remove', id: model.id, attributes: _.clone(model.attributes), collection }

  _log_change: (model, changes)-> 
    newAtts= model.changedAttributes()
    changedAtts= _.pick model.previousAttributes(), _.keys(newAtts)
    { method:'change', id: model.id, attributes: _.clone(newAtts), changes: _.clone(changedAtts), collection: model.collection }


###
Class: CrudHelpers

Helpers for quickly creating undoable actions for CRUD operations. Best used
in conjunction with appEvents and your Collection class.

Usage:
  (start code)
  {Model, Collection, UndoManager}= require 'tools/framework'

  class Post extends Model
    @attr 'title', default:'Untitled'

  class PostCollection extends Collection
    model: Post

    initialize: ->
      super
      @crud= UndoManager.crudHelpers(this)

    appEvents:
      'update:post', (idOrModel, data)-> @crud.doUpdate idOrModel, data
      'remove:post', (idOrModel)-> @crud.doRemove idOrModel
      'add:post': (data)->
        @crud.doAdd data, (txn, model)->
          # You can label this action if you plan on showing a list
          # of history items in your app. Completely optional!
          txn.label "creation of post '#{ model.title() }'"
  (end)
###
class CrudHelpers
  constructor: (@collection)->
    @app= @collection.app
    @modelClass= @collection.model

  # Method: doAdd
  #   data - Object of data to update.
  #   callback - Callback function.
  doAdd: (data, callback)->
    @app.undoMgr.record @collection, (txn)=>
      model= @collection.create data
      callback? txn, model

  # Method: doRemove
  #   idOrModel - ID or model instance.
  #   callback - Callback function.
  doRemove: (idOrModel, callback)->
    id= @_getModelId idOrModel
    @app.undoMgr.record @collection, (txn)=>
      model= @_getModel id
      model.destroy()
      callback? txn, model

  # Method: doUpdate
  #   idOrModel - ID or model instance.
  #   data - Object of data to update.
  #   callback - Callback function.
  doUpdate: (idOrModel, data, callback)->
    id= @_getModelId idOrModel
    @app.undoMgr.record @collection, (txn)=>
      model=  @_getModel id
      model.set data
      model.save()
      callback? txn, model

  _getModel: (id)->
    if _.isString id
      @collection.get id
    else
      id
  
  _getModelId: (model)->
    if _.isString model
      model
    else
      model.id