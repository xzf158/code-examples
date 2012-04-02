package utils {
public class StringUtils {
    public function StringUtils() {
    }

    public static function isBlank(value:String):Boolean {
        return (value == "null" || value == null || value == "undefined" || value == "");
    }

    public static function isTrue(value:String):Boolean {
        return (!StringUtils.isBlank(value) && (value=="true" || value=="TRUE" || value=="1"));
    }

    public static function trim(value:String):String {
        if (value == null) { return ''; }
        return value.replace(/^\s+|\s+$/g, '');
    }

    public static function format(pattern:String, ...parts):String{
        if(StringUtils.isBlank(pattern)) return pattern;
        var regExp:RegExp = /(%[0-9]+)/g;
        return pattern.replace(regExp, function():String {
            try{
                var index:int = Number(arguments[1].substring(1));
                if(parts.length > index) {
                    return parts[index];
                }
            } catch (e:Error) {
                //ignored
            }
            return "";
        });
    }
}
}
