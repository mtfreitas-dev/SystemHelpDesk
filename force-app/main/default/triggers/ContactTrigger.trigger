trigger ContactTrigger on Contact (before insert, before update) {
    
    ContactTriggerHandler handler = new ContactTriggerHandler(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);

    switch on Trigger.operationType {
        when BEFORE_INSERT {
            handler.beforeInsert();
        }

        when BEFORE_UPDATE {
            handler.beforeUpdate();
        }
    }
}