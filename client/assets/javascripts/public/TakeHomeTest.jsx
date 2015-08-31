var React = require('react/addons');

var TakeHomeTest = React.createClass({
  getInitialState: function() {
    return {};
  },

  toggleDemo: function() {
    this.setState({showExample: !this.state.showExample});
  },

  render: function() {
    var data = this.props.data;

    return (
      <section className='page-section pvxl'>
        <div className='container mtxl'>
          <div>
            <p>If you are interested in joining MortgageClub’s engineering team as a full-stack developer, we would love for you to have a go at the challenge below. Depending on your level of interest in MortgageClub and how much of your expertise you want to show us, it may take from about an hour to a couple of days to finish. We ask that you use React.js for this test and leave your code un-minified and readable.</p>
            <p className='mbs'>
              Given the following simplified JSON API, please build a user interface that would allow three travelers Amos, Andy and Evie to view each other’s list of visited as well as planned destinations, and allow them to edit their own. The order of priorities is as followed:
            </p>
            <ol className='mbl'>
              <li>Functionality</li>
              <li>Performance</li>
              <li>User Experience</li>
              <li>Aesthetics</li>
              <li>Device and/or browser support</li>
            </ol>
            <p>The api root is located at <code>https://young-beyond-8772.herokuapp.com</code> and apparently quite spotty with only 90% uptime.</p>
            <p className='backgroundSeattle typeReversed pvs phm rtl rtr mvn'>POST /auth</p>
            <div className='pam bas rbl rbr mbl'>
              <p className='mbm'><code>POST</code> requests to the <code>/auth</code> endpoint log the traveler in and return their authentication bits.</p>
              <p className='mbs'>Example of a valid request:</p>
              <pre>curl -X POST -H "Content-Type: application/json" -d '&#123;"name":"<span className='backgroundSeattle typeReversed phs pvxs roundedCorners'>Name</span>"&#125;' https://young-beyond-8772.herokuapp.com/auth</pre>
              <div>Where <span className='backgroundSeattle typeReversed phs pvxs roundedCorners'>Name</span> is one of the names of the travelers. For the sake of simplicity, we’ll leave the password out.</div>
              <p className='mvs'>The JSON response object will include the traveler’s <code>id</code> and auth <code>token</code> that can be used for subsequent requests.</p>
            </div>

            <p className='backgroundSeattle typeReversed pvs phm rtl rtr mvn'>GET /travelers</p>
            <div className='pam bas rbl rbr mbl'>
              <p className='mbm'><code>GET</code> requests to the <code>/travelers</code> endpoint return the list of all travelers and their destinations.</p>
              <p className='mbs'>Example of a valid request:</p>
              <pre>curl -H "Content-Type: application/json;" -H "Authorization: Token token=<span className='backgroundSeattle typeReversed phs pvxs roundedCorners'>auth</span>" https://young-beyond-8772.herokuapp.com/travelers</pre>
            </div>
            <p className='backgroundSeattle typeReversed pvs phm rtl rtr mvn'>PATCH /travelers/:id</p>
            <div className='pam bas rbl rbr mbl'>
              <p className='mbm'><code>PATCH</code> requests to the <code>/travelers/:id</code> endpoint update the entire destination list of the traveler (who is identified by the id), and return the traveler object including his or her <code>id</code> and the updated list of <code>destinations</code> if successful. Note that this request only succeeds if the traveler identified by <code>:id</code> is also the owner of the auth token in the request header.</p>
              <p className='mbs'>Example of a valid request:</p>
              <pre>curl -X PATCH -H "Content-Type: application/json" -H "Authorization: Token token=<span className='backgroundSeattle typeReversed phs pvxs roundedCorners'>auth</span>" -d '&#123;"destinations": [&#123;"name":"Tokyo", "visited": true&#125;, &#123;"name": "Bali", "visited": false&#125;]&#125;' https://young-beyond-8772.herokuapp.com/travelers/1</pre>
            </div>
          </div>

          <div>PS: Once you finish, please send us the demo of your UI and the source code, be it a zip file, a jsfiddle or codepen link, or a link to a github repo. Below is an example of what the UI may look like. Keep in mind that you can, but you do not have to make your UI the same as this.
            <a className='mlxs clickable' onClick={this.toggleDemo}>{this.state.showExample ? 'Hide example' : 'Show example'}</a>
            {this.state.showExample ?
              <div className='box mvm'>
                <img className='bas roundedCorners' src='https://du4nnals2ft9f.cloudfront.net/assets/pages/travelnotes-f9d9e36eb2205131f84ae7d53ae3b153.gif'/>
              </div>
            : null}
          </div>
        </div>
      </section>
    );
  }
});

module.exports = TakeHomeTest;
