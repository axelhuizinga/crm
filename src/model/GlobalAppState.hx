package model;
import model.UserService.UserState;


typedef GlobalAppState = 
{
	config:Dynamic,
	route:String,
	?redirectAfterLogin:String,
	?hasError:Bool,
	?themeColor:String,
	?locale:String,
	userList:Array<UserState>,
	user:UserState
}
