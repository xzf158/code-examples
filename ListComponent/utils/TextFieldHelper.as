package utils {
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    
    public class TextFieldHelper {

        public static var ELLIPSE:String = "\u2026";

        private var _textField:TextField;
        
        public function TextFieldHelper(textField:TextField){
            _textField = textField;
        }
        
        public function truncateToFitWidth(maxWidth:uint, maxLines:uint = 1, ellipse:String = "", useHTML:Boolean = false):TextField{
            var textFormat:TextFormat = _textField.getTextFormat();
            if(!ellipse){
                ellipse = "";
            }
            
            trace("Truncating text to fit: " + _textField.text + ", w: " + maxWidth + ", lines: " + maxLines);
            
            _textField.autoSize = TextFieldAutoSize.LEFT;
            var textToShorten:String = _textField.text;
            if(maxLines == 1){
                if(_textField.getLineMetrics(0).width > maxWidth) {
                    var charInd:int = Math.ceil(maxWidth / _textField.getLineMetrics(0).width * textToShorten.length);
                    if(charInd > 0){
                        textToShorten = textToShorten.substr(0, charInd);
                        updateText(addEllipse(textToShorten, ellipse), textFormat);
                    }
                    while(_textField.getLineMetrics(0).width > maxWidth && _textField.text !== ellipse && _textField.getLineMetrics(0).width > 0) {
                        textToShorten = textToShorten.substr(0, textToShorten.length - 1);
                        updateText(addEllipse(textToShorten, ellipse), textFormat);
                    }
                }
            } else {
                _textField.wordWrap = true;
                _textField.multiline = true;
                _textField.width = maxWidth;
                var first:Boolean = true;
                var maxChars:uint = Math.round(maxWidth/2)*maxLines;
                while(maxLines < _textField.numLines) {
                    trace("textfield has " + _textField.numLines + " lines");
                    
                    var numCharactersToDrop:uint = first && (textToShorten.length > maxChars) ? (textToShorten.length - maxChars) : (ellipse.length + _textField.getLineText(_textField.numLines - 1).length);
                    //trace("Dropping",numCharactersToDrop,"characters.");
                    textToShorten = textToShorten.substr(0, textToShorten.length - numCharactersToDrop);
                    updateText(addEllipse(textToShorten, ellipse), textFormat);
                    first = false;
                }
            }
            
            return _textField;
        }
        
        public function truncateToFit(maxWidth:int, maxHeight:int, ellipse:String, useHTML:Boolean = false, atLeastOneLine:Boolean = true):TextField{
            //      trace("Truncating text to fit: " + (useHTML ? _textField.htmlText : _textField.text) + ", w: " + maxWidth + ", h: " + maxHeight);
            trace("Truncating text to fit, w: " + maxWidth + ", h: " + maxHeight);
            var maxLines:int = Math.floor((maxHeight - 4)/_textField.getLineMetrics(0).height); //account for 2px gutter top and bottom
            
            if (maxLines <= 0) {
                if (!atLeastOneLine) {
                    return null;
                }
                maxLines = 1;
            }
            return truncateToFitWidth(maxWidth, maxLines, ellipse, useHTML);
        }
        
        public static function stripTags(text:String):String {
            var textField:TextField = new TextField();
            textField.htmlText = text;
            return textField.text;
        }
        
        private function updateText(text:String, textFormat:TextFormat) : void {
            _textField.text = text;
            _textField.setTextFormat(textFormat);
        }
        
        private function addEllipse(text:String, ellipse:String) : String {
            var lastChar:int = text.length - ellipse.length;
            lastChar = text.substring(0, lastChar + 1).search(/\S\s*$/);
            return text.substr(0, lastChar) + ellipse
        }
    }
}
