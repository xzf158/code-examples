import mx.utils.Delegate    

System.security.allowDomain("*")
var _api		:Object

function apiInit (inAPI:Object):Void		
{
	_api	=	inAPI

	// Position the two videos on the left, and size them appropriately
	var v1_config:Object			= 	_api.config.getContentConfig (1)
		v1_config.width				= 	300
		v1_config.height			= 	250
	_api.ui.factory.getView (vid1, "UpperLeft", v1_config, Delegate.create (this, vidLoaded), null )

	var v2_config:Object			= 	_api.config.getContentConfig (2)
		v2_config.width				= 	300
		v2_config.height			= 	250
	_api.ui.factory.getView (vid2, "LowerLeft", v2_config, Delegate.create (this, vidLoaded), null )

	// Now configure the Twitter and Blog feeds.
	// Let's give each one a different color scheme using Flite's theme colors.
	var twitter_config:Object		=	_api.config.getContentConfig (0)
		twitter_config.width		=	280
		twitter_config.height		=	508
		twitter_config.backgroundColor = _api.util.string.hexStringToInt("#F26136")
		twitter_config.textColor = _api.util.string.hexStringToInt("#ffffff")
		twitter_config.linkColor = _api.util.string.hexStringToInt("#0096c4")
		twitter_config.feedMax = 10
	var blog_config:Object			=	_api.config.getContentConfig (3)
		blog_config.width			=	280
		blog_config.height			=	508
		blog_config.backgroundColor = _api.util.string.hexStringToInt("#a7a9ac")
		blog_config.textColor = _api.util.string.hexStringToInt("#ffffff")
		blog_config.linkColor = _api.util.string.hexStringToInt("#0096c4")

	// Set mouse click handlers on the three buttons, tying each one to a specific view.
	// Make sure to clear out the previous views from the "feeds" MovieClip first.
	TwitterButton.onPress = Delegate.create(this, function () {
		cleanHolder()
		_api.ui.factory.getView (feeds, "Right2", twitter_config, Delegate.create (this, feedLoaded), null )
	});
	
	
	BlogButton.onPress = Delegate.create(this, function () {
		cleanHolder()
		_api.ui.factory.getView (feeds, "Right3", blog_config, Delegate.create (this, feedLoaded), null )
	});

	_api.ui.factory.getView (feeds, "Right3", blog_config, Delegate.create (this, feedLoaded), null )
}

// Give focus to whatever view was just loaded.
function vidLoaded (inContent:Object, inArgs:Object):Void
{
	inContent.hasFocus (true)
}
function feedLoaded (inContent:Object, inArgs:Object):Void
{	
	inContent.hasFocus(true)
}

// Clean all MovieClips from the "feeds" container
function cleanHolder():Void
{
	for (var kill:String in feeds)
	{
		feeds[kill].removeMovieClip()
	}
}
