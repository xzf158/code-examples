import mx.utils.Delegate

System.security.allowDomain("*")
var _api		:Object

function apiInit (inAPI:Object):Void		
{
	_api = inAPI;
	
	// Handle mouse clicks on the header movie clip
	_headerclip.onRelease = Delegate.create (this, handleClick)	
}

// When the user clicks the header movie clip in this base unit, pop up
// the corresponding expansion unit using its GUID.
function handleClick():Void
{
	_api.link.openPopup ( "7229484f-bfea-48a8-9295-42c23824d314", 
						  null,
						  null,
						  null, 
						  "anchor_TL", 
						  false, 
						  false,
						  null
						);
}
