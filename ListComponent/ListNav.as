package {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class ListNav
		extends Sprite
	{
		private static const SCROLLBAR_WIDTH : uint = 6;
		private var _childDescriptions:Array;
		private var _config:ListConfig;
		private var _api:Object;
		private var _factory:Object;
		private var _rectangle:Rectangle;
		private var _metricsHelper:Object
		private var _label : String;
		
		private var _container : Sprite;
		private var _selected:int = -1;
		private var _navItems:Vector.<ListNavItem>;
		private var _scrollbar : MovieClip;
		private var _hasScrollbar : Boolean = false;
		private var _startScrollPosition : Number = 0;
		
		public function ListNav(childDescriptions:Array, rectangle:Rectangle, config:ListConfig, api:Object, label : String, metricsHelper:Object) {
			trace(ListNav);
			_childDescriptions = childDescriptions;
			_rectangle = rectangle;
			_config = config;
			_api = api;
			_metricsHelper = metricsHelper;
			_label = label;
			
			_navItems = new Vector.<ListNavItem>;
			_container = new Sprite();
			this.addChild(_container);
			renderNavItems();
		}
		
		private function renderNavItems():void {
			var listHeight : uint = _childDescriptions.length*ListNavItem.getNavItemHeight(_config.fontSize);
			var scrollbarWidth : uint = 0;
			if (listHeight > _rectangle.height) {
				_hasScrollbar = true;
				scrollbarWidth = SCROLLBAR_WIDTH;
			}
			
			var lastY : uint = 0;
			for (var i:uint = 0, l:uint = _childDescriptions.length; i < l; ++i) {
				var navItem:Sprite = new ListNavItem(i, _rectangle.width - scrollbarWidth, _childDescriptions[i], _config, _api.factory);
				navItem.addEventListener(MouseEvent.CLICK, navButton_CLICK);
				navItem.x = 0;
				navItem.y = lastY;
				_navItems.push(navItem);
				_container.addChild(navItem);
				
				lastY += navItem.height;
			}
			
//			if (lastY > _rectangle.height) {
			if (listHeight > _rectangle.height) {
				showScrollbar();
			}
		}
		
		
		private function getScrollbar():MovieClip
		{
			var theme:Object = _api.factory.getTheme();
			var scrollbar:MovieClip = theme.getScrollbar({});
			addChild(scrollbar);
			return scrollbar;
		}
		
		private function showScrollbar():void
		{
			if (_rectangle.height >= _childDescriptions.length*ListNavItem.getNavItemHeight(_config.fontSize) ) {
				return;
			}
			
			if (!_scrollbar)
			{				
				_scrollbar = getScrollbar();
				_scrollbar.init(_rectangle.height, _rectangle.height, _container, new Point(0, 0));
				_scrollbar.x = _rectangle.width - SCROLLBAR_WIDTH;
				_scrollbar.y = 0;
				
				_scrollbar.addEventListener(Event.SCROLL, function(e:Event):void
				{
					_metricsHelper.logInteraction(_metricsHelper.subtype.INTERACTION_SCROLL_SUBTYPE, _metricsHelper.mode.MODE_DRAG, _label, {eventData : {from:_childDescriptions[getTopChildIndex(e.target.from)].label, to:_childDescriptions[getTopChildIndex(e.target.to)].label}});
				});
			}
			else
			{
				_scrollbar.show();
			}
		}
		
		private function hideScrollbar():void
		{
			trace('hiding scrollbar for list view',_scrollbar);			
			if (_scrollbar)
			{
				_scrollbar.hide();
			}
		}
		
		// index of highest fully-visible child layer
		private function getTopChildIndex(yCoord : Number) : uint {
			return Math.ceil(yCoord/ListNavItem.getNavItemHeight(_config.fontSize));
		}
		
		
		private function navButton_CLICK(evt:MouseEvent):void {
			var nav:ListNavItem = evt.currentTarget as ListNavItem;
			trace (ListNav, "navButton_CLICK:", nav.id);
			select(nav.id);
			dispatchEvent(new Event(Event.SELECT, false, false));
		}
		
		
		private function select(id:int):void {
			trace (ListNav, "select:", id);
			_selected = id;
			for (var i:uint = 0, l:uint = _navItems.length; i < l; i++) {
				_navItems[i].isActive(i === id);
			}
		}
		
		public function deselect():void {
			for (var i:uint = 0, l:uint = _navItems.length; i < l; i++) {
				_navItems[i].isActive(false);
			}
		}
		
		public function get selected():int {
			return _selected;
		}
	}
}
