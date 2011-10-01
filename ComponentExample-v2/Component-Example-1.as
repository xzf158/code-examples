import mx.utils.Delegate

System.security.allowDomain("*");
var api :Object;

// Set some variables
var search_str = "happy hour";
var tweets_per_page:Number = 5;
var total_tweets:Number = 100;

var mytweets :Object;
var myoffset = 0;

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
	
	// When user clicks the Find button, build the JSON query URL & make the query
	FindButton.onRelease = Delegate.create(this, function () {
		json_url = "http://search.twitter.com/search.json?q=" + escape(search_str) + "&geocode=" + 
				   InputLat.text + "," + InputLon.text + "," + InputRadius.text + "mi&rpp=100";
		api.util.json.fetch(json_url, fetch_load, fetch_error, false);
	});

	// When user clicks Previous button, decrease the offset and reload Tweets
	PrevButton.onRelease = Delegate.create(this, function () {
		if (myoffset > 0) { 
			myoffset = myoffset - tweets_per_page;
			load_tweets();
		}
	});
	
	// When user clicks Next button, increase the offset and reload Tweets
	NextButton.onRelease = Delegate.create(this, function () {
		if (myoffset < total_tweets - tweets_per_page) { 
			myoffset = myoffset + tweets_per_page;
			load_tweets();
		}
	});
}
