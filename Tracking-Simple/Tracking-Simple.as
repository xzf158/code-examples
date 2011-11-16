import mx.utils.Delegate

System.security.allowDomain("*");
var _api :Object;
var EventArray = [];

function apiInit (inAPI:Object):Void
{
	_api = inAPI;
	MyText.backgroundColor = 0xCCCCCC;

	// Record hover events when the user hovers over the Facebook and
	// Twitter buttons
	FbButton.onRollOver = Delegate.create(this, function () {
		userEvent = _api.logging.createUserEvent(_api.logging.constants.labels.HOVER, "FbButton");
		recordEvent(userEvent, _api.logging.constants.labels.HOVER, "FbButton");
	});
	TwButton.onRollOver = Delegate.create(this, function () {
		userEvent = _api.logging.createUserEvent(_api.logging.constants.labels.HOVER, "TwButton");
		recordEvent(userEvent, _api.logging.constants.labels.HOVER, "TwButton");
	});

	// Record a ButtonClick user event and a MyTabSwitch auto event when the user
	// clicks the Facebook or Twitter button
	FbButton.onRelease = Delegate.create(this, function () {
		_api.ui.switchTabByName("Facebook", null, true);
		userEvent = _api.logging.createUserEvent("ButtonClick", "FbButton");
		recordEvent(userEvent, "ButtonClick", "FbButton");
	});
	TwButton.onRelease = Delegate.create(this, function () {
		_api.ui.switchTabByName("Twitter", null, true);
		userEvent = _api.logging.createUserEvent("ButtonClick", "TwButton");
		recordEvent(userEvent, "ButtonClick", "TwButton");
	});
}

// Track the event and record it in the text field
function recordEvent (userEvent, eventType, eventPayload):Void
{
	_api.logging.trackEvent(userEvent);
	MyText.text += eventType + ", " + eventPayload + "\n";
	MyText.scroll++;
}
