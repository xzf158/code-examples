import Example2_Model.*;
import Example2_View.*;
import Example2_Controller.*;

System.security.allowDomain("*");

var _api:Object;

var _model:Example2_Model;
var _view:Example2_View;
var _controller:Example2_Controller;

// Initialize the API as well as the Model, View and Controller.
function apiInit(api:Object):Void
{
	_api = api;

	_view = new Example2_View(this);
	_model = new Example2_Model (_api, _view);
	_controller = new Example2_Controller(_api, _model, _view);
}
