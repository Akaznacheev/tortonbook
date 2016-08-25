// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require fancybox
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require_tree .



var ready;
ready = function() {
    /*
    Horizontal mouse scrool
     */
    (function (factory) {
        if ( typeof define === 'function' && define.amd ) {
            // AMD. Register as an anonymous module.
            define(['jquery'], factory);
        } else if (typeof exports === 'object') {
            // Node/CommonJS style for Browserify
            module.exports = factory;
        } else {
            // Browser globals
            factory(jQuery);
        }
    }(function ($) {

        var toFix  = ['wheel', 'mousewheel', 'DOMMouseScroll', 'MozMousePixelScroll'],
            toBind = ( 'onwheel' in document || document.documentMode >= 9 ) ?
                ['wheel'] : ['mousewheel', 'DomMouseScroll', 'MozMousePixelScroll'],
            slice  = Array.prototype.slice,
            nullLowestDeltaTimeout, lowestDelta;

        if ( $.event.fixHooks ) {
            for ( var i = toFix.length; i; ) {
                $.event.fixHooks[ toFix[--i] ] = $.event.mouseHooks;
            }
        }

        $.event.special.mousewheel = {
            version: '3.1.6',

            setup: function() {
                if ( this.addEventListener ) {
                    for ( var i = toBind.length; i; ) {
                        this.addEventListener( toBind[--i], handler, false );
                    }
                } else {
                    this.onmousewheel = handler;
                }
            },

            teardown: function() {
                if ( this.removeEventListener ) {
                    for ( var i = toBind.length; i; ) {
                        this.removeEventListener( toBind[--i], handler, false );
                    }
                } else {
                    this.onmousewheel = null;
                }
            }
        };

        $.fn.extend({
            mousewheel: function(fn) {
                return fn ? this.bind('mousewheel', fn) : this.trigger('mousewheel');
            },

            unmousewheel: function(fn) {
                return this.unbind('mousewheel', fn);
            }
        });


        function handler(event) {
            var orgEvent   = event || window.event,
                args       = slice.call(arguments, 1),
                delta      = 0,
                deltaX     = 0,
                deltaY     = 0,
                absDelta   = 0;
            event = $.event.fix(orgEvent);
            event.type = 'mousewheel';

            // Old school scrollwheel delta
            if ( 'detail'      in orgEvent ) { deltaY = orgEvent.detail * -1;      }
            if ( 'wheelDelta'  in orgEvent ) { deltaY = orgEvent.wheelDelta;       }
            if ( 'wheelDeltaY' in orgEvent ) { deltaY = orgEvent.wheelDeltaY;      }
            if ( 'wheelDeltaX' in orgEvent ) { deltaX = orgEvent.wheelDeltaX * -1; }

            // Firefox < 17 horizontal scrolling related to DOMMouseScroll event
            if ( 'axis' in orgEvent && orgEvent.axis === orgEvent.HORIZONTAL_AXIS ) {
                deltaX = deltaY * -1;
                deltaY = 0;
            }

            // Set delta to be deltaY or deltaX if deltaY is 0 for backwards compatabilitiy
            delta = deltaY === 0 ? deltaX : deltaY;

            // New school wheel delta (wheel event)
            if ( 'deltaY' in orgEvent ) {
                deltaY = orgEvent.deltaY * -1;
                delta  = deltaY;
            }
            if ( 'deltaX' in orgEvent ) {
                deltaX = orgEvent.deltaX;
                if ( deltaY === 0 ) { delta  = deltaX * -1; }
            }

            // No change actually happened, no reason to go any further
            if ( deltaY === 0 && deltaX === 0 ) { return; }

            // Store lowest absolute delta to normalize the delta values
            absDelta = Math.max( Math.abs(deltaY), Math.abs(deltaX) );
            if ( !lowestDelta || absDelta < lowestDelta ) {
                lowestDelta = absDelta;
            }

            // Get a whole, normalized value for the deltas
            delta  = Math[ delta  >= 1 ? 'floor' : 'ceil' ](delta  / lowestDelta);
            deltaX = Math[ deltaX >= 1 ? 'floor' : 'ceil' ](deltaX / lowestDelta);
            deltaY = Math[ deltaY >= 1 ? 'floor' : 'ceil' ](deltaY / lowestDelta);

            // Add information to the event object
            event.deltaX = deltaX;
            event.deltaY = deltaY;
            event.deltaFactor = lowestDelta;

            // Add event and delta to the front of the arguments
            args.unshift(event, delta, deltaX, deltaY);

            // Clearout lowestDelta after sometime to better
            // handle multiple device types that give different
            // a different lowestDelta
            // Ex: trackpad = 3 and mouse wheel = 120
            if (nullLowestDeltaTimeout) { clearTimeout(nullLowestDeltaTimeout); }
            nullLowestDeltaTimeout = setTimeout(nullLowestDelta, 200);

            return ($.event.dispatch || $.event.handle).apply(this, args);
        }

        function nullLowestDelta() {
            lowestDelta = null;
        }

    }));
    /*
     This part I have put in my HTML <head> part.
     */

    $(function() {
        $("html, body, *").mousewheel(function(event, delta) {
            this.scrollLeft -= (delta * 5);
            this.scrollRight -= (delta * 5);
            event.preventDefault();
        });
    });


    /*
    Fancybox
     */
    $(document).ready(function() {
        $("a.fancybox").fancybox();
    });

    /*
    Photo Draggable & Droppable & Addable
     */
    $(document).ready(function()
    {
        var x;                            // To store cloned div

        $(".div_1").draggable(
            {
                helper: "clone",
                cursor: "move",
                revert: true
            });

        $(".div_2").droppable(
            {
                drop: function(event, ui)
                {

                    var urlstr = ui.draggable.find("img").attr("src");
                    var photo_id = ui.draggable.attr("id");
                    var page_id = $(this).attr("id"); //event.target.id;  // or $(this).attr("id"), or this.id

                    x = ui.helper.clone();    // Store cloned div in x
                    ui.helper.remove();       // Escape from revert the original div
                    // x.appendTo('.div_2');     // To append the reverted image

                    $(this).css('background-image','url('+urlstr+')');

                    jQuery.ajax({
                        url: "/bookpages/"+page_id,
                        type: "put",
                        data:{page_params:{
                            },
                            phgallery_params: {
                                photo_id: photo_id
                            }
                        },
                        dataType:'json',
                        success:function(returned_value){
                            if(returned_value)
                                alert('true');
                        }
                    });
                }
            });
    });
}
$(document).ready(ready);
$(document).on('page:load', ready)