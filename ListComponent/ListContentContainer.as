package {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class  ListContentContainer
		extends Sprite
	{
		private var _initialized:Boolean = false;
		private var _container:MovieClip;
		
		public function ListContentContainer(container : MovieClip) {
			trace(ListContentContainer, " - container:", container);
			_container = container;
			this.addChild(_container);
			trace(ListContentContainer, " - _container:", _container);
		}
		
		public function initialize():void {
			if (!_initialized) {
				_initialized = true;
				_container.initialize();
			}
		}
		
		public function get initialized():Boolean {
			return _initialized;
		}
		
		public function unload():void {
			try {
				_container.unload();
			} catch(err:Error) {}
		}
		
	}
}