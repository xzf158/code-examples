import mx.utils.Delegate
import flash.geom.Rectangle

System.security.allowDomain("*");
var api :Object;
var EventArray = [];

function apiInit (inAPI:Object):Void
{
	api = inAPI;
	MyText.backgroundColor = 0xCCCCCC;

	// Record hover events when the user hovers over the Facebook and
	// Twitter buttons
	FbButton.onRollOver = Delegate.create(this, function () {
		userEvent = api.logging.createUserEvent(api.logging.constants.labels.HOVER, 
												"FbButton");
		recordEvent(userEvent, api.logging.constants.labels.HOVER, "FbButton");
	});
	TwButton.onRollOver = Delegate.create(this, function () {
		userEvent = api.logging.createUserEvent(api.logging.constants.labels.HOVER,
												"TwButton");
		recordEvent(userEvent, api.logging.constants.labels.HOVER, "TwButton");
	});

	// Record a ButtonClick user event and a MyTabSwitch auto event when the user
	// clicks the Facebook or Twitter button
	FbButton.onRelease = Delegate.create(this, function () {
		api.ui.switchTabByName("Facebook", null, true);
		userEvent = api.logging.createUserEvent("ButtonClick", "FbButton");
		recordEvent(userEvent, "ButtonClick", "FbButton");
	});
	TwButton.onRelease = Delegate.create(this, function () {
		api.ui.switchTabByName("Twitter", null, true);
		userEvent = api.logging.createUserEvent("ButtonClick", "TwButton");
		recordEvent(userEvent, "ButtonClick", "TwButton");
	});
}

// Track the event and record it in the text field
function recordEvent (userEvent, eventType, eventPayload):Void
{
	api.logging.trackEvent(userEvent);
	MyText.text += eventType + ", " + eventPayload + "\n";
	MyText.scroll++;
}
