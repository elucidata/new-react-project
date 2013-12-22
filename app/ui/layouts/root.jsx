var MissingPage= require('ui/pages/missing'),
    Icon= require('ui/widgets/bootstrap').Icon,
    IconStack= require('ui/widgets/bootstrap').IconStack,
    Button= require('ui/widgets/bootstrap').Button

// Class: RootPage
// Main root element of page. It will change out any sub-pages based on the <AppState>.
module.exports= React.createClass({

  getInitialState: function() {
    if(! this.props.appState )
      throw "appState property required!"
    return this.props.appState;
  },

  componentDidMount: function () {
    $('a[title]', this.getDOMNode()).tooltip({
      placement: 'bottom',
      container: 'body'
    })
  },

  componentWillUnmount: function() {
    $('a[title]', this.getDOMNode()).tooltip('destroy')
  },

  render: function() {
    var page;
    // if(!this.state.loggedIn) 
    //   return <LoginPage appState={ this.state }/>

    try {
      page= require('ui/pages/'+ this.state.currentPage)
    } catch (ex) {
      page= MissingPage
    }

    return (
      <div className="app-root">
        <div className="container">
          <div className="page-header">
            <div className="btn-group btn-group-sm pull-right">
              <Button className={this.navClasses('home')} href="#/">Home</Button>
              <Button className={this.navClasses('missing')} href="#/anything" title="This should trigger the 404 handler...">Missing Link</Button>
            </div>
            <h1>
              <IconStack>
                <Icon className="app-icon fa-stack-2x" fa="certificate"/>
                <Icon className="fa-stack-1x fa-inverse" fa="camera"/>
              </IconStack>
              {this.state.title}
              <small className="app-version"> v{this.state.version}</small>
            </h1>
          </div>
          { page({ appState:this.state }) }
        </div>
        <footer className="container">
          <p className="text-muted">&copy; Me, nowishly.</p>
        </footer>
      </div>
    )
  },

  navClasses: function(page){
    return (page == this.state.currentPage) ? 'active' : ''
    if(page == this.state.currentPage)
      return 'btn btn-default active'
    else
      return 'btn btn-default'
  }


})

              // <a className={this.navClasses('home')} href="#/">Home</a>
              // <a title="This should trigger the 404 handler..." className={this.navClasses('missing')} href="#/junk">Junk</a>
