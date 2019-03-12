public with sharing class testMC {
    
    public List<DynamicValuesWrapperClass> getDynamicValues(Id idRecord) {
        DynamicValuesWrapperClass objResult;
        List<DynamicValuesWrapperClass> lstResults = new List<DynamicValuesWrapperClass>();
        Set<Id> setRecordIds = new Set<Id>();
        if(idRecord != null) {
            setRecordIds.add(idRecord);
            for(DynamicValuesWrapperClass objInnerResult : getDynamicValues(setRecordIds)) {
                for(String strLabel : objInnerResult.mapLabelsAndValues.keySet()) {
                    objResult = new DynamicValuesWrapperClass();
                    objResult.strLabel = strLabel;
                    objResult.strValue = objInnerResult.mapLabelsAndValues.get(strLabel);
                    lstResults.add(objResult);
                }
            }
        }
        return lstResults;
    }
    
    public List<DynamicValuesWrapperClass> getDynamicValues(Set<Id> setRecordIds) {
        DynamicValuesWrapperClass objResult;
        List<DynamicValuesWrapperClass> lstResults = new List<DynamicValuesWrapperClass>();
        List<String> lstFields;
        List<String> lstRequiredObjects = new List<String>();
        List<String> lstFilterIds;
        Map<String, String> mapFieldsAndLabel;
        Map<String, Map<String, String>> mapObjects = new Map<String, Map<String, String>>();
        Map<String, List<String>> mapObjectsAndIdFilters = new Map<String, List<String>>();
        
        //First we determine the object types required.
        for(Id idRecord : setRecordIds) {
            lstRequiredObjects.add(String.valueOf(idRecord.getSObjectType()));
            lstFilterIds = mapObjectsAndIdFilters.get(String.valueOf(idRecord.getSObjectType()));
            if(lstFilterIds == null) {
                lstFilterIds = new List<String>();
            }
            lstFilterIds.add('Id = \'' + idRecord + '\'');
            mapObjectsAndIdFilters.put(String.valueOf(idRecord.getSObjectType()), lstFilterIds);
        }
        
        //Now we get all the records from the custom metadata type.
        for(Test__mdt objRecord : [SELECT Object__c, Field__c, Label__c FROM Test__mdt WHERE Object__c IN :lstRequiredObjects LIMIT 10000]) {
            if(String.IsNotBlank(objRecord.Object__c) && String.IsNotBlank(objRecord.Field__c) && String.IsNotBlank(objRecord.Label__c)) {
                mapFieldsAndLabel = mapObjects.get(objRecord.Object__c);
                if(mapFieldsAndLabel == null) {
                    mapFieldsAndLabel = new Map<String, String>();
                }
                mapFieldsAndLabel.put(objRecord.Field__c, objRecord.Label__c);
                mapObjects.put(objRecord.Object__c, mapFieldsAndLabel);
            }
        }
        
        //Now, we create the corresponding queries.
        for(String strObject : mapObjects.keySet()) {
            lstFields = new List<String>();
            lstFilterIds = mapObjectsAndIdFilters.get(strObject);
            lstFields.addAll(mapObjects.get(strObject).keySet());
            if(!lstFields.contains('Id')) {
                lstFields.add('Id');
            }
            for(sObject objRecord : Database.query('SELECT ' + String.join(lstFields, ',') + ' FROM ' + strObject + ' WHERE ' + String.join(lstFilterIds, ' AND '))) {
                for(Id idRecord : setRecordIds) {
                    if(idRecord == objRecord.get('Id')) {
                        objResult = new DynamicValuesWrapperClass();
                        objResult.idRecord = idRecord;
                        objResult.mapLabelsAndValues = new Map<String, String>();
                        for(String strField : mapObjects.get(strObject).keySet()) {
                             objResult.mapLabelsAndValues.put(mapObjects.get(strObject).get(strField), getQueryValue(objRecord, strField));
                        }
                        lstResults.add(objResult);
                    }
                }
            }
        }
        
        //Finally, we return the results.
        return lstResults;
    }
    
    private String getQueryValue(sObject objRecord, String strField) {
        String strResult = '';
        sObject objRelationship = objRecord;
        if(String.IsNotBlank(strField)) {
            if(strField.contains('.')) {
                List<String> lstRelationships = strField.split('\\.');
                for(Integer intCounter = 0; intCounter < lstRelationships.size(); intCounter++) {
                    if(intCounter == lstRelationships.size() - 1) {
                        strResult = String.valueOf(objRelationship.get(lstRelationships.get(intCounter)));
                    } else {
                        objRelationship = objRelationship.getSObject(lstRelationships.get(intCounter));
                    }
                }
            } else {
                strResult = String.valueOf(objRecord.get(strField));
            }
        }
        return strResult;
    }
    
    public class DynamicValuesWrapperClass {
        
        //Public variables.
        public Id idRecord {get; set;}
        public String strLabel {get; set;}
        public String strValue {get; set;}
        public Map<String, String> mapLabelsAndValues {get; set;}
    }
}


