/**
 * Copyright 2012 Flite, Inc.
 * All rights reserved.
 *
 * THIS PROGRAM IS CONFIDENTIAL AND AN UNPUBLISHED WORK AND TRADE
 * SECRET OF THE COPYRIGHT HOLDER, AND DISTRIBUTED ONLY UNDER RESTRICTION.
 */
package utils {
import items.AbstractFeedItemView;

public class MetricsUtils {
    private var _api:Object;
    private var _label:String;
    private var _metricsHelper:*;
    private var _feedContentHelper:*;
    private var _feedInteractionHelper:*;
    private var _articleMetricsHelper:*;

    public function MetricsUtils(options:Object) {
        _api = options.api;
        trace("MetricsUtils. API:" + options.api);
        _label = options.label;
        trace("MetricsUtils. Label:" + _label);
    }

    public function set initalMetricsHelper(helper:Object) : void {
        _metricsHelper = helper;
    }

    public function logFeedContent(name:String, url:String) : void{
        var options:Object = {
            eventData : {
                name : name,
                 url : url
            }
        };
        if(_metricsHelper == null){
            _metricsHelper = _api.metrics.getMetricsHelper();
        }
        _feedContentHelper = _metricsHelper.logContent(_metricsHelper.subtype.CONTENT_VIEW_SUBTYPE, _label, options);
    }

    public function logFeedNav(page:String, direction:String = null):void {
        var eventData:Object = {
            description: (direction == null) ? "adjacent" : "direct",
            page:page
        };
        if(direction != null){
            eventData["direction"] = direction;
        }
        _feedContentHelper.logInteraction(
                    _feedContentHelper.subtype.INTERACTION_NAVIGATE_SUBTYPE,
                    _feedContentHelper.mode.MODE_CLICK,
                    _label,
                    {eventData:eventData}
                );
    }

    public function logArticleSelect(headline:String, url:String) : Object{
        var eventData:Object = {
            url: url
        };
        _feedInteractionHelper = _feedContentHelper.logInteraction(
                    _feedContentHelper.subtype.INTERACTION_SELECT_SUBTYPE,
                    _feedContentHelper.mode.MODE_CLICK,
                    headline,
                    {eventData:eventData}
                );
        return _feedInteractionHelper;
    }

    public function logArticleContent(headline:String, url:String) : void {
         var options:Object = {
            eventData : {
                url : url
            }
        };
        _articleMetricsHelper = _feedInteractionHelper.logContent(_feedInteractionHelper.subtype.CONTENT_VIEW_SUBTYPE, headline, options);
    }

    public function logArticleInteraction(detail:String, eventData:Object = null):Object {
        return _articleMetricsHelper.logInteraction(
                    _articleMetricsHelper.subtype.INTERACTION_SELECT_SUBTYPE,
                    _articleMetricsHelper.mode.MODE_CLICK,
                    detail,
                    {eventData:eventData}
                );
    }

    public function logFeedScrollInteraction(fromFeedItem:AbstractFeedItemView, toFeedItem:AbstractFeedItemView) : void {
        logScroll(_feedContentHelper,
                  _label,
                  {
                        from : fromFeedItem ? fromFeedItem.metricsDetail : "Unknown",
                     fromUrl : fromFeedItem ? fromFeedItem.linkUrl : "",
                          to : toFeedItem ? toFeedItem.metricsDetail : "Unknown",
                       toUrl : toFeedItem ? toFeedItem.linkUrl : ""
                  });
    }

    public function logArticleScrollInteraction(from:uint, to:uint, article:String) : void {
        logScroll(_articleMetricsHelper,
                  article,
                  {
                    from : from,
                      to : to
                  });
    }

    private function logScroll(helper:Object, detail:String, eventData:Object) : void {
        helper.logInteraction(
                  helper.subtype.INTERACTION_SCROLL_SUBTYPE,
                  helper.mode.MODE_DRAG,
                  detail,
                  {eventData : eventData}
                );
    }

    public function logShareInteraction(service:String, fromFeed:Boolean) : Object {
        var helper:Object = fromFeed ? _feedContentHelper : _articleMetricsHelper;
        var options:Object = {
            eventData : {
                service : service
            }
        };
        return helper.logInteraction(
                helper.subtype.INTERACTION_SELECT_SUBTYPE,
                helper.mode.MODE_CLICK,
                "Share",
                options
        );
    }

    public function logFollow(userName:String) : Object {
        var options:Object = {
            eventData : {
                user : userName
            }
        };
        return _feedContentHelper.logInteraction(
                   _feedContentHelper.subtype.INTERACTION_SELECT_SUBTYPE,
                   _feedContentHelper.mode.MODE_CLICK,
                   "Follow",
                   options
               );
    }
}
}
