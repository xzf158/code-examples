	import Example1_Model.*;
	import Example1_View.*;
	
	import mx.utils.Delegate;

	// The Controller listens for user clicks on the Find, Previous and Next buttons,
	// and makes appropriate third-party API calls and/or Model changes.
	class Example1_Controller
	{
		private var model:Example1_Model;
		private var view:Example1_View;
		private var api:Object;

		// Creator function.
		public function Example1_Controller (api:Object, model:Example1_Model, view:Example1_View)
		{
			// The Controller will have references to the API, Model, and View.
			this.api = api;
			this.model = model;
			this.view = view;

			// Set the callbacks.
			view.FindButton.onRelease = Delegate.create(this, find_callback);
			view.PrevButton.onRelease = Delegate.create(this, prev_callback);
			view.NextButton.onRelease = Delegate.create(this, next_callback);
			
			view.FeedText.text += "Controller initialized.\n";
		}
		
		// When user clicks Previous button, decrease the offset and reload Tweets
		private function prev_callback ()
		{
			model.decrement_offset ();
		}

		// When user clicks Next button, increase the offset and reload Tweets
		private function next_callback ()
		{
			model.increment_offset ();
		}

		// When user clicks the Find button, build the JSON query URL & make the query
		private function find_callback () 
		{
			// This function will also track metrics.
			var json_url:String = "http://search.twitter.com/search.json?q=" + escape(model.search_str) + 
					   "&geocode=" + view.InputLat.text + "," + view.InputLon.text + "," + 
					   view.InputRadius.text + "mi&rpp=100";
			view.FeedText.text += "I'm querying this URL:\n";
			view.FeedText.text += json_url + "\n";
			api.util.json.fetch(json_url, Delegate.create(this, on_fetch_load), 
								Delegate.create(this, on_fetch_error), false);
		}

		// json.fetch load callback; stores the JSON object in a global var, and loads the Tweets
		private function on_fetch_load (obj:Object):Void
		{
			view.FeedText.text += "Twitter returns successfully.\n";
			model.update_tweet_list (obj);
		}

		// json.fetch error callback; displays an error message
		private function on_fetch_error (error):Void
		{
			view.FeedText.text += "Twitter returns error.\n";
			view.FeedText.htmlText = "Twitter Geo Search failed. Please check your Internet connection" +
								     " or contact Flite support.";
		}
	}
