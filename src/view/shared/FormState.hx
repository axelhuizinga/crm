package view.shared;
import js.html.InputEvent;
import js.html.TableRowElement;

typedef FormState =
{
	?action:String,
	?dataClassPath:String,
	//?viewClassPath:String,
	?data:Map<String,Dynamic>,
	//?dataForm:DataAccessForm,
	?dataTable:Array<Map<String,Dynamic>>,
	?clean:Bool,
	?selectedRows:Array<TableRowElement>,
	?handleChange:InputEvent->Void,
	?handleSubmit:Dynamic->Void,	
	?hasError:Bool,
	?isConnected:Bool,
	?loading:Bool,
	?initialState:Dynamic,
	?model:String,
	?fields:Map<String,FormField>,//VIEW FORMFIELDS
	?valuesArray:Array<Map<String,Dynamic>>,//FORMATTED DISPLAY VALUES
	?values:Map<String,Dynamic>,//FORMATTED DISPLAY VALUES
	?section:String,
	?sideMenu:SMenuProps,
	?submitted:Bool,
	?errors:Map<String,String>,
	?title:String
}