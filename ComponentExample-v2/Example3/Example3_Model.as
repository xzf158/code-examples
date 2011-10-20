import Example3_View.*;

// The Model contains the internal model properties, has various functions that the Controller can
// use to alter those properties, and calls the appropriate View function whenever the Model
// changes in a way that affects the View.
class Example3_Model extends Object
{
	// Major properties.
	public var view:Example3_View;
	public var api:Object;
	
	// State properties that will change based on user input.
	public var tweets:Object;
	public var display_offset:Number;

	// Static properties that are set on initialization and cannot change after that.
	public var search_str:String;
	public var total_tweets:Number;
	public var tweets_per_page:Number;
	public var intro_clickthrough:String;
	
	// Creator function.
	public function Example3_Model (api:Object, view:Example3_View)
	{
		// The Model will have a reference to the API and the View.
		this.api = api;
		this.view = view;

		// Set the content properties.
		this.search_str = api.config.component.SearchStr;
		this.tweets_per_page = Number(api.config.component.TweetsPerPage);
		this.total_tweets = Number(api.config.component.TotalTweets);
		this.display_offset = 0;
		this.intro_clickthrough = api.config.component.IntroClickthru;
		
		// Set content properties
		view.set_content (api.config.component);
		
		// Set the layout properties
		view.set_layout (api.config.component);
		
		// Set the appearance properties
		view.set_appearance (api.config.component);
	}

	// Update the list of tweets, and call on the View to update.
	public function update_tweet_list (obj:Object) :Void
	{
		view.FeedText.text += "Updating tweet list.\n";
		tweets = obj;
		view.display_tweets (search_str, total_tweets, tweets_per_page, display_offset, tweets);
	}

	// Decrease the offset, which determines which tweets from the list are displayed. Then call
	// on the View to update.
	public function decrement_offset () :Void
	{
		if (display_offset > 0) 
		{ 
			display_offset = display_offset - tweets_per_page;
			view.display_tweets (search_str, total_tweets, tweets_per_page, display_offset, tweets);
		}		
	}

	// Increase the offset, which determines which tweets from the list are displayed. Then call
	// on the View to update.
	public function increment_offset () :Void
	{
		if (display_offset < total_tweets - tweets_per_page) 
		{ 
			display_offset = display_offset + tweets_per_page;
			view.display_tweets (search_str, total_tweets, tweets_per_page, display_offset, tweets);
		}
	}

}