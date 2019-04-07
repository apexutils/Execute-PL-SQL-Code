var tempStyle = document.createElement('style');
tempStyle.type="text/css";
tempStyle.innerHTML = '.au-execute-customSpinnerClass{' +
    'position: absolute !important;' +
    'left: 0 !important;' +
    'right: 0 !important;' +
    'margin: auto !important;' +
    'top: 0 !important;' +
    'bottom: 0 !important;' +
    'z-index: 450;}';
document.head.appendChild(tempStyle);

var apexutils = this.apexutils || {};

(function(da, server, item, $) {

    apexutils.showSpinner = function (pSelector, pOverlay) {
        
        var lSpinner,
            lWaitPopup$;
        
        if(pOverlay){
            var bodyStyle   = 'position: fixed;    z-index: 1900; visibility: visible; width: 100%; height: 100%; background: rgba(255, 255, 255, 0.5);';
            var normalStyle = 'position: absolute; z-index: 440;  visibility: visible; width: 100%; height: 100%; background: rgba(255, 255, 255, 0.5);';

            lWaitPopup$ = $( '<div style="' + (pSelector == 'body' ? bodyStyle : normalStyle) + '"></div>' ).prependTo( $(pSelector) );
        }

        lSpinner = apex.util.showSpinner(pSelector, (pSelector == 'body' ? {fixed: true} : {spinnerClass: 'au-execute-customSpinnerClass'}));

        return {
            remove: function () {
                if (lWaitPopup$ !== undefined) {
                    lWaitPopup$.remove();
                }
                if ( lSpinner !== undefined ) {
                    lSpinner.remove();
                }
            }
        };
    };

    //builds a nested object if it doesn't exist and assigns it a value
    apexutils.createNestedObjectAndAssign = function(obj, keyPath, value) {
        keyPath = keyPath.split('.');
        lastKeyIndex = keyPath.length-1;
        for (var i = 0; i < lastKeyIndex; ++ i) {
            key = keyPath[i];
            if (!(key in obj)){
                obj[key] = {};
            }
            obj = obj[key];
        }
        obj[keyPath[lastKeyIndex]] = value;
    };
    
    apexutils.executePlSqlCode = function(){
        
        apex.debug('Execute PL/SQL Code ', this);

        var action           = this.action,
            resumeCallback   = this.resumeCallback,
            pageItems        = JSON.parse(action.attribute01),
            loaderSettings   = JSON.parse(action.attribute02),
            clobSettings     = JSON.parse(action.attribute03),
            actionIdentifier = action.attribute04,
            options          = JSON.parse(action.attribute05),
            errorMessages    = JSON.parse(action.attribute06),
            sync             = (action.waitForResult && options.sync);

        
        /* Event "au-execute-plsql-start" */
        var eventData = {
            preventDefault: false,
            eventId: actionIdentifier
        };
        
        $(document).trigger('au-execute-plsql-start', eventData);

        if(eventData.preventDefault){
            apex.debug('Execute PL/SQL Code execution with Event Identifier "' + actionIdentifier + '" was prevented.');
            return;
        }
        /* ------------------------------ */

        // Called by the AJAX clear callback to clear the values in the "Page Items to Return"
        function _clear() {

            // Only clear if call is async. Clearing has no effect for synchronous calls and is also known to cause
            // issues with components that use async set value mechanisms (bug #20770935).
            if ( !sync ) {
                $( pageItems.itemsToReturn, apex.gPageContext$ ).each(function () {
                    $s(this, "", null, true);
                });
            }
        }

        function _handleResponse( pData ) {
            if(pData.status == 'success'){
                var itemCount, itemArray;

                //regular page items
                if( pData && pData.items ) {
                    itemCount = pData.items.length;
                    itemArray = pData.items;
                    for( var i = 0; i < itemCount; i++ ) {
                        $s( itemArray[i].id, itemArray[i].value, null, options.suppressChangeEvent);
                    }
                }

                //clob page item/ variable/ variable as json
                if(clobSettings.returnClob){
                    switch(clobSettings.returnClobInto){
                        case 'pageitem':
                            $s(clobSettings.returnClobItem, pData.clob, null, options.suppressChangeEvent);
                            break;
                        case 'javascriptvariable':
                            apexutils.createNestedObjectAndAssign(window, clobSettings.returnClobVariable, pData.clob);
                            break;
                        case 'javascriptvariablejson':
                            apexutils.createNestedObjectAndAssign(window, clobSettings.returnClobVariable, JSON.parse(pData.clob));
                            break;
                        default:
                            break;
                    }
                }
                
                if(pData.message){
                    apex.message.showPageSuccess(pData.message);
                }

                /* Resume execution of actions here and pass false to the callback, to indicate no
                error has occurred with the Ajax call. */
                da.resume( resumeCallback, false );
            } else if (pData.status == 'error'){
                if(pData.message){

                    if(options.showErrorAsAlert){
                        apex.message.alert(pData.message);
                    } else {
                        // First clear the errors
                        apex.message.clearErrors();

                        // Now show new errors
                        apex.message.showErrors([
                            {
                                type:       "error",
                                location:   ["page"],
                                message:    pData.message,
                                unsafe:     false
                            }
                        ]);
                    }
                }
            }
        }

        // Error callback called when the Ajax call fails
        function _error( pjqXHR, pTextStatus, pErrorThrown ) {
            
            var data = {
                pjqXHR: pjqXHR,
                pTextStatus: pTextStatus,
                pErrorThrown: pErrorThrown,
                sessionExpired: pErrorThrown === errorMessages.sessionExpiredError,
                eventId: actionIdentifier,
                preventDefault: false
            };
           
            $(document).trigger('au-executeplsql-error', data);
            
            if(!data.preventDefault){
                da.handleAjaxErrors( pjqXHR, pTextStatus, pErrorThrown, resumeCallback );
            }
        }
        
        var lSpinner$;
        var uniqueId = new Date().getTime();
        
        if(loaderSettings.showLoader) {
            switch(loaderSettings.loaderType){
                case 'spinner':
                    apex.util.delayLinger.start(uniqueId, function() {
                        lSpinner$ = apexutils.showSpinner(loaderSettings.loaderPosition, false);
                    });
                    break;
                case 'spinnerandoverlay':
                    apex.util.delayLinger.start(uniqueId, function() {
                        lSpinner$ = apexutils.showSpinner(loaderSettings.loaderPosition, true);
                    });
                    break;
                default:
                    break;
            }
        }
        
        var handle_spinner = function(){
            if(loaderSettings.showLoader){
                apex.util.delayLinger.finish(uniqueId, function(){
                    if(lSpinner$){
                        lSpinner$.remove();
                    }
                });  
            }
        };

        var clobToSubmit;

        if(clobSettings.submitClob){
            switch(clobSettings.submitClobFrom){
                case 'pageitem':
                    clobToSubmit = item(clobSettings.submitClobItem).getValue();
                    break;
                case 'javascriptvariable':
                    clobToSubmit = window[clobSettings.submitClobVariable];
                    break;
                default:
                    break;
            }
        }

        server.plugin ( action.ajaxIdentifier, {
                pageItems       : pageItems.itemsToSubmit,   // Already in jQuery selector syntax
                p_clob_01       : clobToSubmit
            }, {
                dataType        : 'json',
                loadingIndicator: pageItems.itemsToReturn,   // Displayed for all "Page Items to Return"
                clear           : _clear,                    // Clears all "Page Items to Return" before the call
                success         : function(pData){
                    handle_spinner();
                    _handleResponse(pData);
                },
                error           : function(pjqXHR, pTextStatus, pErrorThrown){
                    handle_spinner();
                    _error( pjqXHR, pTextStatus, pErrorThrown );
                },
                async           : !sync,
                target          : this.browserEvent.target
            }
        );
    };
})(apex.da, apex.server, apex.item, apex.jQuery);