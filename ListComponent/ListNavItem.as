package {
	
	import utils.*;
	
	import flash.display.Bitmap;
	import flash.display.CapsStyle;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class ListNavItem
		extends Sprite
	{
		
		private static const UI_FACTOR : Number = 1.2;			// multiply by font size to get thumbnail width and height
		private static const ARROW_FACTOR : Number = 0.9;		// multiply by font size to get arrow height
		private static const VERTICAL_PADDING : uint = 8;		// above and below thumbnail
		private const ICON_OFFSET_X : uint = 20;				// horz. center aligned
		private const LABEL_OFFSET_X : uint = 39;				// left justified
		private const ARROW_OFFSET_X : uint = 17;				// from right, horz. center aligned along this offset
		private const ARROW_COLOR : uint = 0x202020;
		private const ICON_FILL_COLOR : uint = 0xA6A6A6;
		
		private var _id : int;
		private var _description:Object;
		private var _config:ListConfig;
		private var _factory:Object;
		private var _isActive:Boolean;
		private var _width : Number;
		private var _height : Number;
		private var _iconSize : uint;
		private var _iconHolder : Sprite;
		private var _imageLoader:Object;
		
		private var _stateHolder:Sprite;
		private var _inactiveState:Sprite;
		private var _activeState:Sprite;
		private var _hoverState:Sprite;
		
		private var _currentState:Sprite;
		
		public function ListNavItem(id:int, w:Number, description:Object, config:ListConfig, factory:Object) {
			_id = id;
			_width = w;
			_description = description;
			_config = config;
			_factory = factory;
			init();
		}
		
		private function init() : void {
			
			_height = this.height;
			// force icon size to odd #
			_iconSize = ( uint(Math.ceil(UI_FACTOR*_config.fontSize)/2) != Math.ceil(UI_FACTOR*_config.fontSize)/2 ) ? Math.ceil(UI_FACTOR*_config.fontSize) : Math.floor(UI_FACTOR*_config.fontSize);
			trace(ListNavItem, "_iconSize:", _iconSize);
			
			var separator:Sprite = new Sprite();
			var gfx:Graphics = separator.graphics;
			gfx.lineStyle(1, _config.separatorColor, _config.separatorAlpha);
			gfx.moveTo(0, _height - 0.5);
			gfx.lineTo(_width, _height - 0.5);
			
			
			if (_config.displayThumbnail) {
				_iconHolder = new Sprite();
				gfx = _iconHolder.graphics;
				gfx.lineStyle(1, this.ARROW_COLOR, 1, false);
				gfx.beginFill(ICON_FILL_COLOR, 1);
				gfx.drawRoundRect(0, 0, _iconSize, _iconSize, 6, 6);
				gfx.endFill();
				// half-pixel alignment for better rounded corners
				_iconHolder.x = Math.floor(this.ICON_OFFSET_X - _iconHolder.width/2) + 0.5;
				_iconHolder.y = Math.floor( (this._height - _iconHolder.height)/2 ) + 0.5;
				
				var icon : Sprite = new Sprite();
				gfx = icon.graphics;
				gfx.lineStyle(2, ARROW_COLOR, 1, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.MITER);
				gfx.moveTo(0, 2);
				gfx.lineTo(6, 0);
				gfx.lineTo(12, 2);
				gfx.lineTo(12, 9);
				gfx.lineTo(6, 12);
				gfx.lineTo(0, 9);
				gfx.lineTo(0, 2);
				gfx.lineTo(6, 4);
				gfx.lineTo(12, 2);
				gfx.moveTo(6, 4);
				gfx.lineTo(6, 12);
				icon.height = _iconSize*(12/19);
				icon.scaleX = icon.scaleY;
				icon.x = (_iconHolder.width - icon.width)/2;
				icon.y = (_iconHolder.height - icon.height)/2;
				_iconHolder.addChild(icon);
			}
			
			var hit : Sprite = new Sprite();
			gfx = hit.graphics;
			gfx.beginFill(0xFF0000, 0);
			gfx.drawRect(0, 0, this._width, this._height);
			gfx.endFill();
			hit.useHandCursor = true;
			hit.buttonMode = true;
			hit.mouseEnabled = true;
			
			
			//three states
			_stateHolder = new Sprite();
			_inactiveState = makeState(_config.inactiveState);
			_activeState = makeState(_config.activeState);
			_activeState.visible = false;
			_hoverState = makeState(_config.hoverState);
			_hoverState.visible = false;
			
			_currentState = _inactiveState;
			
			_stateHolder.addChild(_inactiveState);
			_stateHolder.addChild(_activeState);
			_stateHolder.addChild(_hoverState);
			
			hit.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			hit.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			hit.addEventListener(MouseEvent.CLICK, mouseClick);
			
			
			this.addChild(_stateHolder);
			this.addChild(separator);
			if (_config.displayThumbnail) {
				this.addChild(_iconHolder);
				loadImage();
			}
			this.addChild(hit);
		}
		
		//////////// Public Methods
		
		public function isActive(bool:Boolean):void {
			trace(ListNavItem, ".isActive id:", _id, bool);
			//switch state
			_isActive = bool;
			_activeState.visible = _isActive;
			_inactiveState.visible = !_isActive;
			_hoverState.visible = false;
			_currentState = (_isActive) ? _activeState : _inactiveState;
		}
		
		public function get id():int {
			return this._id;
		}
		
		public static function getNavItemHeight(fontSize : Number) : uint {
			return Math.ceil(ListNavItem.UI_FACTOR*fontSize + 2*ListNavItem.VERTICAL_PADDING);
		}
		
		override public function get height():Number {
			return getNavItemHeight(_config.fontSize);
		}
		
		
		/////////// Private Methods
		
		private function makeState(stateConfig:Object):Sprite {
			var stateClip:Sprite = new Sprite();
			var offset : uint = (_config.displayThumbnail) ? LABEL_OFFSET_X : _config.fontSize;
			
			var txtFmt:TextFormat = new TextFormat(_config.font, _config.fontSize, stateConfig.fontColor);
			txtFmt.align = TextFormatAlign.LEFT;
			txtFmt.leading = 0;
			txtFmt.bold = stateConfig.fontWeight;
			
			var stateLabel:TextField = new TextField();
			stateLabel.x = offset;
			stateLabel.y = (this._height - _config.fontSize)/2 - 3.5;
			;
			stateLabel.width = this._width - offset - 2*ARROW_OFFSET_X;
			stateLabel.autoSize = TextFieldAutoSize.NONE;
			stateLabel.wordWrap = false;
			stateLabel.selectable = false;
			
			stateLabel.defaultTextFormat = txtFmt;
			stateLabel.text = this._description.label;
			
			var tfhelper:TextFieldHelper = new TextFieldHelper(stateLabel);
			tfhelper.truncateToFitWidth(stateLabel.width, 1, TextFieldHelper.ELLIPSE);
			
			var arrow : Sprite = new Sprite();
			var gfx : Graphics = arrow.graphics;
			gfx.beginFill(stateConfig.fontColor);
			gfx.moveTo(3, 0);
			gfx.lineTo(12, 9);
			gfx.lineTo(3, 19);
			gfx.lineTo(0, 16);
			gfx.lineTo(6, 9);
			gfx.lineTo(0, 3);
			gfx.lineTo(3, 0);
			gfx.endFill();
			arrow.height = _config.fontSize*ARROW_FACTOR;
			arrow.scaleX = arrow.scaleY;
			arrow.x = this._width - this.ARROW_OFFSET_X - arrow.width/2;
			arrow.y = (this._height - arrow.height)/2 - 1;
			
			
			var stateFill:Sprite = makeStateFill(stateConfig, _width, _height);
			
			stateClip.addChild(stateFill);
			stateClip.addChild(arrow);
			stateClip.addChild(stateLabel);
			
			return stateClip;
		}
		
		private function makeStateFill(stateConfig:Object, w:Number, h:Number):Sprite {
			var stateSprite:Sprite = new Sprite();
			var gfx:Graphics = stateSprite.graphics;
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(w, h, 90 / 180 * Math.PI, 0, 0);
			
			
			var colors:Array = new Array();
			var alphas:Array = new Array();
			
			if (stateConfig.fillType === "solid") {
				colors.push(stateConfig.solidColor);
				alphas.push(stateConfig.solidAlpha);
			} else if (stateConfig.fillType === "gradient") {
				colors.push(stateConfig.fromColor, stateConfig.toColor);
				alphas.push(stateConfig.fromAlpha, stateConfig.toAlpha);
			}
			
			stateConfig.backgroundColors = colors;
			stateConfig.backgroundAlphas = alphas;
			
			var ratios:Array = colors.map(function(item:*, index:uint, list:Array):Number { return list.length > 1 ? 0xFF - ((0xFF / (list.length - 1)) * index) : 0xFF; }).reverse();
			
			if (stateConfig.fillType !== "none") {
				gfx.beginGradientFill("linear", colors, alphas, ratios, matrix);
				gfx.drawRect(0, 0, w, h);
				gfx.endFill();
			}
			
			if (stateConfig.fillType === "image" && stateConfig.backgroundImage != null && stateConfig.backgroundImage != "") {
				var bgImage:* = _factory.get_imageLoader();
				var loaderOptions:Object = {
					maxWidth:this._width,
						maxHeight:this._height,
						type:"fill",
						useProxy: true
				};
				bgImage.loadImage(stateConfig.backgroundImage, loaderOptions);
				stateSprite.addChild(bgImage);
				
				var bgImageMask:Sprite = new Sprite();
				bgImageMask.graphics.beginFill(0, 1);
				bgImageMask.graphics.drawRect(0, 0, this._width, this._height);
				bgImageMask.graphics.endFill();
				
				bgImage.mask = bgImageMask;
				stateSprite.addChild(bgImageMask);
			}
			
			return stateSprite;
			
		}
		
		
		private function mouseOver(evt:MouseEvent):void {
			_inactiveState.visible = false;
			_activeState.visible = false;
			_hoverState.visible = true;
		}
		
		private function mouseOut(evt:MouseEvent):void {
			_inactiveState.visible = true;
			_activeState.visible = false;
			_hoverState.visible = false;
		}
		
		private function mouseClick(evt:MouseEvent):void {
			dispatchEvent(new Event(Event.SELECT, false, false));
		}
		
		
		private function loadImage():void {
			_imageLoader = _factory.getImageLoader();
			if (_imageLoader) {
				_imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, trace);
				_imageLoader.contentLoaderInfo.addEventListener(AsyncErrorEvent.ASYNC_ERROR, trace);
				_imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleLoadComplete);
				
				var loaderOptions:Object = new Object;
				loaderOptions.maxWidth = _iconSize;
				loaderOptions.maxHeight= _iconSize;
				loaderOptions.type = "FILL";
				loaderOptions.useProxy = true;
				
				var ctxt: LoaderContext = new LoaderContext(true);
				
				
				var thumbUrl:String = _description.thumbnail;
				
				trace ("ListNavItem", "thumbUrl", thumbUrl);
				
				if (!StringUtils.isBlank(thumbUrl)) {
					try {
						_imageLoader.loadImage(thumbUrl, loaderOptions, ctxt);
					} catch(err:Error) { 
						trace (err.getStackTrace());
					}
				}
			}
		}
		
		private function handleLoadComplete(evnt : Event):void {
			var img:DisplayObject;
			if ( (evnt.target as LoaderInfo).contentType == "application/x-shockwave-flash") {
				img = (_imageLoader as DisplayObject);
			} else {
				try {
					img  = (evnt.target as LoaderInfo).content as Bitmap;
				} catch(err:Error) {
					trace (err.getStackTrace());
					img = (_imageLoader as DisplayObject);
				}
			}
			img.x = ICON_OFFSET_X - _iconSize/2;
			img.y = (_height - _iconSize)/2;
			this.addChild(img);
			this.removeChild(_iconHolder);
		}
		
	}
}
