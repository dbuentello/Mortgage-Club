// Run like this:
// cd webpack && $(npm bin)/webpack -w --config webpack.rails.config.js
// Note that Foreman (Procfile.dev) has also been configured to take care of this.

// NOTE: All style sheets handled by the asset pipeline in rails

var config = require('./webpack.common.config');

config.entry.push('./scripts/rails_only'); // rails specific assets
config.output = {
  filename: 'webpack-bundle.js',
  path: '../app/assets/javascripts/build'
};

// load jQuery and lodash from cdn or rails asset pipeline
config.externals = {
  jquery: 'var jQuery',
  lodash: 'var _'
};

config.module.loaders.push(
  { test: /\.jsx$/, loaders: ['es6', 'jsx?harmony'] },
  { test: require.resolve('jquery'), loader: 'expose?jQuery' },
  { test: require.resolve('jquery'), loader: 'expose?$' }
);
module.exports = config;

var devBuild = (typeof process.env['BUILDPACK_URL']) === 'undefined';
if (devBuild) {
  console.log('Webpack dev build for Rails');
  module.exports.devtool = 'eval-source-map';
} else {
  console.log('Webpack production build for Rails');
}
