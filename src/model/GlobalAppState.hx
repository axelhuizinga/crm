package model;
import haxe.Json;
import haxe.ds.StringMap;
import history.History;
import history.Location;
import model.UserService.UserState;
import model.BaseFormData.FormElement;

typedef CompState = 
{
	clean:Bool,
	matchUrl:String,
	pathname:String,
	formFields:StringMap<Array<FormElement>>,
	isMounted:Bool,
	lastMounted:Date
}

typedef GlobalAppState = 
{
	compState:StringMap<CompState>,
	config:Dynamic,
	?hasError:Bool,
	history:History,
	?locale:String,
	?redirectAfterLogin:String,
	?routeHistory:Array<Location>,
	?themeColor:String,
	userList:Array<UserState>,
	user:UserState
}
