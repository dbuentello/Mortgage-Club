var $ = require('jquery');

var React = require('react/addons');
var Router = require('react-router');
var DefaultRoute = Router.DefaultRoute;
var Route = Router.Route;
var RouteHandler = Router.RouteHandler;

var FlashHandler = require('mixins/FlashHandler');
var AppStarter = require('tools/AppStarter');
var Loans = require('admin/Loans');
var LoanMemberManagements = require('admin/member_managements/Managements');
var EditPage = require('admin/member_managements/EditPage');

var Lenders = require('admin/lenders/Lenders');
var LenderForm = require('admin/lenders/LenderForm');

var LenderTemplates = require('admin/lenders/LenderTemplates');
var EditTemplate = require('admin/lenders/EditTemplate');

window.AdminApp = React.createClass({
  mixins: [FlashHandler],

  contextTypes: {
    router: React.PropTypes.func
  },

  render: function() {
    var user = this.props.currentUser;

    return (
      <div>
        <nav className='topMenu sticky backgroundInverse pvm zIndexNavigation overlayFullWidth'>
          <div className='plm prl'>
            <div className='row'>
              <div className='col-xs-6 typeLowlight'>
                <a className='mrl' href='/loan_assignments'> MortgageClub </a>
              </div>
              <div className='col-xs-2 text-right pull-right'>
                {user
                ? <div className="dropdown cols10 txtR">
                    <a href="#">{user.firstName}</a>
                    <div className="dropdownBox dropdownBoxRight box boxBasic backgroundLowlight">
                      <ul className="dropdownList">
                        <li><a href="/loan_member_managements" className="dropdownLink">Loan Members</a></li>
                        <li><a href="/loan_assignments" className="dropdownLink">Loan Assignment</a></li>
                        <li><a href="/lenders" className="dropdownLink">Lenders</a></li>
                        <li><a href="/auth/register/edit" className="dropdownLink">Profile</a></li>
                        <li><a href="/auth/logout" className="dropdownLink" data-method='delete'>Log out</a></li>
                      </ul>
                    </div>
                  </div>
                : <span>
                    <a className='linkTypeReversed mrm' href='/auth/login'>
                      Log in
                    </a>
                    <a className='linkTypeReversed mrm' href='/auth/register/signup'>
                      Sign up
                    </a>
                  </span>
                }
              </div>
            </div>
          </div>
        </nav>

        <div className='page-alert'/>

        <RouteHandler bootstrapData={this.props}/>
      </div>
    );
  },

  componentDidMount: function() {
    var flashes = this.props.flashes;
    this.showFlashes(flashes);
  }
});

var routes = (
  <Route name='app' path='/' handler={AdminApp}>
    <Route name='loans' path='/loan_assignments' handler={Loans}/>
    <Route name='loan_member_managements' path='/loan_member_managements' handler={LoanMemberManagements}/>
    <Route path="/loan_member_managements/:id/edit" handler={EditPage}/>
    <Route path="/lenders" handler={Lenders}/>
    <Route path="/lenders/new" handler={LenderForm}/>
    <Route path="/lenders/:id/edit" handler={LenderForm}/>
    <Route path="/lenders/:id/templates" handler={LenderTemplates}/>
    <Route path="/lenders/:id/templates/:id/edit" handler={EditTemplate}/>
    <DefaultRoute handler={Loans}/>
  </Route>
);

$(function() {
  AppStarter.start(routes);
});
