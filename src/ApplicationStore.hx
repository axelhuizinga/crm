import action.AppAction;
import action.HistoryAction;
import model.AppService;
import model.StatusBarService;
import model.UserService;
import redux.Redux;
import redux.Store;
import redux.StoreBuilder.*;
import redux.thunk.Thunk;
import redux.thunk.ThunkMiddleware;
import AppState;

class ApplicationStore
{
	static public function create():Store<AppState>
	{
		// store model, implementing reducer and middleware logic
		var appWare = new AppService();
		var statusBarService = new StatusBarService();
		var userService = new UserService();
		
		// create root reducer normally, excepted you must use 
		// 'StoreBuilder.mapReducer' to wrap the Enum-based reducer
		var rootReducer = Redux.combineReducers(
			{
				appWare: mapReducer(AppAction, appWare),
				statusBar: mapReducer(StatusAction, statusBarService),
				userService: mapReducer(UserAction, userService)
			}
		);
		
		// create middleware normally, excepted you must use 
		// 'StoreBuilder.mapMiddleware' to wrap the Enum-based middleware
		var middleware = Redux.applyMiddleware(
			mapMiddleware(Thunk, new ThunkMiddleware({custom: "data"})),
			//mapMiddleware(StatusAction, statusBarService)
			mapMiddleware(AppAction, appWare)
		);
		
		// user 'StoreBuilder.createStore' helper to automatically wire
		// the Redux devtools browser extension:
		// https://github.com/zalmoxisus/redux-devtools-extension
		return createStore(rootReducer, null, middleware);
	}
	
	static public function startup(store:Store<AppState>)
	{
		trace(store);
		// use regular 'store.dispatch' but passing Haxe Enums!
		/*store.dispatch(TodoAction.Load)
			.then(function(_) {
				store.dispatch(TodoAction.Add('Item 5 (auto)'));
				store.dispatch(TodoAction.Toggle('4'));
			});*/
	}
	
}