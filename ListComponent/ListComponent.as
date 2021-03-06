package {
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.system.Security;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	[Build(type="component")] 
	
	
	public class ListComponent
		extends MovieClip
	{
		private static const HEADER_HEIGHT : uint = 28;
		private static const HEADER_BG_COLOR : uint = 0x000000;
		private static const HEADER_BG_ALPHA : Number = 0.6;
		public static const NEXT_BUTTON_HEIGHT:uint = 10;
		public static const NEXT_BUTTON_WIDTH:uint = 14;
		public static const HEADER_NAV_BUTTON_COLOR:uint = 0x000000;
		public static const HEADER_NAV_TEXT_COLOR:uint = 0xFFFFFF;
		public static const HEADER_NAV_TEXT_FONT:String = "Helvetica";
		public static const HEADER_NAV_TEXT_SIZE:uint = 10;
		public static const HEADER_NAV_BUTTON_HEIGHT:uint = 20;	
		public static const HEADER_NAV_BACK_BUTTON_WIDTH:uint = 40;
		public static const HEADER_NAV_BACK_BUTTON_TRIANGLE_HEIGHT:uint = 10;
		public static const HEADER_NAV_BACK_BUTTON_CURVE_SIZE_X:uint = 3;
		public static const HEADER_NAV_BACK_BUTTON_CURVE_SIZE_Y:uint = 2;
		public static const HEADER_NAV_BACK_BUTTON_MOUSE_OUT_ALPHA:Number = 0.4;
		public static const HEADER_NAV_BACK_BUTTON_MOUSE_OVER_ALPHA:Number = 0.93;
		public static const HEADER_NAV_BACK_BUTTON_MOUSE_DOWN_ALPHA:Number = 0.93;
		
		public namespace flite = "http://www.flite.com/ad/v3/component/namespace";
		
		private var _api:Object;
		private var _metricsHelper : Object;
		private var _label : String;
		private var _rectangle:Rectangle;
		private var _config:ListConfig;
		private var _childNodes:Array;
		private var _holder:MovieClip;
		private var _holderTween:Object;
		private var _navBoxAnimation:Object;
		private var _rendered:Boolean;
		private var _currentChild:int;
		private var _state:String;
		private var _keyMap:Object;
		private var _componentLdrs:Vector.<ListContentContainer>;
		
		private var _listNav:ListNav;
		private var _spinner : MovieClip;
		
		public function ListComponent() {
			Security.allowDomain("*");
			trace (ListComponent);
			_holder = new MovieClip();
			_keyMap = new Object();
			_componentLdrs = new Vector.<ListContentContainer>;
		}
		
		flite function initialize(options:Object):void {
			trace (ListComponent, ".initialize");
			
			_api = options.api;
			_metricsHelper = _api.metrics.getMetricsHelper();
			_label = options.label;
			_rectangle = new Rectangle(0, 0, options.width, options.height);
			_config = new ListConfig(options.config);
			_childNodes = options.children.reverse();
			trace (ListComponent, ".initialize - list component children", _childNodes.length);
			
			_state = options.state;
			
			addContentHolder();
			
			showSpinner();
		}
		
		flite function stateChange(options:Object):void {
			_state = options.state;
			
			if (options.trigger) {
				_metricsHelper = options.trigger;
			}
			
			trace (ListComponent, ".stateChange - _state:", _state);
			
			if (options.state === _api.state.ENABLED) {
				if (!_rendered) {
					addContent();
					addNav();
					_rendered = true;
					hideSpinner();
				}
			} else if (options.state === _api.state.UNLOADED) {
				for (var i:uint = 0, l:uint = _childNodes.length; i < l; i++) {
					_childNodes[i].unlockProperties("x", "y", "width", "height");
				}
				for (i = 0, l = _componentLdrs.length; i < l; i++) {
					_componentLdrs[i].unload();
				}
			}
			
			// if enabled with enabled child, go straight to child
			if (options.child && options.child.key && options.child.state === _api.state.ENABLED) {
				trace (ListComponent, ".stateChange - enabling child key:", options.child.key);
				for (i = 0, l = _childNodes.length; i < l; i++) {
					if (_childNodes[i].componentKey == options.child.key) {
						enableContent(i, _metricsHelper, true);
						break;
					}
				}
			}
			
			var currentChild:Object = _childNodes[_currentChild];
			if (currentChild) {
				_api.state.setState(currentChild.componentKey, _state, _metricsHelper);
			}
			
		}
		
		private function addContentHolder():void {
			
			var backBar : Sprite = new Sprite();
			var gfx : Graphics = backBar.graphics;
			gfx.beginFill(HEADER_BG_COLOR, HEADER_BG_ALPHA);
			gfx.drawRect(this._rectangle.width, 0, this._rectangle.width, HEADER_HEIGHT);
			gfx.endFill();
			
			// Add the "BACK" button...
			var backBtnBg:Sprite = new Sprite();
			backBtnBg.graphics.beginFill(HEADER_NAV_BUTTON_COLOR, HEADER_NAV_BACK_BUTTON_MOUSE_OUT_ALPHA);
			backBtnBg.graphics.lineTo(HEADER_NAV_BACK_BUTTON_WIDTH - HEADER_NAV_BACK_BUTTON_CURVE_SIZE_X, 0);
			backBtnBg.graphics.curveTo(HEADER_NAV_BACK_BUTTON_WIDTH - HEADER_NAV_BACK_BUTTON_CURVE_SIZE_X, 0, HEADER_NAV_BACK_BUTTON_WIDTH, HEADER_NAV_BACK_BUTTON_CURVE_SIZE_Y);
			
			backBtnBg.graphics.lineTo(HEADER_NAV_BACK_BUTTON_WIDTH, HEADER_NAV_BUTTON_HEIGHT - HEADER_NAV_BACK_BUTTON_CURVE_SIZE_Y);
			backBtnBg.graphics.curveTo(HEADER_NAV_BACK_BUTTON_WIDTH, HEADER_NAV_BUTTON_HEIGHT - HEADER_NAV_BACK_BUTTON_CURVE_SIZE_Y, HEADER_NAV_BACK_BUTTON_WIDTH - HEADER_NAV_BACK_BUTTON_CURVE_SIZE_X, HEADER_NAV_BUTTON_HEIGHT);
			backBtnBg.graphics.lineTo(0, HEADER_NAV_BUTTON_HEIGHT);
			backBtnBg.graphics.lineTo(0, 0);
			backBtnBg.graphics.lineTo(-HEADER_NAV_BACK_BUTTON_TRIANGLE_HEIGHT, 0.5 * HEADER_NAV_BUTTON_HEIGHT);
			backBtnBg.graphics.lineTo(0, HEADER_NAV_BUTTON_HEIGHT);
			backBtnBg.graphics.lineTo(0, HEADER_NAV_BUTTON_HEIGHT);
			backBtnBg.graphics.endFill();
			backBtnBg.y = 0.5 * (HEADER_HEIGHT - HEADER_NAV_BUTTON_HEIGHT);
			backBtnBg.x = this._rectangle.width + 20;
			
			var backBtnLabel:TextField = new TextField();
			backBtnLabel.selectable = false;
			backBtnLabel.autoSize = TextFieldAutoSize.LEFT;
			backBtnLabel.multiline = false;
			backBtnLabel.text = "BACK";
			var fmt :TextFormat = new TextFormat(_config.font, HEADER_NAV_TEXT_SIZE, HEADER_NAV_TEXT_COLOR, true, null, null, null, null, null, null, null, null, true);
			backBtnLabel.setTextFormat(fmt);
			backBtnLabel.x = backBtnBg.x + 0.5 * (HEADER_NAV_BACK_BUTTON_WIDTH - backBtnLabel.textWidth - 0.5 * HEADER_NAV_BACK_BUTTON_TRIANGLE_HEIGHT) - 1;
			backBtnLabel.y = backBtnBg.y + 0.5 * (backBtnBg.height - backBtnLabel.textHeight) - 1;
			
			var backBtnHit:Sprite = new Sprite();
			backBtnHit.graphics.beginFill(0xFFFFFF, 0);
			backBtnHit.graphics.drawRect(0, 0, HEADER_NAV_BACK_BUTTON_WIDTH, HEADER_NAV_BUTTON_HEIGHT);
			backBtnHit.graphics.endFill();
			backBtnHit.x = backBtnBg.x;
			backBtnHit.y = backBtnBg.y;
			backBtnHit.buttonMode = true;
			backBtnHit.useHandCursor = true;
			backBtnHit.mouseEnabled = true;
			backBtnHit.addEventListener(MouseEvent.CLICK, function() : void { backBtnBg.alpha = HEADER_NAV_BACK_BUTTON_MOUSE_DOWN_ALPHA; handleBackBtnClick(); } );
			backBtnHit.addEventListener(MouseEvent.MOUSE_OVER, function() : void {backBtnBg.alpha = HEADER_NAV_BACK_BUTTON_MOUSE_OVER_ALPHA} );
			backBtnHit.addEventListener(MouseEvent.MOUSE_OUT, function() : void {backBtnBg.alpha = HEADER_NAV_BACK_BUTTON_MOUSE_OUT_ALPHA} );
			
			_holder.addChild(backBar);
			_holder.addChild(backBtnBg);
			_holder.addChild(backBtnLabel);
			_holder.addChild(backBtnHit);
			
			// content area fill
			var contentPadding:Number = _config.contentPadding;
			var contentBackColor:uint = _config.contentBackColor;
			var contentBackAlpha:Number = _config.contentBackAlpha;
			if (contentBackAlpha > 0) {
				_holder.graphics.beginFill(contentBackColor, contentBackAlpha);
				_holder.graphics.drawRect(contentPadding  + _rectangle.width, contentPadding + HEADER_HEIGHT, _rectangle.width - 2*contentPadding, _rectangle.height - HEADER_HEIGHT - 2*contentPadding);
				_holder.graphics.endFill();
			}
			
			this.addChild(_holder);
			this.addChild(mask);
			
			_holder.mask = mask;
		}
		
		private function addContent():void {
			_childNodes.forEach(addContentItem);
		}
		
		private function addContentItem(node:Object, index:uint, list:Array):void {
			trace (ListComponent, ".addContentItem - index:", index);
			var contentWrapper:Sprite = new Sprite();
			contentWrapper.x = _rectangle.width;
			contentWrapper.y = HEADER_HEIGHT;
			_holder.addChild(contentWrapper);
			
			var componentRect:Rectangle =  new Rectangle(0, 0, _rectangle.width - (_config.contentPadding * 2), _rectangle.height - HEADER_HEIGHT - (_config.contentPadding * 2));
			var componentMask:MovieClip = drawBox(componentRect);
			
			node.x = componentMask.x = _config.contentPadding;
			node.y = componentMask.y = _config.contentPadding;
			node.width = componentRect.width;
			node.height = componentRect.height;
			node.lockProperties("x", "y", "width", "height");
			
			var listLdr : ListContentContainer = new ListContentContainer(_api.factory.getContainer(node) );
			_componentLdrs.push( listLdr );
			listLdr.mask = componentMask;
			
			contentWrapper.addChild(listLdr);
			contentWrapper.addChild(componentMask);
		}
		
		private function addNav():void {
			trace (ListComponent, ".addNav");			
			_listNav = new ListNav(_childNodes, _rectangle, _config, _api, _label, _metricsHelper);
			_listNav.addEventListener(Event.SELECT, navItem_SELECT);
			_holder.addChild(_listNav);
			
		}
		
		private function navItem_SELECT(evt:Event):void {
			var nav:ListNav = evt.currentTarget as ListNav;
			var index:uint = nav.selected || 0;
			var triggerMetricsHelper : Object = _metricsHelper.logInteraction(_metricsHelper.subtype.INTERACTION_NAVIGATE_SUBTYPE, _metricsHelper.mode.MODE_CLICK, _childNodes[index].label, {eventData : {index:index}});
			enableContent(index, triggerMetricsHelper);
		}
		
		
		
		private function enableContent(index:int, triggerMetricsHelper : Object, animate : Boolean = true):void {
			_currentChild = index;
			trace (ListComponent, ".enableContent - switching to content", index);
			
			// If the component you're nav'ing to has not been initialized, queue the transition to run when it's complete.
			if (!_componentLdrs[index].initialized) {
				showSpinner();
				trace (ListComponent, ".enableContent - initializing content", index);
				_componentLdrs[index].addEventListener(Event.COMPLETE, componentInit_COMPLETE, true);
				_componentLdrs[index].visible = false;
				_componentLdrs[index].initialize();
			}
			else { // If the component has been initialized, transition as usual.
				transitionToContent(index, animate);
			}
			
			function componentInit_COMPLETE(event:Event):void
			{
				hideSpinner();
				transitionToContent(index, animate);
				_componentLdrs[index].removeEventListener(Event.COMPLETE, componentInit_COMPLETE, true);
			}
			
			for (var i:uint = 0, l:uint = _childNodes.length; i < l; i++) {
				_api.state.setState(_childNodes[i].componentKey, (i === index) ? _api.state.ENABLED : _api.state.DISABLED, triggerMetricsHelper);
				this._componentLdrs[i].visible = (i === index);
			}
		}
		
		private function disableContent(triggerMetricsHelper : Object):void {
			for (var i:uint = 0, l:uint = _childNodes.length; i < l; i++) {
				_api.state.setState(_childNodes[i].componentKey, _api.state.DISABLED, triggerMetricsHelper);
			}
		}
		
		private function transitionToContent(index:int, animate : Boolean = true):void {
			if (animate) {
				if (!_holderTween) {
					_holderTween = _api.animation.getAnimation(_holder, {duration:_config.tweenTime, easing:{fn:"Exponential", ease:"easeInOut"}});
				}
				_holderTween.run({x: -this._rectangle.width});
			} else {
				_holder.x = -this._rectangle.width;
			}
		}
		
		private function handleBackBtnClick(): void {
			trace (ListComponent, ".handleBackBtnClick");
			_listNav.deselect();
			var triggerMetricsHelper : Object = _metricsHelper.logInteraction(_metricsHelper.subtype.INTERACTION_NAVIGATE_SUBTYPE, _metricsHelper.mode.MODE_CLICK, "Back");
			disableContent(triggerMetricsHelper);
			_holderTween.run({x: 0});
		}
		
		private function drawBox(rectangle:Rectangle, color:int = 0):MovieClip {
			var box:MovieClip = new MovieClip();
			box.graphics.clear();
			box.graphics.beginFill(color, 1);
			box.graphics.drawRect(rectangle.x, rectangle.y, rectangle.width, rectangle.height);
			box.graphics.endFill();
			
			return box;
		}
		
		// Init/add/remove helper methods
		private function showSpinner():void
		{
			if (!_spinner)
			{
				var theme:Object = _api.factory.getTheme();
				_spinner = theme.getSpinner({});
				_spinner.x = _rectangle.x + 0.5 * _rectangle.width; 
				_spinner.y = _rectangle.y + 0.5 * _rectangle.height;
				addChild(_spinner);
			}
			
			_spinner.play();
			_spinner.visible = true;
		}
		private function hideSpinner():void
		{
			if (_spinner)
			{
				_spinner.visible = false;
				_spinner.stop();
			}
		}
	}
	
}