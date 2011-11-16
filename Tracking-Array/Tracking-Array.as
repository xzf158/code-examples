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
		var userEvent = _api.logging.createUserEvent(_api.logging.constants.labels.HOVER, "FbButton");
		recordEvent(userEvent, _api.logging.constants.labels.HOVER, "FbButton");
	});
	TwButton.onRollOver = Delegate.create(this, function () {
		var userEvent = _api.logging.createUserEvent(_api.logging.constants.labels.HOVER, "TwButton");
		recordEvent(userEvent, _api.logging.constants.labels.HOVER, "TwButton");
	});

	// Record a ButtonClick user event and a MyTabSwitch auto event when the user
	// clicks the Facebook or Twitter button
	FbButton.onRelease = Delegate.create(this, function () {
		_api.ui.switchTabByName("Facebook", null, true);
		var userEvent = _api.logging.createUserEvent("ButtonClick", "FbButton");
		recordEvent(userEvent, "ButtonClick", "FbButton");
		var userEvent2 = _api.logging.createAutoEvent("MyTabSwitch", "Facebook");
		recordEvent(userEvent2, "MyTabSwitch", "Facebook");
	});
	TwButton.onRelease = Delegate.create(this, function () {
		_api.ui.switchTabByName("Twitter", null, true);
		var userEvent = _api.logging.createUserEvent("ButtonClick", "TwButton");
		recordEvent(userEvent, "ButtonClick", "TwButton");
		var userEvent2 = _api.logging.createAutoEvent("MyTabSwitch", "Twitter");
		recordEvent(userEvent2, "MyTabSwitch", "Twitter");
	});

	// Set the trackMyEvents function to run every 2 seconds
	setInterval(trackMyEvents, 2000);
}

// Push the new event onto the array and record it in the text field
function recordEvent (userEvent, eventType, eventPayload):Void
{
	EventArray.push (userEvent);
	MyText.text += eventType + ", " + eventPayload + "\n";
	MyText.scroll++;
}

// Track all events stored in the array, and clear the array
function trackMyEvents ():Void
{
	if (EventArray.length > 0) {
		_api.logging.trackEvents(EventArray);
		while (EventArray.length > 0) { EventArray.pop(); }
	}
}
