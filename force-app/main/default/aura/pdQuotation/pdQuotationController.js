({
    doPrint : function(component, event, helper) {
        setTimeout(() => {
            var element = document.getElementsByClassName("DESKTOP uiModal forceModal");    
            element.forEach(function(e, t) {
                $A.util.addClass(e, 'slds-hide');
            });     
            $A.get("e.force:refreshView").fire();
        }, 1000);
        let recordId = component.get("v.recordId");
        window.open('/apex/pdQuotation?id=' + recordId, '_blank');
    }
})
