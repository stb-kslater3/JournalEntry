@isTest
public class JournalEntryTestDataFactory {

/*
    // -------------------------------------------------------------------------------------
    // ------------------------------ Financial Company Data -----------------------------------
    // -------------------------------------------------------------------------------------
    public static List<rstkf__glcmp__c> loadFinancialCompanyData() {
        List<rstkf__glcmp__c> companyData = new List<rstkf__glcmp__c>();


        companyData.add(
            new rstkf__glcmp__c(
                Name='Summit Truck Bodies (STB)'
            )
        );

        companyData.add(
            new rstkf__glcmp__c(
                Name='Summit Truck Equipment (STE)'
            )
        );


        insert companyData;

        return companyData;
    }
*/


    // -------------------------------------------------------------------------------------
    // ------------------------------ Financial System User Data -----------------------------------
    // -------------------------------------------------------------------------------------
    public static List<rstkf__glusr__c> loadFinancialUserData() {
        //List<rstkf__glcmp__c> companyData = JournalEntryTestDataFactory.loadFinancialCompanyData();
        /*
        List<rstkf__glcmp__c> companyData = [
            SELECT Name, Id
            FROM rstkf__glcmp__c
            WHERE Name LIKE '%STB%'
        ];
        */


        List<User> userData = [
            SELECT Name, Id
            FROM User
            WHERE Name='Kaden Slater'
        ];


        List<rstk__syusr__c> manufacturingUserData = new List<rstk__syusr__c>();

        manufacturingUserData.add(
            new rstk__syusr__c(
                Name = userData[0].Name,
                rstk__syusr_clockno__c = 9999,
                rstk__syusr_employee__c = userData[0].Id
            )
        );

        insert manufacturingUserData;


        List<rstkf__glusr__c> financialUserData = new List<rstkf__glusr__c>();

        financialUserData.add(
            new rstkf__glusr__c(
                Name = manufacturingUserData[0].Name,
                rstkf__glusr_syusr__c = manufacturingUserData[0].Id
                //rstkf__glusr_lastcmpno__c = companyData[0].Id,
                //rstkf__glusr_dfltcmpno__c = companyData[0].Id
            )
        );


        insert financialUserData;

        return financialUserData;
    }



    // -------------------------------------------------------------------------------------
    // ------------------------------ Journal Header Data -----------------------------------
    // -------------------------------------------------------------------------------------
    public static List<rstkf__gljh__c> loadHeaderData() {
        List<rstkf__glusr__c> userData = JournalEntryTestDataFactory.loadFinancialUserData();


        List<rstkf__gljh__c> headerData = new List<rstkf__gljh__c>();

        headerData.add(
            new rstkf__gljh__c(
                Name = '2020-10JE #2122',
                //rstkf__gljh_cmpno__c = userData[0].rstkf__glusr_lastcmpno__c,
                rstkf__gljh_stdid__c = userData[0].rstkf__glusr_lastcmpno__c,
                rstkf__gljh_owner__c = userData[0].Id
            )
        );


        insert headerData;

        return headerData;
    }
}
