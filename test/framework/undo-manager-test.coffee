Collection = require 'lib/framework/collection'
Model= require 'lib/framework/model'
UndoManager= require 'lib/framework/undo-manager'

class User extends Model
class UserCollection extends Collection
  url: 'test'
  model: User

class Post extends Model
class PostCollection extends Collection
  url: 'post'
  model: Post

describe 'Framework.UndoManager', ->
  beforeEach ->
    @undoMgr= new UndoManager
    @collection = new UserCollection
    @_oldSync= Backbone.sync
    Backbone.sync= ->
      # console.log 'sync called'

  afterEach ->
    # console.log @collection.models
    Backbone.sync= @_oldSync
    delete @_oldSync
    @undoMgr.dispose()
    try 
      @collection.dispose() 
    catch e 
      # The undo/redo multiple model test is throwing a random error on 
      # collection#dispose for some reason -- just for adding 3 models. ?!
      console.log 'Error disposing of collection'
      console.error e

  it 'should exist', ->
    expect(@undoMgr).to.exist

  it 'should undo/redo Collection#create() calls', ->
    expect(@collection.length).to.equal 0
    
    @undoMgr.record @collection, =>
      @collection.create name:'test'

    expect(@collection.length).to.equal 1
    
    @undoMgr.undo()
    expect(@collection.length).to.equal 0
    
    @undoMgr.redo()
    expect(@collection.length).to.equal 1
    expect(@collection.first().get('name')).to.equal 'test'

  it 'should undo/redo Model#destroy() calls', ->
    expect(@collection.length).to.equal 0
    @collection.create name:'test', id:'01'
    expect(@collection.length).to.equal 1
    expect(@collection.first().get('name')).to.equal 'test'
    
    @undoMgr.record @collection, =>
      model= @collection.get '01'
      model.destroy()

    expect(@collection.length).to.equal 0
    
    @undoMgr.undo()
    expect(@collection.length).to.equal 1
    
    @undoMgr.redo()
    expect(@collection.length).to.equal 0

    @undoMgr.undo()
    expect(@collection.length).to.equal 1
    expect(@collection.first().get('name')).to.equal 'test'
    expect(@collection.first().id).to.equal '01'


  it 'should undo/redo Model#set() calls', ->
    expect(@collection.length).to.equal 0
    @collection.create name:'test', id:'01'
    expect(@collection.length).to.equal 1
    expect(@collection.first().get('name')).to.equal 'test'
    
    @undoMgr.record @collection, =>
      model= @collection.get '01'
      model.set name:'new name'

    expect(@collection.length).to.equal 1
    expect(@collection.first().get('name')).to.equal 'new name'
    
    @undoMgr.undo()
    expect(@collection.length).to.equal 1
    expect(@collection.first().get('name')).to.equal 'test'
    
    @undoMgr.redo()
    expect(@collection.length).to.equal 1
    expect(@collection.first().get('name')).to.equal 'new name'

  it 'should undo/redo multiple models simultaneously', ->
    expect(@collection.length).to.equal 0

    @collection.create name:'test one', id:'01'
    @collection.create name:'test two', id:'02'
    @collection.create name:'test three', id:'03'

    expect(@collection.length).to.equal 3
    expect(@collection.at(0).get('name')).to.equal 'test one'
    expect(@collection.at(1).get('name')).to.equal 'test two'
    expect(@collection.at(2).get('name')).to.equal 'test three'

    @undoMgr.record @collection, =>
      @collection.get('01').set name:'The First'
      @collection.get('02').set name:'The Second'
      @collection.get('03').set name:'The Third'

    expect(@collection.length).to.equal 3
    expect(@collection.at(0).get('name')).to.equal 'The First'
    expect(@collection.at(1).get('name')).to.equal 'The Second'
    expect(@collection.at(2).get('name')).to.equal 'The Third'

    @undoMgr.undo()
    expect(@collection.at(0).get('name')).to.equal 'test one'
    expect(@collection.at(1).get('name')).to.equal 'test two'
    expect(@collection.at(2).get('name')).to.equal 'test three'

    @undoMgr.redo()
    expect(@collection.at(0).get('name')).to.equal 'The First'
    expect(@collection.at(1).get('name')).to.equal 'The Second'
    expect(@collection.at(2).get('name')).to.equal 'The Third'


  it 'should undo/redo multiple collections simultaneously', ->
    Posts= new PostCollection
    Posts.create name:'test post', id:'01'
    @collection.create name:'test', id:'02'
    expect(Posts.length).to.equal 1
    expect(@collection.length).to.equal 1

    @undoMgr.record @collection, Posts, =>
      @collection.get('02').set name:'Updated Name'
      Posts.get('01').set name:'Updated Post Name'

    expect(@collection.length).to.equal 1
    expect(@collection.at(0).get('name')).to.equal 'Updated Name'
    expect(Posts.at(0).get('name')).to.equal 'Updated Post Name'

    @undoMgr.undo()
    expect(@collection.length).to.equal 1
    expect(@collection.at(0).get('name')).to.equal 'test'
    expect(Posts.at(0).get('name')).to.equal 'test post'

    @undoMgr.redo()
    expect(@collection.length).to.equal 1
    expect(@collection.at(0).get('name')).to.equal 'Updated Name'
    expect(Posts.at(0).get('name')).to.equal 'Updated Post Name'

    Posts.dispose()

  it 'should undo/redo complex interactions between multiple collections', ->
    Posts= new PostCollection
    @collection.create name:'test to update', id:'01'
    @collection.create name:'test to delete', id:'02'

    expect(@collection.length).to.equal 2
    expect(@collection.get('01').get('name')).to.equal 'test to update'
    expect(@collection.get('02').get('name')).to.equal 'test to delete'
    expect(Posts.length).to.equal 0

    @undoMgr.record Posts, @collection, =>
      Posts.create name:'New Post'
      @collection.get('01').set name:'Updated Name'
      @collection.get('02').destroy()

    expect(@collection.length).to.equal 1
    expect(@collection.get('01').get('name')).to.equal 'Updated Name'
    expect(@collection.get('02')).to.be.undefined
    expect(Posts.length).to.equal 1
    expect(Posts.first().get('name')).to.equal 'New Post'

    @undoMgr.undo()
    expect(@collection.length).to.equal 2
    expect(@collection.get('01').get('name')).to.equal 'test to update'
    expect(@collection.get('02').get('name')).to.equal 'test to delete'
    expect(Posts.length).to.equal 0

    @undoMgr.redo()
    expect(@collection.length).to.equal 1
    expect(@collection.get('01').get('name')).to.equal 'Updated Name'
    expect(@collection.get('02')).to.be.undefined
    expect(Posts.length).to.equal 1
    expect(Posts.first().get('name')).to.equal 'New Post'
