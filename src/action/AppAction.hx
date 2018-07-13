package action;

import model.DataList;

/**
 * @author axel@cunity.me
 */
enum AppAction 
{
	Load;
	SetLocale(locale:String);
	SetEntries(entries:Array<DataCell>);
	
}