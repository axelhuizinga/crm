import action.AppAction;
import action.HistoryAction;
import model.HistoryWare;
import redux.Redux;
import redux.Store;
import redux.StoreBuilder.*;

class ApplicationStore
{
	static public function create():Store<ApplicationState>
	{
		// store model, implementing reducer and middleware logic
		var historyWare = new HistoryWare();
		
		// create root reducer normally, excepted you must use 
		// 'StoreBuilder.mapReducer' to wrap the Enum-based reducer
		var rootReducer = Redux.combineReducers(
			{
				historyWare: mapReducer(HistoryAction, historyWare)
			}
		);
		
		// create middleware normally, excepted you must use 
		// 'StoreBuilder.mapMiddleware' to wrap the Enum-based middleware
		var middleware = Redux.applyMiddleware(
			mapMiddleware(HistoryAction, historyWare)
		);
		
		// user 'StoreBuilder.createStore' helper to automatically wire
		// the Redux devtools browser extension:
		// https://github.com/zalmoxisus/redux-devtools-extension
		return createStore(rootReducer, null, middleware);
	}
	
	static public function startup(store:Store<ApplicationState>)
	{
		// use regular 'store.dispatch' but passing Haxe Enums!
		/*store.dispatch(TodoAction.Load)
			.then(function(_) {
				store.dispatch(TodoAction.Add('Item 5 (auto)'));
				store.dispatch(TodoAction.Toggle('4'));
			});*/
	}
	
}