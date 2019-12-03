({
    doPrint : function(component, event, helper) {
        setTimeout(() => {
            $A.get("e.force:closeQuickAction").fire();
        }, 1000);
        let recordId = component.get("v.recordId");
        window.open('/apex/pdQuotation?id=' + recordId, '_blank');
    }
})
