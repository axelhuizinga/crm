const convert = require('koa-connect');
const history = require('connect-history-api-fallback');
const path = require('path');
const DIR_ROOT =  __dirname ;
//
// Webpack documentation is fairly extensive,
// just search on https://webpack.js.org/
//
// Be careful: there are a lot of outdated examples/samples,
// so always check the official documentation!
//

// Plugins
const webpack = require('webpack');
const HtmlWebpackPlugin = require('html-webpack-plugin');
//const CSPWebpackPlugin = require('csp-webpack-plugin');

// Options
const buildMode = process.env.NODE_ENV || 'development';
const debugMode = buildMode !== 'production';
const dist = __dirname + '/bin/';

// Sourcemaps: https://webpack.js.org/configuration/devtool/
// - 'eval-source-map': fast, but JS bundle is somewhat obfuscated
// - 'source-map': slow, but JS bundle is readable
// - undefined: no map, and JS bundle is readable
const sourcemapsMode = debugMode ? 'source-map' : undefined;

//
// Configuration:
// This configuration is still relatively minimalistic;
// each section has many more options
//
module.exports = {
    // List all the JS modules to create
    // They will all be linked in the HTML page
    entry: {
        app: './build.hxml'
    },
    mode: buildMode,
    // Generation options (destination, naming pattern,...)
    output: {
        path: dist,
        filename: 'app.js',
	publicPath: '/'
    },
    // Module resolution options (alias, default paths,...)
    resolve: {
        extensions: ['.js', '.json']
    },
	watch: true,
    // Sourcemaps option for development
    devtool: sourcemapsMode,
    // Live development server (serves from memory)
    devServer: {
        contentBase: dist,
        compress: true,
	host:  '192.168.178.20',
	https: false,
        port: 9000,
        overlay: true,
        hot: true,	    
	inline: true,
	watchOptions:{
		aggregateTimeout:1500
	},	    
	historyApiFallback: {
	      index: 'index.html'
	}
    },
	watchOptions:{
		aggregateTimeout:1500
	},    
    // List all the processors
    module: {
        rules: [
            // Haxe loader (through HXML files for now)
            {
                test: /\.hxml$/,
                loader: 'haxe-loader',
                options: {
                    // Additional compiler options added to all builds
                    extra: '-D build_mode=' + buildMode,
                    debug: debugMode
                }
            },
            // Static assets loader
            // - you will need to adjust for webfonts
            // - you may use 'url-loader' instead which can replace
            //   small assets with data-urls
            {
                test: /\.(gif|png|jpg|svg)$/,
                loader: 'file-loader',
                options: {
                    name: '[name].[hash:7].[ext]'
                }
            },
	    {
                test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/, 
                loader: 'file-loader'
	    },
	    {
                test:  /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/, 
		loader: "url-loader?limit=10000&mimetype=application/font-woff" 
	    },	    
            // CSS processor/loader
            // - this is where you can add sass/less processing,
            // - also consider adding postcss-loader for autoprefixing
            {
                test: /\.css$/,
                use: [
			'style-loader',
			'css-loader'
		]
            }
        ]
    },
    // Plugins can hook to the compiler lifecycle and handle extra tasks
    plugins: [
        // HMR: enable globally
        //new webpack.HotModuleReplacementPlugin(),
        //1HMR: prints more readable module names in the browser console on updates
        new webpack.NamedModulesPlugin(),
        // HMR: do not emit compiled assets that include errors
        new webpack.NoEmitOnErrorsPlugin(),

        // Like generating the HTML page with links the generated JS files
        new HtmlWebpackPlugin({
		filename: dist + './index.html',
		template: __dirname + '/src/index.html',
		title: 'Xpress CRM'
        })/*,
	new CSPWebpackPlugin({
	  'object-src': '\'none\'',
	  'base-uri': '\'self\'',
	  'script-src': ['\'unsafe-inline\'', '\'self\'', '\'unsafe-eval\'','http://ajax.googleapis.com'],
	  'worker-src': ['\'self\'','blob:']
	  })*/
        // You may want to also:
        // - minify/uglify the output using UglifyJSPlugin,
        // - extract the small CSS chunks into a single file using ExtractTextPlugin
        // - avoid modules duplication using CommonsChunkPlugin
        // - inspect your JS output weight using BundleAnalyzerPlugin
    ],
	serve: {
		add: (app, middleware, options) => {
			//console.log('content:' + path.resolve(__dirname, 'bin'));
			//console.log(options);
			//console.log(options.compiler.watchFileSystem);
			//console.log(options.compiler.watch);
			//console.log(Object.keys(options.compiler));
			app.use(convert(history()));
		},
		//autoConfigure: false,
		content: path.resolve(__dirname, 'bin'),
		dev: {
			publicPath: '/bin/',
		},
		host:  '192.168.178.20',
		//hot: true,
		port: 9000,
		open: false
	},	
};
/*
const DIR_ROOT = path.resolve(__dirname, '..');

module.exports = {
	entry: {
		app: path.join(__dirname, 'app.js'),
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
};*/
