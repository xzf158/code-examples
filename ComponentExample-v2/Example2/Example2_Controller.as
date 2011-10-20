	import Example2_Model.*;
	import Example2_View.*;
	
	import mx.utils.Delegate;

	// The Controller listens for user clicks on the Find, Previous and Next buttons,
	// and makes appropriate third-party API calls and/or Model changes.
	class Example2_Controller
	{
		private var model:Example2_Model;
		private var view:Example2_View;
		private var api:Object;

		// Creator function.
		public function Example2_Controller (api:Object, model:Example2_Model, view:Example2_View)
		{
			// The Controller will have references to the API, Model, and View.
			this.api = api;
			this.model = model;
			this.view = view;

			// Set the callbacks.
			view.FindButton.onRelease = Delegate.create(this, find_callback);
			view.PrevButton.onRelease = Delegate.create(this, prev_callback);
			view.NextButton.onRelease = Delegate.create(this, next_callback);
			view.InputLat.onSetFocus = Delegate.create(this, lat_click_callback);
			view.InputLon.onSetFocus = Delegate.create(this, lon_click_callback);
			view.InputRadius.onSetFocus = Delegate.create(this, radius_click_callback);
			view.FindButton.onRollOver = Delegate.create(this, find_hover_callback);
			
			view.IntroText.onRelease = Delegate.create(this, intro_text_callback);
			
			view.FeedText.text += "Controller initialized.\n";
		}
		
		// Create a clickthrough link to www.flite.com when the user click the intro text.
		private function intro_text_callback ()
		{
			api.link.openPage("http://www.flite.com");
		}

		// These three click callbacks track when the Latitude, Longitude, and Radius text
		// fields come into focus. The even will be tracked when the field is clicked as
		// well as when it is tabbed to.
		private function lat_click_callback ()
		{
			track_user_event("FieldClick", "Latitude");
		}
		private function lon_click_callback ()
		{
			track_user_event("FieldClick", "Longitude");
		}
		private function radius_click_callback ()
		{
			track_user_event("FieldClick", "Radius");
		}
		
		// When user clicks Previous button: decrease the offset, reload Tweets, and track an event
		private function prev_callback ()
		{
			track_user_event("ButtonClick", "Prev");
			model.decrement_offset ();
		}

		// When user clicks Next button: increase the offset, reload Tweets, and track an event
		private function next_callback ()
		{
			track_user_event("ButtonClick", "Next");
			model.increment_offset ();
		}

		// When user hovers over the Find button, track an event.
		private function find_hover_callback ()
		{
			track_user_event(api.logging.constants.labels.HOVER, "FindButton");
		}

		// When user clicks the Find button, build the JSON query URL & make the query
		private function find_callback () 
		{
			// This function will also track metrics.
			track_user_event("ButtonClick", "Find");
			
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
		
		// This utility function uses the Ad API to create and track an event with the given 
		// label and payload.
		private function track_user_event (label:String, payload:String):Void
		{
			var user_event = api.logging.createUserEvent(label, payload);
			api.logging.trackEvent(user_event);
		}
	}
