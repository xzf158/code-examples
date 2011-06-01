System.security.allowDomain("*");
var _api;

function apiInit(api){
	this._api = api;
	mytext.text = "API initialization successful!";
	_api.message.onTabSwitch = function(tabId) {
		if (_api.config.tab.title(tabId) == "Twitter") {
			mytext.text = "Tweet tweet!";
		}
		else if (_api.config.tab.title(tabId) == "Facebook") {
			mytext.text = "Friend me!";
		}
		else {
			mytext.text = "Chicken feed"
		}
	};
	_api.ui.switchTab(0);
}
