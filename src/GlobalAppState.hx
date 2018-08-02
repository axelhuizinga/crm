package;
import view.User;


typedef GlobalAppState = 
{
	route: String,
	?hasError:Bool,
	?themeColor:String,
	?locale:String,
	userList:Array<UserState>,
	user:User
}

typedef StatusBarState =
{
	route: String,
	date:Date,
	?hasError:Bool,
	userList:Array<UserState>,
	user:User	
}

typedef AppState =
{
	appWare:GlobalAppState,
	statusBar:StatusBarState
}