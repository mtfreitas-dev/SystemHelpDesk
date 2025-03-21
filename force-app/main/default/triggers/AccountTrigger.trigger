trigger AccountTrigger on Account (before insert) {

    AccountTriggerHandler handler = new AccountTriggerHandler(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);

    switch on Trigger.operationType {
        when  BEFORE_INSERT{
            handler.beforeInsert();
        }
    }
}