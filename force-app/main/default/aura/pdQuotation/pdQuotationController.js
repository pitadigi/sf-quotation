({
    doPrint : function(component, event, helper) {
        let recordId = component.get("v.recordId");
        window.open('/apex/pdQuotation?id=' + recordId, '_blank');
        $A.get("e.force:closeQuickAction").fire();
    }
})
