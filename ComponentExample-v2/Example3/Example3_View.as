class Example3_View {

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
	public function Example3_View (main_view:MovieClip)
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

	public function set_content (config:Object):Void
	{
		if (!config.DisplayRadius)
		{
			InputRadius._visible = false;
			RadiusLabel._visible = false;
			InputRadius.text = "25";
		}
	}

	public function set_appearance (config:Object):Void
	{
		var text_format:TextFormat;
		
		// Set the Intro Text font, size and color.
		text_format = new TextFormat(config.IntroTextFont, Number(config.IntroTextSize),
									 Number("0x" + config.IntroTextColor.substr(1)));
		IntroText.IntroText.setNewTextFormat(text_format);
		IntroText.IntroText.text = config.IntroText;

		// Set the Find Button color and text format.
		var button_color:Color = new Color(FindButton.FindOval);
		button_color.setRGB(Number("0x" + config.ButtonColor.substr(1)));
		text_format = new TextFormat(config.ButtonTextFont, Number(config.ButtonTextSize),
									 Number("0x" + config.ButtonTextColor.substr(1)));
		FindButton.FindText.setNewTextFormat(text_format);
		FindButton.FindText.text = config.ButtonText;
	}

	public function set_layout (config:Object):Void
	{
		var element_position:String;
		
		// Layout
		element_position = config.IntroTextPosition.split(',');
		IntroText._x = Number(element_position[0]);
		IntroText._y = Number(element_position[1]);

		element_position = config.LatLabelPosition.split(',');
		LatLabel._x = Number(element_position[0]);
		LatLabel._y = Number(element_position[1]);

		element_position = config.LatitudeBoxPosition.split(',');
		InputLat._x = Number(element_position[0]);
		InputLat._y = Number(element_position[1]);

		element_position = config.LonLabelPosition.split(',');
		LonLabel._x = Number(element_position[0]);
		LonLabel._y = Number(element_position[1]);

		element_position=config.LongitudeBoxPosition.split(',');
		InputLon._x = Number(element_position[0]);
		InputLon._y = Number(element_position[1]);

		element_position = config.RadiusLabelPosition.split(',');
		RadiusLabel._x = Number(element_position[0]);
		RadiusLabel._y = Number(element_position[1]);

		element_position = config.RadiusBoxPosition.split(',');
		InputRadius._x = Number(element_position[0]);
		InputRadius._y = Number(element_position[1]);

		element_position = config.ButtonPosition.split(',');
		FindButton._x = Number(element_position[0]);
		FindButton._y = Number(element_position[1]);

		element_position = config.TweetBoxPosition.split(',');
		FeedText._x = Number(element_position[0]);
		FeedText._y = Number(element_position[1]);

		element_position = config.PrevButtonPosition.split(',');
		PrevButton._x = Number(element_position[0]);
		PrevButton._y = Number(element_position[1]);

		element_position = config.NextButtonPosition.split(',');
		NextButton._x = Number(element_position[0]);
		NextButton._y = Number(element_position[1]);
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