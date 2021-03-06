/**
 * Copyright 2011 Flite, Inc.
 * All rights reserved.
 *
 * THIS PROGRAM IS CONFIDENTIAL AND AN UNPUBLISHED WORK AND TRADE
 * SECRET OF THE COPYRIGHT HOLDER, AND DISTRIBUTED ONLY UNDER RESTRICTION.
 *
 */
package {
import flash.display.Graphics;
import flash.display.MovieClip;
import flash.geom.Rectangle;
import flash.system.Security;

/**
 * Base Component
 *
 * An example base component, defining the interface methods and options available to
 * components in the new Flite Ad Runtime.
 *
 * Components should implement the following interface methods under the flite namespace:
 * initialize(resources:Object):void
 * resize(info:Object):void
 * stateChange(info:Object):void
 *
 * Components have the following lifecycle:
 * No State
 * Unloaded
 * Loaded
 * Initialized (after initialize is called)
 * Enabled (after Enabled state set explicitly)
 * Disabled (after Disabled state set explicitly)
 * Unloaded
 *
 * In nearly all cases, the lifecycle progresses down the list. The one exception is that
 * a disabled component can be enabled again. Otherwise, the order must be followed.
 *
 */
public class BaseComponent
    extends MovieClip
{
    /////////// Namespaces

    /**
     * The Flite namespace used for the component interface.
     */
    public namespace flite = "http://www.flite.com/ad/v3/component/namespace";

    /////////// Private Members

    /**
     * Reference to components unique key
     */
    private var _key:String;

    /**
     * Reference to api object: API Documentation will be available elsewhere.
     */
    private var _api:Object;

    /**
     * Reference to config object
     */
    private var _config:Object;

    /**
     * Configured rectangle
     */
    private var _rectangle:Rectangle;

    /**
     * Current component state. Can be "nostate", "unloaded", "loaded", "initialized", "enabled", "disabled"
     */
    private var _state:String;

    /**
     * List of component children.
     */
    private var _children:Array;



    ////////// Constructor

    /**
     * Base Component
     *
     * The component will be loaded by the Flite runtime. The constructor will be run
     * before any interface methods are called. Used the constructor to set up your
     * environment.
     *
     * To make sure there are no security errors during swf to swf communication,
     * the constructor should set the security to allow external communication.
     */
    public function BaseComponent() {
        //Set security to the Flite Runtime can communicate with the component.
        Security.allowDomain("*");
    }


    ////////// Interface Methods

    /**
     * initialize
     *
     * After load, a component will be initialized with a resource object that contains an api hook,
     * configuration, and other useful information for component running.
     *
     * @param resources contains the following:
     *  key: A unique id for the component. Used when setting state.
     *  api: A reference (or hook) to the Flite Ad API. Use it to access API methods.
     *  config: A special object containing access to component configuration. See example below.
     *  width: Width of the component box.
     *  height: Height of the component box.
     *  state: The current state of the component. (loaded, initialized, enabled, or disabled)
     *  children: An array of child components. If the component can load children, it will use this list to do so.
     */
    flite function initialize(resources:Object):void {
        //Store key
        _key = resources.key;

        //Store API
        _api = resources.api;

        //Store config
        _config = resources.config;

        //Store dimensions
        _rectangle = new Rectangle(0, 0, resources.width, resources.height);

        //Store state
        _state = resources.state;

        //Store child list
        _children = resources.children;

        // Now that everything is initialized, lets do something.
        render(_rectangle);
    }

    /**
     * resize
     *
     * If a component needs to be resize dynamically, this method will be called. Because of this
     * we strongly encourage supporting dynamic resizing. In the absence of this method, the component
     * will be unloaded then reloaded at the new size, which can be taxing on bandwidth and performance.
     *
     * @param info is an object containing width and height
     */
    flite function resize(info:Object):void {
        //Store new dimensions
        _rectangle.width = info.width;
        _rectangle.height = info.height;
        render(_rectangle)
    }

    /**
     * stateChange
     *
     * When the state of a component changes (or a child component), this method will be called.
     *
     * @param info is an object containing the following:
     *   state: The component's current state.
     *   child: If a child is affected by the state change, this will contain the child's key and its state. (This is
     *   useful for navigation components).
     */
    flite function stateChange(info:Object):void {
        //Store the new state
        _state = info.state;

        //You would access the child state this way:
        //var affectedChildKey:String = info.child.key;
        //var affectedChildState:String = info.child.state;
    }


    ////////// Private Methods

    /**
     * render
     *
     * While this method does not actually do anything, we will use it as an example of how to access config.
     *
     * @param rect is a Rectangle
     */
    private function render(rect:Rectangle):void {
        //Lets draw a colored rectangle!
        var graphics:Graphics = this.graphics;

        //Clear the current graphics
        graphics.clear();

        //We need a color and an alpha. Lets get it from the config!
        var rectangleColor:uint = _config.getColor("color_param_name"); //Optionally, _config.map.color_param_name;
        var rectangleAlpha:Number = _config.getNumber("alpha_param_name")/100.0; //Optionally, _config.map.alpha_param_name;

        //Other methods on Config: getString, getBoolean, getInt, getNumber, getColor, getValue

        //Start our fill
        graphics.beginFill(rectangleColor, rectangleAlpha);

        //Draw a rectangle
        graphics.drawRect(0, 0, rect.width, rect.height);

        //End fill
        graphics.endFill();
    }
}
}
