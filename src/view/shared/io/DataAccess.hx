package view.shared.io;

/**
 * ...
 * @author axel@cunity.me
 */

import haxe.ds.StringMap;
import view.shared.BaseForm.FormProps;
import view.shared.BaseForm.FormElement;
import view.shared.BaseForm.FormField;
import view.shared.BaseForm.FormState;

/**
   dataClassPath=><action>=>[?'alias',?'fields',?'jCond'] each=>String
**/
   
//typedef DataSource = Map<String,Map<String,Map<String,String>>>;
typedef DataSource = Map<String,Map<String,String>>;

/**
   fieldName=>FormField
**/
   
typedef DataView = Map<String,FormField>;

typedef DataRelation =
{
	source:DataSource,
	view:DataView	
}

/**
   viewClassPath=>DataRelation
**/
   
typedef DataAccess = Map<String,DataRelation>;
