
// INCOMPLETE!

// Class: Bootstrap
// Simple Bootstrap Grid Components

// Class: Row
// <Row> ... </Row>
var Row= React.createClass({
  render: function() {
    return this.transferPropsTo(
      <div className="row">{ this.props.children }</div>
    )
  }
})

// Class: Column
// <Column md="5" mdOffset="3"> ... </Column>
var Column= React.createClass({

  _buildClass: function(prop) {
    var classname= "", val= null
    if(val= this.props[prop]) classname += ' col-'+ prop +'-'+ val
    if(val= this.props[prop+'Offset']) classname += ' col-'+ prop +'-offset-'+ val
    return classname
  },
  
  _buildClassNames: function() {
    return this._buildClass('xs') +
           this._buildClass('sm') +
           this._buildClass('md') +
           this._buildClass('lg')
  },
  
  render: function() {
    return this.transferPropsTo(
      <div className={ this._buildClassNames() }>{ this.props.children }</div>
    )
  }

})

// Class: Alert
// <Alert dismissable={Boolean:false} type={String:'default'} onClose={Function}> ... </Alert>
var Alert= React.createClass({
  render: function() {
    var alertType= this.props.type || 'default', btn= null
    
    if(this.props.dismissable == true || this.props.dismissable == 'true' ) {
      alertType += ' alert-dismissable'
      btn= <button type="button" onClick={this.props.onClose} className="close" data-dismissX="alert" aria-hidden="true" dangerouslySetInnerHTML={{__html: '&times;'}}/>
    }

    return this.transferPropsTo(
      <div className={"alert alert-"+ alertType}>
        { btn }
        { this.props.children }
      </div>
    )
  }
})

// Class: Icon
// <Icon glyph="cog" /> or <Icon fa="spinner" />
var Icon= React.createClass({
  render: function () {
    if( this.props.glyph )
      var cn= "glyphicon glyphicon-"+ this.props.glyph
    else
      var cn= "fa fa-"+ this.props.fa
    return this.transferPropsTo(<i className={cn} />)
  }
})

module.exports= {
  Alert: Alert,
  Row: Row,
  Column: Column,
  Icon: Icon
}