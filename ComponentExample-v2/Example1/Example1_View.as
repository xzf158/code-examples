class Example1_View {

	// Display elements from the FLA.
	public var FindButton:MovieClip;
	public var PrevButton:MovieClip;
	public var NextButton:MovieClip;
	public var IntroText:MovieClip;
	public var LatLabel:TextField;
	public var InputLat:TextField;
	public var LonLabel:TextField;
	public var InputLon:TextField;
	public var RadiusLabel:TextField;
	public var InputRadius:TextField;
	public var FeedText:TextField;
	public var my_root:MovieClip;

	// The View controls how the component looks. It contains several functions that are
	// invoked by the Model whenever the Model state changes in a way that requires
	// a View update.
	public function Example1_View (main_view:MovieClip)
	{
		this.my_root = main_view;
		this.FindButton = my_root.FindButton;
		this.PrevButton = my_root.PrevButton;
		this.NextButton = my_root.NextButton;
		this.LatLabel = my_root.LatLabel;
		this.InputLat = my_root.InputLat;
		this.LonLabel = my_root.LonLabel;
		this.InputLon = my_root.InputLon;
		this.RadiusLabel = my_root.RadiusLabel;
		this.InputRadius = my_root.InputRadius;
		this.FeedText = my_root.FeedText;
		this.IntroText = my_root.IntroTextMC;
	}

	// Displays the Tweets in the FeedText area
	public function display_tweets (search_str:String, total_tweets:Number, tweets_per_page:Number,
									display_offset:Number, tweets:Object):Void
	{
		// First, display the search parameters
		FeedText.htmlText = "<b>Search string:</b> " + search_str + "\n" +
							"<b>Lat:</b> " + InputLat.text + ", <b>Lon:</b> " + 
							InputLon.text + ", <b>Radius (miles):</b> " + 
							InputRadius.text + "mi\n\n";

		// Now display the tweets based on the offset, tweets per page, and total tweets values.
		for (var i:Number = display_offset; i < tweets_per_page + display_offset; i++)
		{
			if (i == total_tweets) { break; }

			var input_tweet:String = tweets.results[i].text;

			// Add the user's name in bold to the print string.
			var output_tweet:String = "<b>" + tweets.results[i].from_user + ":</b> ";

			// Break the tweet down into words, format each word appropriately, 
			// and add each one to the print string. For words
			var tweet_words:Array = input_tweet.split(" ");
			for (var j:Number = 0; j < tweet_words.length; j++)
			{
				output_tweet += build_tweet_word(tweet_words[j]);
			}

			// Print each Tweet on a new line
			FeedText.htmlText += output_tweet + "\n";
		}
	}

	// Format a word from the tweet into the format we want to output. If the word
	// starts with "#", "@" or "http", underline it and hyperlink appropriately.
	// Otherwise, just return it as is.
	private function build_tweet_word (item:String):String
	{
		if (item.charAt(0) == '#')
		{
			return ("<u><a href='http://twitter.com/#!/search/%23" + 
					item.substr(1, item.length) + "' target='_blank'>" + 
					item + "</a></u> ");
		}
		else if (item.charAt(0) == '@')
		{
			return ("<u><a href='http://twitter.com/#!/search/%40" + 
					item.substr(1, item.length) + "' target='_blank'>" + item + "</a></u> ");
		}
		else if (item.substr(0,4) == 'http')
		{
			return ("<u><a href='" + item + "' target='_blank'>" + item + "</a></u> ");				
		}
		else 
		{ 
			return (item + " "); 
		}
	}

}