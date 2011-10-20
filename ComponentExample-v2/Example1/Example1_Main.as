import Example1_Model.*;
import Example1_View.*;
import Example1_Controller.*;

System.security.allowDomain("*");

var _api:Object;

var _model:Example1_Model;
var _view:Example1_View;
var _controller:Example1_Controller;

// Initialize the API as well as the Model, View and Controller.
function apiInit(api:Object):Void
{
	_api = api;

	_view = new Example1_View(this);
	_model = new Example1_Model (_api, _view);
	_controller = new Example1_Controller(_api, _model, _view);
}
