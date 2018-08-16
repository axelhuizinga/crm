package action;

//import model.AppService;
import model.UserService.UserAction;
import model.UserService.UserState;

/**
 * @author axel@cunity.me
 */

enum AppAction 
{
	Load;
	LoginReq(state:UserState);
	LoginChange(state:UserState);
	LoginComplete(state:UserState);
	LoginWait;

	LoginError(state:UserState);
	LogOut(state:UserState);	
	//AddContact(id:Int);
	SetLocale(locale:String);
	SetTheme(color:String);
	//Users(filter:UserFilter);
	//SetEntries(entries:Array<DataCell>);
}

enum StatusAction
{
	Tick(date:Date);	
}
