@isTest
private class JournalEntryReconciler_ControllerTest {
    // -------------------------------------------------------------------------------------
    // ------------------------------ findHeaderId Tests -----------------------------------
    // -------------------------------------------------------------------------------------
    /*
    // RS PILOT
    @isTest(SeeAllData=true)
    static void testFindHeaderId_BaseCase() {
        JournalEntryReconciler_Controller controller = new JournalEntryReconciler_Controller();
        controller.headerName = '2020-10JE #2122';

        System.assertEquals(controller.headerId, null);

        controller.findHeaderId();

        System.assertEquals(controller.headerId, 'aCU030000008QsKGAU');
    }
    */
    // PRODCUTION
    @isTest(SeeAllData=true)
    static void testFindHeaderId_BaseCase() {
        JournalEntryReconciler_Controller controller = new JournalEntryReconciler_Controller();
        controller.headerName = '2021-1JE #2538';

        System.assertEquals(controller.headerId, null);

        controller.findHeaderId();

        System.assertEquals(controller.headerId, 'aCU1I000000XcShWAK');
    }
    

    // -------------------------------------------------------------------------------------
    // ------------------------------ parseRow Tests -----------------------------------
    // -------------------------------------------------------------------------------------

    @isTest
    static void testParseRow_BaseCase() {
        String row = '1133 (Due To/From Sbw (Alfred)),12345678.90,Summit Truck Bodies (STB),Bla Bla';

        JournalEntryReconciler_Controller controller = new JournalEntryReconciler_Controller();

        Map<String, Object> rowMap = controller.parseRow(row);

        System.assertEquals(rowMap.size(), 5);

        System.assertEquals(rowMap.get('rstkf__gljd_glacct__c'), '1133');
        System.assertEquals(rowMap.get('rstkf__gljd_dramt__c'), '0.00');
        System.assertEquals(rowMap.get('rstkf__gljd_cramt__c'), '12345678.90');
        System.assertEquals(rowMap.get('rstkf__gljd_gldiv__c'), 'STB');
        System.assertEquals(rowMap.get('rstkf__gljd_linecomment__c'), 'Bla Bla');
    }



    // -------------------------------------------------------------------------------------
    // ------------------------------ getAccountIdFromName Tests -----------------------------------
    // -------------------------------------------------------------------------------------

    @isTest(SeeAllData=true)
    static void testGetAccountIdFromName_BaseCase() {
        JournalEntryReconciler_Controller controller = new JournalEntryReconciler_Controller();

        Id accountId = controller.getAccountIdFromName('1133', 'STB');

        System.assertEquals(accountId, 'aBu1I000000GpT9SAK');
    }



    // -------------------------------------------------------------------------------------
    // ------------------------------ getDivisionIdFromName Tests -----------------------------------
    // -------------------------------------------------------------------------------------

    @isTest(SeeAllData=true)
    static void testGetDivisionIdFromName_BaseCase() {
        JournalEntryReconciler_Controller controller = new JournalEntryReconciler_Controller();

        Id divisionId = controller.getDivisionIdFromName('STB');

        System.assertEquals(divisionId, 'aC91I0000008VYnSAM');
    }


    // -------------------------------------------------------------------------------------
    // ------------------------------ loadCSV Tests -----------------------------------
    // -------------------------------------------------------------------------------------

    @isTest(SeeAllData=true)
    static void testLoadCSV_BaseCase() {
        JournalEntryReconciler_Controller controller = new JournalEntryReconciler_Controller();

        /*
        // OLD BODY STRING
        String bodyString = 'Account,Debit Amount,Credit Amount,Division,Comment\n' + 
        '1133 (Due To/From Sbw (Alfred)),"12,345,678.90",0.00,Summit Truck Bodies (STB),Bla Bla\n' +
        '1115,245.00,0.00,STB,\n' +
        '1133 (Due To/From Sbw (Alfred)),0.00,"12,345,678.90",STB,Balance\n' +
        '1115,0.00,245.00,Summit Truck Bodies (STB),Can be empty\n' +
        '1133 (Due To/From Sbw (Alfred)),76.92,0.00,Summit Truck Bodies (STB),comments\n' +
        '1133 (Due To/From Sbw (Alfred)),"3,335.00",0.00,Summit Truck Bodies (STB),comments\n';
        */
        // NEW BODY STRING
        String bodyString = 'Account,Debit Amount,Credit Amount,Division,Comment\n' + 
        '1133 (Due To/From Sbw (Alfred)),12345678.90,Summit Truck Bodies (STB),Bla Bla\n' +
        '1115,245.00,STB,\n' +
        '1133 (Due To/From Sbw (Alfred)),(12345678.90),STB,Balance\n' +
        '1115,(245.00),Summit Truck Bodies (STB),Can be empty\n' +
        '1133 (Due To/From Sbw (Alfred)),76.92,Summit Truck Bodies (STB),comments\n' +
        '1133 (Due To/From Sbw (Alfred)),3335.00,Summit Truck Bodies (STB),comments\n' +
        '1133 (Due To/From Sbw (Alfred)),(14755.76),Summit Truck Bodies (STB),comments\n' +
        '1133 (Due To/From Sbw (Alfred)),7479.73,Summit Truck Bodies (STB),comments\n';

        Blob bodyBlob = Blob.valueOf(bodyString);

        controller.csvBody = bodyBlob;

        System.assertEquals(controller.loadedRecords.size(), 0);

        controller.loadCSV();

        System.assert(controller.loadedRecords.size() > 0);

        System.assertEquals(controller.loadedRecords[0].rstkf__gljd_cramt__c, 12345678.90);

        System.assertEquals(controller.loadedRecords[5].rstkf__gljd_dramt__c, 0.00);
    }




    // -------------------------------------------------------------------------------------
    // ------------------------------ insertData Tests -----------------------------------
    // -------------------------------------------------------------------------------------
    /*
    // RSPILOT
    @isTest(SeeAllData=true)
    static void testInsertData_BaseCase() {
        JournalEntryReconciler_Controller controller = new JournalEntryReconciler_Controller();
        controller.headerName = '2020-10JE #2122';

        /*
        // OLD BODY STRING
        String bodyString = 'Account,Debit Amount,Credit Amount,Division,Comment\n' + 
        '1133 (Due To/From Sbw (Alfred)),"12,345,678.90",0.00,Summit Truck Bodies (STB),Bla Bla\n' +
        '1115,245.00,0.00,STB,\n' +
        '1133 (Due To/From Sbw (Alfred)),0.00,"12,345,678.90",STB,Balance\n' +
        '1115,0.00,245.00,Summit Truck Bodies (STB),Can be empty\n' +
        '1133 (Due To/From Sbw (Alfred)),76.92,0.00,Summit Truck Bodies (STB),comments\n' +
        '1133 (Due To/From Sbw (Alfred)),"3,335.00",0.00,Summit Truck Bodies (STB),comments\n';
        */
    /*    // NEW BODY STRING
        String bodyString = 'Account,Debit Amount,Credit Amount,Division,Comment\n' + 
        '1133 (Due To/From Sbw (Alfred)),12345678.90,Summit Truck Bodies (STB),Bla Bla\n' +
        '1115,245.00,STB,\n' +
        '1133 (Due To/From Sbw (Alfred)),(12345678.90),STB,Balance\n' +
        '1115,(245.00),Summit Truck Bodies (STB),Can be empty\n' +
        '1133 (Due To/From Sbw (Alfred)),76.92,Summit Truck Bodies (STB),comments\n' +
        '1133 (Due To/From Sbw (Alfred)),3335.00,Summit Truck Bodies (STB),comments\n' +
        '1133 (Due To/From Sbw (Alfred)),(14755.76),Summit Truck Bodies (STB),comments\n' +
        '1133 (Due To/From Sbw (Alfred)),7479.73,Summit Truck Bodies (STB),comments\n';

        Blob bodyBlob = Blob.valueOf(bodyString);

        controller.csvBody = bodyBlob;

        System.assertEquals(controller.loadedRecords.size(), 0);
        controller.loadCSV();
        System.assert(controller.loadedRecords.size() > 0);


        System.assertEquals(controller.headerId, null);
        controller.findHeaderId();
        System.assertEquals(controller.headerId, 'aCU030000008QsKGAU');

        
        controller.insertData();

        System.assertEquals(ApexPages.getMessages()[0].getSummary(), 'CSV Uploaded');
    }
    */
    // PRODUCTION
    @isTest(SeeAllData=true)
    static void testInsertData_BaseCase() {
        JournalEntryReconciler_Controller controller = new JournalEntryReconciler_Controller();
        controller.headerName = '2021-1JE #2538';

        /*
        // Old Body String
        String bodyString = 'Account,Debit Amount,Credit Amount,Division,Comment\n' + 
        '1133 (Due To/From Sbw (Alfred)),"12,345,678.90",0.00,Summit Truck Bodies (STB),Bla Bla\n' +
        '1115,245.00,0.00,STB,\n' +
        '1133 (Due To/From Sbw (Alfred)),0.00,"12,345,678.90",STB,Balance\n' +
        '1115,0.00,245.00,Summit Truck Bodies (STB),Can be empty\n' +
        '1133 (Due To/From Sbw (Alfred)),76.92,0.00,Summit Truck Bodies (STB),comments\n' +
        '1133 (Due To/From Sbw (Alfred)),"3,335.00",0.00,Summit Truck Bodies (STB),comments\n';
        */
        // NEW BODY STRING
        String bodyString = 'Account,Debit Amount,Credit Amount,Division,Comment\n' + 
        '1133 (Due To/From Sbw (Alfred)),12345678.90,Summit Truck Bodies (STB),Bla Bla\n' +
        '1115,245.00,STB,\n' +
        '1133 (Due To/From Sbw (Alfred)),(12345678.90),STB,Balance\n' +
        '1115,(245.00),Summit Truck Bodies (STB),Can be empty\n' +
        '1133 (Due To/From Sbw (Alfred)),76.92,Summit Truck Bodies (STB),comments\n' +
        '1133 (Due To/From Sbw (Alfred)),3335.00,Summit Truck Bodies (STB),comments\n' +
        '1133 (Due To/From Sbw (Alfred)),(14755.76),Summit Truck Bodies (STB),comments\n' +
        '1133 (Due To/From Sbw (Alfred)),7479.73,Summit Truck Bodies (STB),comments\n';
    
        Blob bodyBlob = Blob.valueOf(bodyString);

        controller.csvBody = bodyBlob;

        System.assertEquals(controller.loadedRecords.size(), 0);
        controller.loadCSV();
        System.assert(controller.loadedRecords.size() > 0);


        System.assertEquals(controller.headerId, null);
        controller.findHeaderId();
        System.assertEquals(controller.headerId, 'aCU1I000000XcShWAK');

        
        controller.insertData();

        System.assertEquals(ApexPages.getMessages()[0].getSummary(), 'CSV Uploaded');
    }

}