// Common webpack configuration used by webpack.hot.config and webpack.rails.config.

var path = require('path');

module.exports = {
  entry: {
    PublicApp: 'PublicApp',
    ClientApp: 'ClientApp',
    AdminApp: 'AdminApp'
  },
  resolve: {
    root: [path.join(__dirname, 'scripts'),
           path.join(__dirname, 'assets/javascripts'),
           path.join(__dirname, 'assets/stylesheets')],
    extensions: ['', '.webpack.js', '.web.js', '.js', '.jsx', '.scss', '.css', 'config.js']
  },
  module: {
    loaders: []
  }
};
