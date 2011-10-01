import mx.utils.Delegate

System.security.allowDomain("*");
var api :Object;

// Set some variables
var search_str = "happy hour";
var tweets_per_page :Number = 5;
var total_tweets :Number = 100;

var mytweets :Object;
var myoffset :Number = 0;

// Displays the Tweets in the FeedText area
function load_tweets ():Void
{
	// First, display the search parameters
	FeedText.htmlText = "<b>Search string:</b> " + search_str + "\n";
	FeedText.htmlText += "<b>Lat:</b> " + InputLat.text + ", <b>Lon:</b> " + InputLon.text + 
						 ", <b>Radius (miles):</b> " + InputRadius.text + "mi\n\n";

	// Now display the Tweets based on the offset, tweets per page, and total tweets values
	for (i = myoffset; i < (tweets_per_page + myoffset); i++)
	{
		// If we've reached the total number of tweets, break the loop
		if (i == total_tweets) { break; }
		
		// Add the user's name in bold to the print string
		s = "<b>" + mytweets.results[i].from_user + ":</b> ";
		user_tweet = mytweets.results[i].text;

		// Break the Tweet down into words, and add each one to the print string. For words
		// starting in "#", "@" or "http", underline them and hyperlink appropriately.
		var tweet_words:Array = user_tweet.split(" ");
		for (j=0; j<tweet_words.length; j++)
		{
			item = tweet_words[j];
			if (item.charAt(0) == '#')
			{
				s += "<u><a href='http://twitter.com/#!/search/%23" + 
					 item.substr(1,item.length) + "' target='_blank'>" + 
					 item + "</a></u> ";
			}
			else if (item.charAt(0) == '@')
			{
				s += "<u><a href='http://twitter.com/#!/search/%40" + 
					 item.substr(1,item.length) + "' target='_blank'>" + item + "</a></u> ";
			}
			else if (item.substr(0,4) == 'http')
			{
				s += "<u><a href='" + item + "' target='_blank'>" + item + "</a></u> ";				
			}
			else { s += item + " "; }
		}
		// Print each Tweet on a new line
		FeedText.htmlText += s + "\n"
	}
}

// json.fetch load callback; stores the JSON object in a global var, and loads the Tweets
function fetch_load (obj):Void
{
	mytweets = obj;
	load_tweets ();
}

// json.fetch error callback; displays an error message
function fetch_error (error):Void
{
	FeedText.htmlText = "Twitter Geo Search failed. Please check your Internet connection" +
						" or contact Flite support.";
}

function apiInit (inAPI:Object):Void
{
	api = inAPI;
	
	// Use config params to set internal variables
	search_str = api.config.component.SearchStr;
	tweets_per_page = Number(api.config.component.TweetsPerPage);
	total_tweets = Number(api.config.component.TotalTweets);
	if (!api.config.component.DisplayRadius)
	{
		InputRadius._visible = false;
		RadiusLabel._visible = false;
		InputRadius.text = 25;
	}
	
	// Appearance
	tf = new TextFormat(api.config.component.IntroTextFont, 
						Number(api.config.component.IntroTextSize),
						Number("0x" + api.config.component.IntroTextColor.substr(1)));
	IntroTextMC.IntroText.setNewTextFormat(tf);
	IntroTextMC.IntroText.text = api.config.component.IntroText;
	
	var button_color:Color = new Color(FindButton.FindOval);
	button_color.setRGB(Number("0x" + api.config.component.ButtonColor.substr(1)));
	tf = new TextFormat(api.config.component.ButtonTextFont, 
						Number(api.config.component.ButtonTextSize),
						Number("0x" + api.config.component.ButtonTextColor.substr(1)));
	FindButton.FindText.setNewTextFormat(tf);
	FindButton.FindText.text = api.config.component.ButtonText;
	
	// Layout
	introtext_pos = api.config.component.IntroTextPosition.split(',');
	IntroTextMC._x = introtext_pos[0];
	IntroTextMC._y = introtext_pos[1];

	latlabel_pos = api.config.component.LatLabelPosition.split(',');
	LatLabel._x = latlabel_pos[0];
	LatLabel._y = latlabel_pos[1];

	latbox_pos = api.config.component.LatitudeBoxPosition.split(',');
	InputLat._x = latbox_pos[0];
	InputLat._y = latbox_pos[1];
	
	lonlabel_pos = api.config.component.LonLabelPosition.split(',');
	LonLabel._x = lonlabel_pos[0];
	LonLabel._y = lonlabel_pos[1];

	lonbox_pos = api.config.component.LongitudeBoxPosition.split(',');
	InputLon._x = lonbox_pos[0];
	InputLon._y = lonbox_pos[1];

	radlabel_pos = api.config.component.RadiusLabelPosition.split(',');
	RadiusLabel._x = radlabel_pos[0];
	RadiusLabel._y = radlabel_pos[1];

	radbox_pos = api.config.component.RadiusBoxPosition.split(',');
	InputRadius._x = radbox_pos[0];
	InputRadius._y = radbox_pos[1];

	button_pos = api.config.component.ButtonPosition.split(',');
	FindButton._x = button_pos[0];
	FindButton._y = button_pos[1];
	
	feed_pos = api.config.component.TweetBoxPosition.split(',');
	FeedText._x = feed_pos[0];
	FeedText._y = feed_pos[1];

	button_pos = api.config.component.PrevButtonPosition.split(',');
	PrevButton._x = button_pos[0];
	PrevButton._y = button_pos[1];

	button_pos = api.config.component.NextButtonPosition.split(',');
	NextButton._x = button_pos[0];
	NextButton._y = button_pos[1];
	
	// When user clicks the Find button, build the JSON query URL, make the query, & track event
	FindButton.onRelease = Delegate.create(this, function () {
		var userEvent = api.logging.createUserEvent("ButtonClick", "Find");
		api.logging.trackEvent(userEvent);
		json_url = "http://search.twitter.com/search.json?q=" + escape(search_str) + "&geocode=" + 
				   InputLat.text + "," + InputLon.text + "," + InputRadius.text + "mi&rpp=100";
		api.util.json.fetch(json_url, fetch_load, fetch_error, false);
	});

	// When user clicks Previous button, decrease the offset, reload Tweets, & track an event
	PrevButton.onRelease = Delegate.create(this, function () {
		var userEvent = api.logging.createUserEvent("ButtonClick", "Prev");
		api.logging.trackEvent(userEvent);
		if (myoffset > 0) { 
			myoffset = myoffset - tweets_per_page;
			load_tweets();
		}
	});
	
	// When user clicks Next button, increase the offset, reload Tweets, & track an event
	NextButton.onRelease = Delegate.create(this, function () {
		var userEvent = api.logging.createUserEvent("ButtonClick", "Next");
		api.logging.trackEvent(userEvent);
		if (myoffset < total_tweets - tweets_per_page) { 
			myoffset = myoffset + tweets_per_page;
			load_tweets();
		}
	});
	
	// Track field clicks
	InputLat.onSetFocus = Delegate.create(this, function () {
			var userEvent = api.logging.createUserEvent("FieldClick", "Latitude");
			api.logging.trackEvent(userEvent);
	});
	InputLon.onSetFocus = Delegate.create(this, function () {
			var userEvent = api.logging.createUserEvent("FieldClick", "Longitude");
			api.logging.trackEvent(userEvent);
	});
	InputRadius.onSetFocus = Delegate.create(this, function () {
			var userEvent = api.logging.createUserEvent("FieldClick", "Radius");
			api.logging.trackEvent(userEvent);
	});

	// Track mouse hovers over Find button
	FindButton.onRollOver = Delegate.create(this, function () {
		var userEvent = api.logging.createUserEvent(api.logging.constants.labels.HOVER, "FindButton");
		api.logging.trackEvent(userEvent);
	});
	
	// Create clickthrough
	IntroTextMC.onRelease = Delegate.create(this, function () {
		api.link.openPage(api.config.component.IntroClickthru);
	});
	
}
