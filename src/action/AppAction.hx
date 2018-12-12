package action;

//import model.AppService;
//import model.GlobalAppState.CompState;
import view.shared.io.User;
//import model.UserService.UserAction;
import view.shared.io.User.UserProps;

/**
 * @author axel@cunity.me
 */

enum AppAction 
{
	// COMPONENTS
	//AddComponent(path:String, cState:CompState);
	Load;
	// LOGIN TODO: MOVE TO USERACTIONS
	//LoginReq(state:UserProps);
	LoginChange(state:UserProps);
	LoginComplete(state:UserProps);
	LoginWait;

	LoginError(state:UserProps);
	LogOut(state:UserProps);	
	LoginRequired(state:UserProps);	
	// LOGINEND
	
	//AddContact(id:Int);
	SetLocale(locale:String);
	SetTheme(color:String);

	User(state:UserProps);
	//Users(filter:UserFilter);
	//SetEntries(entries:Array<DataCell>);
}

enum StatusAction
{
	Tick(date:Date);	
}
