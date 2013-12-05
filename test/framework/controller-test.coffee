Controller = require 'framework/controller'
Model= require 'framework/model'
App= require 'framework/app'

class TestController extends Controller
  appEvents:
    'my:app:event': 'didCall'
  dataEvents:
    'change mdl': 'dataChanged'
  initialize: ->
    @eventCount= 0
    @dataChange= no
    @mdl= new Model name:'start'
  didCall: ->
    @eventCount += 1
  dataChanged: ->
    @dataChange= yes

app= new App()

describe 'Framework.Controller', ->
  beforeEach ->
    @controller = new TestController 
      paramName: 'NAME'
      getEventCount: -> @eventCount

  afterEach ->
    @controller.dispose()

  it 'should assign options to object', ->
    expect(@controller.paramName).to.exist
    expect(@controller.paramName).to.equal 'NAME'
    expect(@controller.getEventCount).to.exist

  it 'should reference the current App', ->
    expect(@controller.app).to.exist

  it 'should support simple events', ->
    event_count= 0
    @controller.on 'my:event', ->
      event_count += 1
    
    @controller.trigger('my:event')
    expect(event_count).to.equal 1

    @controller.trigger('my:event')
    expect(event_count).to.equal 2

  it 'should support appEvents', ->
    expect(@controller.eventCount).to.equal 0
    app.trigger('my:app:event')
    expect(@controller.eventCount).to.equal 1

  it 'should support dataEvents', ->
    expect(@controller.dataChange).to.equal no
    @controller.mdl.set name:'finished'
    expect(@controller.dataChange).to.equal yes

  # No longer supported:
  
  # it 'should support disposing nested controllers', ->
  #   c1= new TestController
  #   c2= new TestController
  #   ### By default controllers are children of the app ###
  #   expect(c1.parent).to.equal app
  #   @controller.addChildren [c1, c2]
  #   expect(c1.parent).to.equal @controller
  #   expect(c2.parent).to.equal @controller
  #   @controller.dispose()
  #   expect(c1.parent).to.equal null
  #   expect(c2.parent).to.equal null

  # it 'should support invoking methods in controller chain', ->
  #   c1= new TestController
  #   c2= new TestController
  #   expect(c1.getEventCount).to.be.undefined
  #   expect(c2.getEventCount).to.be.undefined
  #   expect(@controller.getEventCount).to.exist
  #   c1.addChild c2
  #   @controller.addChild c1
  #   expect(c1.parent).to.equal @controller
  #   expect(c2.parent).to.equal c1
  #   expect(c2.invoke('getEventCount')).to.equal @controller.getEventCount()
