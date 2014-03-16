HomePage = require 'pages/home'
TestUtils= React.addons.TestUtils
{renderIntoDocument, isCompositeComponent}= TestUtils

describe 'Home Page', ->
  [instance]= []

  beforeEach ->
    instance= (HomePage null)
  
  afterEach ->
    instance= null

  it 'should exist', ->
    expect(
      HomePage
    ).to.exist

    expect(
      instance
    ).to.exist

  it 'should be a React component', ->
    expect(
      isCompositeComponent instance
    ).to.be.true


  it 'should have a few HTML landmarks...', ->
    component= renderIntoDocument instance
    
    expect(
      component
    ).to.exist

    expect(
      component.isMounted()
    ).to.be.true

    $el= $ component.getDOMNode()

    expect(
      $el.is('.home-page')
    ).to.be.true
