package {	
	import utils.*;
	
	public class ListConfig {
		
		private const DEFAULT_FONT_FAMILY:String = "Helvetica,Arial,_sans";
		private const DEFAULT_FONT_SIZE:Number = 11;
		private const DEFAULT_TWEEN_TIME:uint = 1;
		
		
		private const DEFAULT_CONTENT_PADDING:Number = 5;
		private const DEFAULT_CONTENT_BACK_COLOR:uint = 0xFFFFFF;
		private const DEFAULT_CONTENT_BACK_ALPHA:Number = 1;
		
		private const DEFAULT_STATE_FONT_COLOR:Number = 0xCCCCCC;
		private const DEFAULT_STATE_FONT_BOLD:Boolean = false;
		private const DEFAULT_STATE_BACKGROUND_IMAGE:String = null;
		private const DEFAULT_STATE_SOLID_COLOR:uint = 0x333333;
		private const DEFAULT_STATE_FROM_COLOR:uint = 0x333333;
		private const DEFAULT_STATE_TO_COLOR:uint = 0x000000;
		private const DEFAULT_STATE_ALPHA:Number = 1;
		private const DEFAULT_STATE_FILL_TYPE:String = "solid";
		
		private const DEFAULT_HOVER_STATE_FONT_COLOR:Number = 0xAAAAAA;
		private const DEFAULT_HOVER_STATE_FONT_BOLD:Boolean = false;
		private const DEFAULT_HOVER_SOLID_COLOR:uint = 0x888888;
		private const DEFAULT_HOVER_FROM_COLOR:uint = 0x888888;
		private const DEFAULT_HOVER_TO_COLOR:uint = 0x333333;
		
		private const DEFAULT_ACTIVE_STATE_FONT_COLOR:Number = 0x333333;
		private const DEFAULT_ACTIVE_STATE_FONT_BOLD:Boolean = false;
		private const DEFAULT_ACTIVE_SOLID_COLOR:uint = 0xFFFFFF;
		private const DEFAULT_ACTIVE_FROM_COLOR:uint = 0xFFFFFF;
		private const DEFAULT_ACTIVE_TO_COLOR:uint = 0x888888;
		
		
		private var _config:Object;
		
		public var font:String;
		public var fontSize:Number;
		public var displayThumbnail : Boolean;
		public var separatorColor : uint;
		public var separatorAlpha : Number;
		
		public var contentPadding:Number;
		public var contentBackColor:uint;
		public var contentBackAlpha:Number;
		
		public var activeState:Object;
		public var inactiveState:Object;
		public var hoverState:Object;

		public var tweenTime:Number;
		
		
		public function ListConfig(config:Object):void {
			_config = config;
			
			tweenTime = DEFAULT_TWEEN_TIME;
			
			font = _config.getString("font") || DEFAULT_FONT_FAMILY;
			fontSize = _config.getNumber("font_size") || DEFAULT_FONT_SIZE;
			
			displayThumbnail = _config.getBoolean("display_thumbnail");
			
			contentBackColor = getColor("content_back_color", DEFAULT_CONTENT_BACK_COLOR);
			contentBackAlpha = !isNaN(_config.getNumber("content_back_alpha")) ? _config.getNumber("content_back_alpha") / 100 : DEFAULT_CONTENT_BACK_ALPHA;
			contentPadding = !isNaN(_config.getNumber("content_padding")) ? _config.getNumber("content_padding") : DEFAULT_CONTENT_PADDING;
			
			separatorColor = getColor("separator_color", DEFAULT_ACTIVE_STATE_FONT_COLOR);
			separatorAlpha = getAlpha("separator_color");
			
			activeState = {
					fontColor        : getColor("active_font_color", DEFAULT_ACTIVE_STATE_FONT_COLOR),
					fontWeight       : _config.getBoolean("active_font_bold")          || DEFAULT_ACTIVE_STATE_FONT_BOLD,
					fillType         : _config.getString("active_fill_type") || DEFAULT_STATE_FILL_TYPE,
					solidColor       : getColor("active_solid_color", DEFAULT_ACTIVE_SOLID_COLOR),
					solidAlpha       : getAlpha("active_solid_color", "active_solid_alpha"),
					fromColor        : getColor("active_from_color", DEFAULT_ACTIVE_FROM_COLOR),
					fromAlpha		: getAlpha("active_from_color", "active_from_alpha"),
					toColor          : getColor("active_to_color", DEFAULT_ACTIVE_TO_COLOR),
					toAlpha      	 : getAlpha("active_to_color", "active_to_alpha"),
					backgroundImage  : _config.getString("active_background_image")    || DEFAULT_STATE_BACKGROUND_IMAGE
			};
			
			inactiveState = {
					fontColor        : getColor("inactive_font_color", DEFAULT_STATE_FONT_COLOR),
					fontWeight       : _config.getBoolean("inactive_font_bold")        || DEFAULT_STATE_FONT_BOLD,
					fillType         : _config.getString("inactive_fill_type") || DEFAULT_STATE_FILL_TYPE,
					solidColor       : getColor("inactive_solid_color", DEFAULT_STATE_SOLID_COLOR),
					solidAlpha       : getAlpha("inactive_solid_color", "inactive_solid_alpha"),
					fromColor        : getColor("inactive_from_color", DEFAULT_STATE_FROM_COLOR),
					fromAlpha        : getAlpha("inactive_from_color", "inactive_from_alpha"),
					toColor          : getColor("inactive_to_color", DEFAULT_STATE_TO_COLOR),
					toAlpha       	: getAlpha("inactive_to_color", "inactive_to_alpha"),
					backgroundImage  : _config.getString("inactive_background_image")  || DEFAULT_STATE_BACKGROUND_IMAGE
			};
			
			hoverState = {
					fontColor        : getColor("hover_font_color", DEFAULT_HOVER_STATE_FONT_COLOR),
					fontWeight       : _config.getBoolean("hover_font_bold")           || DEFAULT_HOVER_STATE_FONT_BOLD,
					fillType         : _config.getString("hover_fill_type") || DEFAULT_STATE_FILL_TYPE,
					solidColor       : getColor("hover_solid_color", DEFAULT_HOVER_SOLID_COLOR),
					solidAlpha       : getAlpha("hover_solid_color", "hover_solid_alpha"),
					fromColor        : getColor("hover_from_color", DEFAULT_HOVER_FROM_COLOR),
					fromAlpha    	 : getAlpha("hover_from_color", "hover_from_alpha"),
					toColor          : getColor("hover_to_color", DEFAULT_HOVER_TO_COLOR),
					toAlpha      	 : getAlpha("hover_to_color", "hover_to_alpha"),
					backgroundImage  : _config.getString("hover_background_image")     || DEFAULT_STATE_BACKGROUND_IMAGE
			};
			
		}
		
		private function getColor(key:String, defaultColor:uint):uint {
			if (StringUtils.isBlank(_config.getValue(key))) {
				return defaultColor;
			} else {
				return _config.getColor(key);
			}
		}
		
		// if alpha key passed but color is null, then assume transparent selected. If no alpha key, assume alpha=1. If no alpha key and color key is blank, assume transparent selected.
		private function getAlpha(colorKey:String, alphaKey:String = ""):Number {
			if ( !isNaN(_config.getValue(alphaKey)) ) {
				// We have an alpha key. If there is also a color key value, then use the alpha key value, otherwise transparent was selected.
				return ( !StringUtils.isBlank(_config.getValue(colorKey)) )   ?   _config.getValue(alphaKey)/100 : 0;
			} else {
				// There is no alpha key. If the is also no color key, then transparent is selected, otherwise default to alpha=1
				return ( StringUtils.isBlank(_config.getValue(colorKey)) )  ?  0 : 1;
			}
		}
	}
	
}