import Example3_Model.*;
import Example3_View.*;
import Example3_Controller.*;

System.security.allowDomain("*");

var _api:Object;

var _model:Example3_Model;
var _view:Example3_View;
var _controller:Example3_Controller;

// Initialize the API as well as the Model, View and Controller.
function apiInit(api:Object):Void
{
	_api = api;

	_view = new Example3_View(this);
	_model = new Example3_Model (_api, _view);
	_controller = new Example3_Controller(_api, _model, _view);
}
