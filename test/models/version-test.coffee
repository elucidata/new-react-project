Version = require('models/version')

describe 'Version Model', ->
  beforeEach ->
    @model= Version

  it 'should exist', ->
    expect(@model).to.exist

  it 'should be a string', ->
    expect(@model).to.be.a 'string'
