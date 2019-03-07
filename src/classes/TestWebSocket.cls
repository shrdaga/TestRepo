public with sharing class TestWebSocket {
    public String ipAddress1 {get; set;}
    public String ipAddress2 {get; set;}
    
    public TestWebSocket() {
        ipAddress1 = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
        ipAddress2 = ApexPages.currentPage().getHeaders().get('True-Client-IP');
    }
}