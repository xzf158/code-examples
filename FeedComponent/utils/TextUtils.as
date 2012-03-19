package utils 
{
    
import flash.text.StyleSheet;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
    
public class TextUtils
{

    public static function getTextField():TextField
    {
        var textField:TextField = new TextField();
        textField.selectable = false;
        textField.autoSize = TextFieldAutoSize.LEFT;
        textField.multiline = true;
        return textField;
    }
    
    // Basic facade - simplify the TextFormat constructor for our purposes.
    public static function getTextFormat(font:String, size:Number, color:Number, isBold:Boolean = false, leading:uint = 0):TextFormat
    {
        return new TextFormat(font, size, color, isBold, null, null, null, null, null, null, null, null, leading);
    }
    
    public static function getStyleSheetFromTextFormat(textFormat:TextFormat, additionalCSSText:String = null):StyleSheet
    {
        return getStyleSheet(textFormat.font, Number(textFormat.size), Number(textFormat.color), textFormat.bold, uint(textFormat.leading), additionalCSSText);
    }
    
    // Mimics getTextFormat (param for param), defined in AbstractFeedItemView.
    public static function getStyleSheet(font:String, size:Number, color:Number, isBold:Boolean = false, leading:uint = 0, additionalCSSText:String = null):StyleSheet
    {
        var stylesheet:StyleSheet = new StyleSheet();
        stylesheet.setStyle('fontFamily', font);
        stylesheet.setStyle('fontSize', size);
        stylesheet.setStyle('color', color);
        stylesheet.setStyle('fontWeight', (isBold) ? 'bold' : 'none');
        stylesheet.setStyle('leading', leading);
        
        // if (additionalCSSText)
        stylesheet.parseCSS(additionalCSSText);
        
        return stylesheet;
    }
}
}