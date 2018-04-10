trigger updatefield on Requirement__c (before insert, before update) {
    List<Requirement__c> requirementList = new List<Requirement__c>();
 for (Requirement__c record:trigger.new) {
    if(record.Requirement_Owner__c ==null) {
    record.Requirement_Owner__c = userinfo.getUserId();
    }
  }
}