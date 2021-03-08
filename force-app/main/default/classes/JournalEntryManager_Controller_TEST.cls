@isTest
private class JournalEntryManager_Controller_TEST {
    // -------------------------------------------------------------------------------------------------------------
    // -------------------------------------- findHeaderId Tests --------------------------------------------------
    // -------------------------------------------------------------------------------------------------------------
    @isTest(SeeAllData=true)
    static void testFindHeaderId_BaseCase() {
        JournalEntryManager_Controller jemc = new JournalEntryManager_Controller();


        jemc.headerName = 'Journal Entry Header - 2020_10JE #2022';

        jemc.findHeaderId();

        System.assertEquals(jemc.headerId, 'aCU1I000000XbkfWAC');



        jemc.headerName = 'Journal Entry Header - 2018_11JE #20';

        jemc.findHeaderId();

        System.assertEquals(jemc.headerId, 'aCU1I00000002lKWAQ');



        jemc.headerName = 'Journal Entry Header - 2020_5JE #1638';

        jemc.findHeaderId();

        System.assertEquals(jemc.headerId, 'aCU1I0000008QtCWAU');



        jemc.headerName = 'Journal Entry Header - 2020-12JE #2568';

        jemc.findHeaderId();

        System.assertEquals(jemc.headerId, 'aCU7b0000008XIsGAM');



        jemc.headerName = 'Journal Entry Header - 2018_10JE #15';

        jemc.findHeaderId();

        System.assertEquals(jemc.headerId, 'aCU1I00000002kvWAA');



        jemc.headerName = '#152';

        jemc.findHeaderId();

        System.assertEquals(jemc.headerId, 'aCU1I00000002wDWAQ');
    }



    // -------------------------------------------------------------------------------------------------------------
    // -------------------------------------- getAccountIdFromName Tests --------------------------------------------------
    // -------------------------------------------------------------------------------------------------------------
    @isTest(SeeAllData=true)
    static void testGetAccountIdFromName_BaseCase() {
        JournalEntryManager_Controller jemc = new JournalEntryManager_Controller();

        System.assertEquals(jemc.getAccountIdFromName('2233', 'STB'), 'aBu1I000000GpUCSA0');

        System.assertEquals(jemc.getAccountIdFromName('3000', 'STB'), 'aBu1I000000GpUTSA0');

        System.assertEquals(jemc.getAccountIdFromName('3887', 'STB'), 'aBu1I000000GpUkSAK');

        System.assertEquals(jemc.getAccountIdFromName('4754', 'STB'), 'aBu1I000000GpUySAK');
    }



    // -------------------------------------------------------------------------------------------------------------
    // -------------------------------------- getDivisionIdFromName Tests --------------------------------------------------
    // -------------------------------------------------------------------------------------------------------------
    @isTest(SeeAllData=true)
    static void testGetDivisionIdFromName_BaseCase() {
        JournalEntryManager_Controller jemc = new JournalEntryManager_Controller();

        System.assertEquals(jemc.getDivisionIdFromName('STB'), 'aC91I0000008VYnSAM');

        System.assertEquals(jemc.getDivisionIdFromName('STE'), 'aC91I00000005RKSAY');
    }



    // -------------------------------------------------------------------------------------------------------------
    // -------------------------------------- searchDebitExists Tests --------------------------------------------------
    // -------------------------------------------------------------------------------------------------------------
    @isTest(SeeAllData=true)
    static void testSearchDebitExists_BaseCase() {
        JournalEntryManager_Controller jemc = new JournalEntryManager_Controller();


        jemc.groupedDebits = [
            SELECT rstkf__gltxn_tranno__c, SUM(rstkf__gltxn_dramt__c)
            FROM rstkf__gltxn__c
            WHERE rstkf__gltxn_glacct__c='aBu1I00000003WqSAI' AND rstkf__gltxn_gldiv__c='aC91I00000005RKSAY' AND rstkf__gltxn_dramt__c>0
            GROUP BY rstkf__gltxn_tranno__c
            ORDER BY SUM(rstkf__gltxn_dramt__c)
        ];


        System.assert(jemc.searchDebitExists(29668.4));

        System.assert(jemc.searchDebitExists(30500));

        System.assert(!jemc.searchDebitExists(123456));

        System.assert(jemc.searchDebitExists(145285.36));

        System.assert(jemc.searchDebitExists(910.18));
    }



    // -------------------------------------------------------------------------------------------------------------
    // -------------------------------------- searchCreditExists Tests --------------------------------------------------
    // -------------------------------------------------------------------------------------------------------------
    @isTest(SeeAllData=true)
    static void testSearchCreditExists_BaseCase() {
        JournalEntryManager_Controller jemc = new JournalEntryManager_Controller();


        jemc.groupedCredits = [
            SELECT rstkf__gltxn_tranno__c, SUM(rstkf__gltxn_cramt__c)
            FROM rstkf__gltxn__c
            WHERE rstkf__gltxn_glacct__c='aBu1I00000003WqSAI' AND rstkf__gltxn_gldiv__c='aC91I00000005RKSAY' AND rstkf__gltxn_cramt__c>0
            GROUP BY rstkf__gltxn_tranno__c
            ORDER BY SUM(rstkf__gltxn_cramt__c)
        ];


        System.assert(jemc.searchCreditExists(18));

        System.assert(jemc.searchCreditExists(1200.12));

        System.assert(!jemc.searchCreditExists(123456));

        System.assert(jemc.searchCreditExists(10000));

        System.assert(jemc.searchCreditExists(141992.88));
    }



    // -------------------------------------------------------------------------------------------------------------
    // -------------------------------------- loadCSV Tests --------------------------------------------------
    // -------------------------------------------------------------------------------------------------------------
    @isTest(SeeAllData=true)
    static void testLoadCSV_BaseCase() {
        JournalEntryManager_Controller jemc = new JournalEntryManager_Controller();

        jemc.csvBody= [
            SELECT Body
            FROM StaticResource
            WHERE Name='RootstockJETemplate'
        ].Body.toString();


        System.assert(jemc.loadedRecords.size() == 0);

        jemc.loadCSV();

        System.assert(jemc.loadedRecords.size() > 0);
    }



    // -------------------------------------------------------------------------------------------------------------
    // -------------------------------------- insertData Tests --------------------------------------------------
    // -------------------------------------------------------------------------------------------------------------
    @isTest(SeeAllData=true)
    static void testInsertData_BaseCase() {
        JournalEntryManager_Controller jemc = new JournalEntryManager_Controller();

        jemc.csvBody= [
            SELECT Body
            FROM StaticResource
            WHERE Name='RootstockJETemplate'
        ].Body.toString();


        System.assert(jemc.loadedRecords.size() == 0);

        jemc.loadCSV();

        System.assert(jemc.loadedRecords.size() > 0);


        jemc.headerId = 'aCU1I00000002lKWAQ';

        jemc.insertData();
    }



    // -------------------------------------------------------------------------------------------------------------
    // -------------------------------------- downloadUnreconciled Tests --------------------------------------------------
    // -------------------------------------------------------------------------------------------------------------
    @isTest(SeeAllData=true)
    static void testDownloadUnreconciled_BaseCase() {
        JournalEntryManager_Controller jemc = new JournalEntryManager_Controller();


        System.assertEquals(jemc.downloadUnreconciled(), null);


        jemc.postUnreconciledRecords.add(new Map<String,String>());

        System.assert(jemc.postUnreconciledRecords.size() > 0);


        System.assertNotEquals(jemc.downloadUnreconciled(), null);
    }
}
