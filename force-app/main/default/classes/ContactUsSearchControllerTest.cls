@isTest
public class ContactUsSearchControllerTest {

    @TestSetup
    static void setupData() {
        List<ContactUsContact__c> contactUsDetails = new List<ContactUsContact__c>();
        List<ContactUsContactByABAPrefix__c> contactUsByABAPrefixList = new List<ContactUsContactByABAPrefix__c>();
        List<ContactUsABAPrefix__c> contactUsByPrefixList = new List<ContactUsABAPrefix__c>();

        ContactUsContact__c contact1 = new ContactUsContact__c();
        contact1.Description__c = 'test1';
        contact1.Status__c = 'Approved';
        contact1.Category__c = 'Account Services Contacts';
        contact1.SubCategory__c = 'Account Open Coordinators';
        contact1.Email__c = 'ccc.coordinators@kc.frb.org';
        contact1.Phone__c = '(833) 377-7820';
        contact1.Status__c = 'Approved';
        contact1.Return_completed_original_docs_to__c = 'National Accounting Customer Support';
        contactUsDetails.add(contact1);

        ContactUsContact__c contact2 = new ContactUsContact__c();
        contact2.Description__c = 'test2';
        contact2.Category__c = 'Account Services Contacts';
        contact2.SubCategory__c = 'Account Open Coordinators';
        contact2.Email__c = 'ccc.technical.support@kc.frb.org';
        contact2.Phone__c = '(833) 377-7821';
        contact2.Status__c = 'Approved';
        contact2.Return_completed_original_docs_to__c = 'National Accounting Customer Support';
        contactUsDetails.add(contact2);

        ContactUsContact__c contact3 = new ContactUsContact__c();
        contact3.Description__c = 'test3';
        contact3.Status__c = 'Approved';
        contact3.Category__c = 'Account Services Contacts';
        contact3.SubCategory__c = 'Account Open Coordinators';
        contact3.Email__c = 'fedachcheckscs@atl.frb.org';
        contact3.Phone__c = '(833) 377-7822';
        contact3.Status__c = 'Approved';
        contact3.Return_completed_original_docs_to__c = 'National Accounting Customer Support';
        contactUsDetails.add(contact3);
        
        insert contactUsDetails;

        ContactUsABAPrefix__c prefixData1 = new ContactUsABAPrefix__c();
        prefixData1.Prefix__c = '0210';
        prefixData1.District_Name__c ='New York';
        contactUsByPrefixList.add(prefixData1);

        ContactUsABAPrefix__c prefixData2 = new ContactUsABAPrefix__c();
        prefixData2.Prefix__c = '45';
        prefixData2.District_Name__c ='Chicago';
        contactUsByPrefixList.add(prefixData2);

        insert contactUsByPrefixList;

        ContactUsContactByABAPrefix__c contactUsABAPrefix1 = new ContactUsContactByABAPrefix__c();
        contactUsABAPrefix1.Prefix__c = contactUsByPrefixList[0].Id;
        contactUsABAPrefix1.Region_Contact__c = contactUsDetails[0].Id;
        contactUsByABAPrefixList.add(contactUsABAPrefix1);

        ContactUsContactByABAPrefix__c contactUsABAPrefix2 = new ContactUsContactByABAPrefix__c();
        contactUsABAPrefix2.Prefix__c = contactUsByPrefixList[0].Id;
        contactUsABAPrefix2.Region_Contact__c = contactUsDetails[1].Id;
        contactUsByABAPrefixList.add(contactUsABAPrefix2);

        ContactUsContactByABAPrefix__c contactUsABAPrefix3 = new ContactUsContactByABAPrefix__c();
        contactUsABAPrefix3.Prefix__c = contactUsByPrefixList[0].Id;
        contactUsABAPrefix3.Region_Contact__c = contactUsDetails[2].Id;
        contactUsByABAPrefixList.add(contactUsABAPrefix3);

        ContactUsContactByABAPrefix__c contactUsABAPrefix4 = new ContactUsContactByABAPrefix__c();
        contactUsABAPrefix4.Prefix__c = contactUsByPrefixList[1].Id;
        contactUsABAPrefix4.Region_Contact__c = contactUsDetails[0].Id;
        contactUsByABAPrefixList.add(contactUsABAPrefix4);

        ContactUsContactByABAPrefix__c contactUsABAPrefix5 = new ContactUsContactByABAPrefix__c();
        contactUsABAPrefix5.Prefix__c = contactUsByPrefixList[1].Id;
        contactUsABAPrefix5.Region_Contact__c = contactUsDetails[1].Id;
        contactUsByABAPrefixList.add(contactUsABAPrefix5);
        
        ContactUsContactByABAPrefix__c contactUsABAPrefix6 = new ContactUsContactByABAPrefix__c();
        contactUsABAPrefix6.Prefix__c = contactUsByPrefixList[1].Id;
        contactUsABAPrefix6.Region_Contact__c = contactUsDetails[2].Id;
        contactUsByABAPrefixList.add(contactUsABAPrefix6);

        insert contactUsByABAPrefixList;
        
        List<Account> acctList = new List<Account>();
        Account acct1 = new Account();
        acct1.ABA__c='021000022';
        acct1.Name='JP Morgan Test';
        acctList.add(acct1);
        
        Account acct2 = new Account();
        acct2.ABA__c='456464556';
        acct2.Name='Bank ABA Test';
        acctList.add(acct2);
        insert acctList;
    }

    @isTest
    public static void testGetContactDetails_First4Digits() {
        ContactUsSearchController.SearchData searchRec = new ContactUsSearchController.SearchData();
        searchRec = ContactUsSearchController.getContactDetails('021000022');
        Assert.areEqual('JP Morgan Test', searchRec.accountName);
        Assert.areEqual(1, (searchRec.categoryList).size());
    }
    
    @isTest
    public static void testGetContactDetails_First2Digits() {
        ContactUsSearchController.SearchData searchRec = new ContactUsSearchController.SearchData();
        searchRec = ContactUsSearchController.getContactDetails('456464556');
        Assert.areEqual('Bank ABA Test', searchRec.accountName);
        Assert.areEqual(1, (searchRec.categoryList).size());
    }

    @isTest
    public static void testGetContactDetails_WhenNoCategoriesFound() {
        ContactUsSearchController.SearchData searchRec = new ContactUsSearchController.SearchData();
        searchRec = ContactUsSearchController.getContactDetails('456464557');
        Assert.areEqual('Please Specify a valid ABA Number', searchRec.message, 'Account Names are not found');
        Assert.areEqual(null, searchRec.categoryList);
    }
    
}