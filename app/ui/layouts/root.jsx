var MissingPage= require('ui/pages/missing')

// Class: RootPage
// Main root element of page. It will change out any sub-pages based on the <AppState>.
module.exports= React.createClass({

  getInitialState: function() {
    if(! this.props.appState )
      throw "appState property required!"
    return this.props.appState;
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
              <a className={this.navClasses('home')} href="#/">Home</a>
              <a className={this.navClasses('missing')} href="#/junk">Junk</a>
            </div>
            <h1>{this.state.title} <small className="app-version"> v{this.state.version}</small></h1>
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
    if(page == this.state.currentPage)
      return 'btn btn-default active'
    else
      return 'btn btn-default'
  }


})