import mx.utils.Delegate    
import flash.geom.Rectangle

System.security.allowDomain("*");

var _api		:Object;
var scrollbar	:Object;
var ScrollText	:Object;

function apiInit (AdAPI:Object):Void		
{
	_api = AdAPI;
	ScrollContent.setMask (ScrollArea);

	// Create the text area that will hold the feed, and
	// set up its parameters.
	ScrollText = ScrollContent.createTextField("ScrollContentText", 
								 ScrollContent.getNextHighestDepth(),
								 0, 0, ScrollContent._width,
								 ScrollContent._height);
	ScrollText.multiline = true;
	ScrollText.wordWrap = true;
	ScrollText.html = true;
	ScrollText.autoSize = true;
	ScrollText.textColor = 0xFFFFFF;

	// Obtain the scrollbar from the first tab and place it
	// in the scrollerClip movie clip.
	var scrollbar_config:Object = _api.config.getContentConfig (0);
	_api.ui.factory.getScrollBar (scrollerClip, "scroller", 
			scrollbar_config, Delegate.create(this, scrollbarLoaded), null);

	// Hiding existing content, and load the blog into the text area
	_api.ui.hideContent(0);
	var blogFeed:String = "http://www.flite.com/blog/rss.xml";
	var newsFeed:String = "http://www.flite.com/in-the-news/rss.xml";
	loadBlog();
		
	// Set up click handlers for the two buttons to load the
	// Flite Blog and News feeds.
	BlogButton.onRelease = Delegate.create(this, loadBlog);
	NewsButton.onRelease = Delegate.create(this, loadNews);
}

// Use the feed parser API to load 4 random entries from the
// Flite blog.
function loadBlog ():Void
{
	var myParser:Object = _api.ui.factory.getFeedParser();
	myParser.addEventListener ("onLoadComplete", this);
	myParser.maxArticles = 4;
	myParser.isRandom = true;
	myParser.loadProxiedFeed ("http://www.flite.com/blog/rss.xml");
}

// Use the feed parser API to load 2 random entries from the
// Flite news feed.
function loadNews ():Void
{
	var myParser:Object = _api.ui.factory.getFeedParser();
	myParser.addEventListener ("onLoadComplete", this);
	myParser.maxArticles = 2;
	myParser.isRandom = true;
	myParser.loadProxiedFeed ("http://www.flite.com/in-the-news/rss.xml");
}

// Initialize, show and enable the scrollbar once it is loaded.
// The scrollbar will scroll the loaded text inside the ScrollArea mask.
// Its size is 20 pixels shorter than the scroll area, with 10 pixels
// above and below.
function scrollbarLoaded(sbar:Object, args:Array):Void
{
	scrollbar = sbar;
	scrollbar.init(ScrollArea._height - 20, ScrollArea._height, ScrollText);
	scrollbar._y = 10;
	scrollbar.show();
	scrollbar.enable();
}

// Display the feed in the text area once it is loaded
function onLoadComplete (results:Object)
{                  
	var articles:Array = results.articles;
	var s:String = "";
	ScrollText.htmlText = "";

	// For each entry, add a hyperlinked title, a hyperlinked image is it
	// exists, and the text of the entry.
	for ( var i:Number = 0 ; i <  articles.length ; i++)
	{
		s += "<p><a href = '" + articles[i].linkUrl + 
			 "' target='_blank'><b><font size = '+6'>" + 
			 articles[i].headline + "</font></b></a><br/>";
		if (articles[i].imageSource) {
			s += "<a href = '" + articles[i].linkUrl + 
				 "' target='_blank'><img align = 'left' width = '100' height ='75' src = '" + 
				 articles[i].imageSource + "'></a>";
		}
		s += articles[i].description + "</p><br/>";
	}
	ScrollText.htmlText += s;
	
	// Adjust the scrollbar for the newly loaded feed. Disable it
	// if the text is smaller than the scroll area; enable otherwise.
	scrollbar.adjust();
	if (ScrollText._height < ScrollArea._height) { scrollbar.disable (); }
	else { scrollbar.enable (); }
}
