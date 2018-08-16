const convert = require('koa-connect');
const history = require('connect-history-api-fallback');
const path = require('path');
const webpack = require('webpack');

const DIR_ROOT = path.resolve(__dirname, '..');

module.exports = {
	entry: {
		app: path.join(DIR_ROOT, 'html', 'js', 'index.js'),
	},
	mode: 'development',
	module: {
		rules: [{
			loader: 'babel-loader',
			include: [
				path.resolve(DIR_ROOT, 'html'),
			],
			query: {
				cacheDirectory: true,
			},
			test: /\.js$/,
		}]
	},
	output: {
		chunkFilename: '[name].js',
		path: path.resolve(DIR_ROOT, 'html', 'build'),
		publicPath: '/build/',
		filename: '[name].js',
	},
	serve: {
		add: (app, middleware, options) => {
			app.use(convert(history()));
		},
		content: path.resolve(DIR_ROOT, 'html'),
		dev: {
			publicPath: '/build/',
		},
		open: true
	},
};
