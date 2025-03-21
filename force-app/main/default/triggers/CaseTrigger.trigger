trigger CaseTrigger on Case (before insert, before update) {

    CaseTriggerHandler handler = new CaseTriggerHandler(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);

    switch on Trigger.operationType {
        when BEFORE_INSERT {
            handler.beforeInsert();
        }

        when BEFORE_UPDATE {
            handler.beforeUpdate();
        }
        
    }
}