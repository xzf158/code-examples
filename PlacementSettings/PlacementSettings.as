import mx.utils.Delegate    
import flash.geom.Rectangle

System.security.allowDomain("*");

var _api		:Object;

BLUE_LOGO = "http://devflite.squarespace.com/storage/images/flitelogo_blue.png";
ORANGE_LOGO = "http://devflite.squarespace.com/storage/images/flitelogo_orange.png";
GRAY_LOGO = "http://devflite.squarespace.com/storage/images/flitelogo_gray.png";

function apiInit (inAPI:Object):Void		
{
	_api = inAPI;
	
	if (_api.config.placement.TabOrder != "0,1,2") {
		_api.ui.hideContent(0);
		var myrect:Rectangle = new Rectangle (5, 80, 290, 265);
		var taborder:Array = _api.config.placement.TabOrder.split(",");
		var neworder:Array = [Number(taborder[0]), Number(taborder[1]), Number(taborder[2])];
		_api.ui.renderContent(neworder, myrect);
	}
	
	// Load the correct image based on the LogoColor setting 
	var myLoader:Object = _api.ui.factory.getImageLoader();
	if (_api.config.placement.LogoColor == "orange") {
		logo_url = ORANGE_LOGO;
	}
	else if (_api.config.placement.LogoColor == "gray") {
		logo_url = GRAY_LOGO;
	}
	else {
		logo_url = BLUE_LOGO;
	}
	myLoader.loadClip(logo_url, LogoContainer);

	// Once the image loads, set its properties
	myLoader.onLoadInit = function(MyClip:MovieClip) {
		// If LogoLink setting isn't blank, add the specified link
		if (_api.config.placement.LogoLink != "none") {
			MyClip.onPress = Delegate.create(this, function () {
				_api.link.openPage(_api.config.placement.LogoLink);
				});
		}
	};
}

