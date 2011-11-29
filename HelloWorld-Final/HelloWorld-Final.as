System.security.allowDomain("*");
var _api;

function apiInit(api){
	this._api = api;
	mytext.text = "API initialization successful!";
	_api.message.onTabSwitch = function(tabId) {
		if (_api.config.tab.title(tabId) == "Twitter") {
			mytext.text = "Tweet tweet!";
		}
		else if (_api.config.tab.title(tabId) == "YouTube") {
			mytext.text = "Watch me!";
		}
		else {
			mytext.text = _api.config.placement.front_tab_header;
		}
	};
	_api.ui.switchTab(0);
}
