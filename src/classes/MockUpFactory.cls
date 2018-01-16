@isTest
public class MockUpFactory {

    private static Map<String, Id> rtMember;

    public static List<FieloPLT__Program__c> createPrograms(String basename, Integer count) {
        List<FieloPLT__Program__c> results = new List<FieloPLT__Program__c>();
        for(Integer x = 0; x < count; x++){
            FieloPLT__Program__c p = new FieloPLT__Program__c();
            p.Name = basename + String.valueOf(x);
            p.FieloPLT__OnlineTransactionProcessing__c = true;
            results.add(p);
        }
        return results;
    }

    //Created for FieloPRP
    public static List<FieloPLT__Member__c> createMembers(String programId, Integer count){
        List<FieloPLT__Member__c> membersToCreate = new List<FieloPLT__Member__c>();
        for(Integer x = 0; x < count; x++){
            membersToCreate.add(new FieloPLT__Member__c(
                    Name='Member '+String.valueOf(x),
                    FieloPLT__Email__c='email'+String.valueOf(x)+'l@example.com',
                    FieloPLT__Type__c='Individual Account',
                    FieloPLT__Program__c=programId
                )
            );
        }
        return membersToCreate;
    }

    public static List<FieloELR__Course__c> createCourses(String programId, String segmentId, Integer count){
        List<FieloELR__Course__c> coursesToCreate = new List<FieloELR__Course__c>();
        for(Integer x = 0; x < count; x++){
            coursesToCreate.add(new FieloELR__Course__c(
            		Name = 'Course ' + x,
                    FieloELR__Program__c = programId,
                    FieloELR__Description__c = 'Description',
                    FieloELR__SubscriptionMode__c = 'Manual',
                    FieloELR__Segment__c = segmentId
                )
            );
        }
        return coursesToCreate;
    }

    public static List<FieloPLT__Promotion__c> createPromotions(String basename, Integer count, Id programId){
        List<FieloPLT__Promotion__c> results = new List<FieloPLT__Promotion__c>();
        for(Integer x = 0; x < count; x++){
            FieloPLT__Promotion__c p = new FieloPLT__Promotion__c();
            p.Name = basename + String.valueOf(x);
            p.FieloPLT__Program__c = programId;
            results.add(p);
        }
        return results;
    }

    public static List<FieloPLT__Segment__c> createSegments(String basename, Integer count, String type){
        List<FieloPLT__Segment__c> results = new List<FieloPLT__Segment__c>();
        Id rtId = [SELECT Id FROM RecordType WHERE DeveloperName =: type].Id;
        for(Integer x = 0; x < count; x++){
            FieloPLT__Segment__c s = new FieloPLT__Segment__c();
            s.Name = basename + String.valueOf(x);
            s.RecordTypeId = rtId;
            results.add(s);
        }
        return results;
    }
}