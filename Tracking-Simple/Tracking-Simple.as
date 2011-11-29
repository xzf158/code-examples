import mx.utils.Delegate

System.security.allowDomain("*");
var _api :Object;
var EventArray = [];

function apiInit (inAPI:Object):Void
{
	_api = inAPI;
	MyText.backgroundColor = 0xCCCCCC;

	// Record hover events when the user hovers over the Blog and
	// Twitter buttons
	BlogButton.onRollOver = Delegate.create(this, function () {
		userEvent = _api.logging.createUserEvent(_api.logging.constants.labels.HOVER, "BlogButton");
		recordEvent(userEvent, _api.logging.constants.labels.HOVER, "BlogButton");
	});
	TweetsButton.onRollOver = Delegate.create(this, function () {
		userEvent = _api.logging.createUserEvent(_api.logging.constants.labels.HOVER, "TweetsButton");
		recordEvent(userEvent, _api.logging.constants.labels.HOVER, "TweetsButton");
	});

	// Record a ButtonClick user event and a MyTabSwitch auto event when the user
	// clicks the Blog or Twitter button
	BlogButton.onRelease = Delegate.create(this, function () {
		_api.ui.switchTabByName("Blog", null, true);
		userEvent = _api.logging.createUserEvent("ButtonClick", "BlogButton");
		recordEvent(userEvent, "ButtonClick", "BlogButton");
	});
	TweetsButton.onRelease = Delegate.create(this, function () {
		_api.ui.switchTabByName("Twitter", null, true);
		userEvent = _api.logging.createUserEvent("ButtonClick", "TweetsButton");
		recordEvent(userEvent, "ButtonClick", "TweetsButton");
	});
}

// Track the event and record it in the text field
function recordEvent (userEvent, eventType, eventPayload):Void
{
	_api.logging.trackEvent(userEvent);
	MyText.text += eventType + ", " + eventPayload + "\n";
	MyText.scroll++;
}
