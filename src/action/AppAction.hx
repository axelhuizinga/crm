package action;

import model.AppService;

/**
 * @author axel@cunity.me
 */

enum AppAction 
{
	Load;
	//AddContact(id:Int);
	SetLocale(locale:String);
	SetTheme(color:String);

	//SetEntries(entries:Array<DataCell>);
	
}

enum StatusAction
{
	Tick(date:Date);	
}