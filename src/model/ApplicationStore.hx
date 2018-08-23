package model;

import action.AppAction;
import action.LocationAction;
import history.Action;
import history.History;
import history.Location;
import history.TransitionManager;
import model.AppService;
import model.LocationService;
import model.StatusBarService;
import model.UserService;
import redux.Redux;
import redux.Store;
import redux.StoreBuilder.*;
import redux.thunk.Thunk;
import redux.thunk.ThunkMiddleware;
import model.AppState;

class ApplicationStore
{
	static public function create():Store<model.AppState>
	{
		// store model, implementing reducer and middleware logic
		var appWare = new AppService();
		var locationService = new LocationService();
		var statusBarService = new StatusBarService();
		//var userService = new UserService();
		
		// create root reducer normally, excepted you must use 
		// 'StoreBuilder.mapReducer' to wrap the Enum-based reducer
		var rootReducer = Redux.combineReducers(
			{
				appWare: mapReducer(AppAction, appWare),
				//locationService: mapReducer(LocationAction, locationService),
				statusBar: mapReducer(StatusAction, statusBarService)
				//userService: mapReducer(UserAction, userService)
			}
		);
		
		// create middleware normally, excepted you must use 
		// 'StoreBuilder.mapMiddleware' to wrap the Enum-based middleware
		var middleware = Redux.applyMiddleware(
			mapMiddleware(Thunk, new ThunkMiddleware()),
			//mapMiddleware(StatusAction, statusBarService)
			mapMiddleware(AppAction, appWare)
			//mapMiddleware(LocationAction, locationService)
		);
		
		// use 'StoreBuilder.createStore' helper to automatically wire
		// the Redux devtools browser extension:
		// https://github.com/zalmoxisus/redux-devtools-extension
		return createStore(rootReducer, null, middleware);
	}
	
	static public function startHistoryListener(store:Store<model.AppState>, history:History):TUnlisten
	{
		trace(store);
		store.dispatch(InitHistory(history));
		/*store.dispatch(LocationChange({
			pathname:location.pathname,
			search: location.search,
			hash: location.hash
		}));	*/
		
		return history.listen( function(location:Location, action:history.Action){
			trace(action);
			trace(location);
			store.dispatch(LocationChange({
				pathname:location.pathname,
				search: location.search,
				hash: location.hash,
				key:null,
				state:null
			}));
		});
	}
	
}