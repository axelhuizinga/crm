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
