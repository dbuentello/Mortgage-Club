// Run like this:
// cd webpack && node server.js

var path = require('path');
var config = require('./webpack.common.config');
var webpack = require('webpack');

config.output = { filename: 'express-bundle.js', // this file is served directly by webpack
                  path: __dirname };
config.module.loaders.push(
  { test: require.resolve('react'), loader: 'expose?React' },
  { test: /\.jsx$/, loaders: ['react-hot', 'es6', 'jsx?harmony'] }
);
config.plugins = [ new webpack.HotModuleReplacementPlugin() ];
config.devtool = 'eval-source-map';

// All the styling loaders only apply to hot-reload, not rails
config.module.loaders.push(
  { test: /\.jsx$/, loaders: ['react-hot', 'es6', 'jsx?harmony'] },
  { test: /\.css$/, loader: 'style-loader!css-loader' },
  { test: /\.scss$/, loader: 'style!css!sass?outputStyle=expanded&imagePath=/assets/images&includePaths[]=' +
    path.resolve(__dirname, './assets/stylesheets')},

  // The url-loader uses DataUrls. The file-loader emits files.
  { test: /\.woff$/,   loader: 'url-loader?limit=10000&minetype=application/font-woff' },
  { test: /\.woff2$/,   loader: 'url-loader?limit=10000&minetype=application/font-woff' },
  { test: /\.ttf$/,    loader: 'file-loader' },
  { test: /\.eot$/,    loader: 'file-loader' },
  { test: /\.svg$/,    loader: 'file-loader' });

module.exports = config;
