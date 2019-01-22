package view.shared;
import js.html.InputEvent;
import js.html.TableRowElement;
import react.ReactType;
import react.ReactComponent;
import view.shared.SMenuProps;

typedef FormState =
{
	?action:String,
	?activeComponent:ReactComponent,
	?dataClassPath:String,
	?data:Map<String,Dynamic>,
	?dataTable:Array<Map<String,Dynamic>>,
	?clean:Bool,
	?selectedRows:Array<TableRowElement>,
	?handleChange:InputEvent->Void,
	?handleSubmit:Dynamic->Void,	
	hasError:Bool,
	mounted:Bool,
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