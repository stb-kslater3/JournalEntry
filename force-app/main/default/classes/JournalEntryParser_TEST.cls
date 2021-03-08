@isTest
private class JournalEntryParser_TEST {
    // --------------------------------------------------------------------------------------------------
    // ---------------------------------- rowJEDetail Tests -----------------------------------------------
    // --------------------------------------------------------------------------------------------------
    @isTest
    static void testRowJEDetail_BaseCase() {
        String[] rows = new String[]{
            // 0
            '7411,32.54,Summit Truck Bodies (STB),Vendor 05038 Invoice AMX OCT2020 KRIS',

            // 1
            '2401,"-111,350.00",Summit Truck Bodies (STB),IC-012821/STE10020-C',

            // 2
            '7411,(3.4),Summit Truck Bodies (STB),Vendor 12805 Invoice 1N6W-NN9C-PPC6',

            // 3
            '7421,-7.2,Summit Truck Bodies (STB),Voided Check 432668 Sequence 12500792',

            // 4
            '2401,"(-111,350.00)",Summit Truck Bodies (STB),IC-012821/STE10021-C',

            // 5
            '2401,"111,350.00",Summit Truck Bodies (STB),IC-012821/STE10021-C',

            // 6
            '2401,"23,350.00",Summit Truck Bodies (STB),IC-012821/STE10021-C'
        };


        Map<String, Object> rowMap;


        rowMap = JournalEntryParser.row_JEDetail(rows[0]);
        System.assertEquals(rowMap.get('rstkf__gljd_glacct__c'), '7411');
        System.assertEquals(rowMap.get('rstkf__gljd_dramt__c'), '32.54');
        System.assertEquals(rowMap.get('rstkf__gljd_cramt__c'), '0.00');
        System.assertEquals(rowMap.get('rstkf__gljd_gldiv__c'), 'STB');
        System.assertEquals(rowMap.get('rstkf__gljd_linecomment__c'), 'Vendor 05038 Invoice AMX OCT2020 KRIS');


        rowMap = JournalEntryParser.row_JEDetail(rows[1]);
        System.assertEquals(rowMap.get('rstkf__gljd_glacct__c'), '2401');
        System.assertEquals(rowMap.get('rstkf__gljd_dramt__c'), '0.00');
        System.assertEquals(rowMap.get('rstkf__gljd_cramt__c'), '111350.00');
        System.assertEquals(rowMap.get('rstkf__gljd_gldiv__c'), 'STB');
        System.assertEquals(rowMap.get('rstkf__gljd_linecomment__c'), 'IC-012821/STE10020-C');


        rowMap = JournalEntryParser.row_JEDetail(rows[2]);
        System.assertEquals(rowMap.get('rstkf__gljd_glacct__c'), '7411');
        System.assertEquals(rowMap.get('rstkf__gljd_dramt__c'), '0.00');
        System.assertEquals(rowMap.get('rstkf__gljd_cramt__c'), '3.4');
        System.assertEquals(rowMap.get('rstkf__gljd_gldiv__c'), 'STB');
        System.assertEquals(rowMap.get('rstkf__gljd_linecomment__c'), 'Vendor 12805 Invoice 1N6W-NN9C-PPC6');

        
        rowMap = JournalEntryParser.row_JEDetail(rows[3]);
        System.assertEquals(rowMap.get('rstkf__gljd_glacct__c'), '7421');
        System.assertEquals(rowMap.get('rstkf__gljd_dramt__c'), '0.00');
        System.assertEquals(rowMap.get('rstkf__gljd_cramt__c'), '7.2');
        System.assertEquals(rowMap.get('rstkf__gljd_gldiv__c'), 'STB');
        System.assertEquals(rowMap.get('rstkf__gljd_linecomment__c'), 'Voided Check 432668 Sequence 12500792');

        
        rowMap = JournalEntryParser.row_JEDetail(rows[4]);
        System.assertEquals(rowMap.get('rstkf__gljd_glacct__c'), '2401');
        System.assertEquals(rowMap.get('rstkf__gljd_dramt__c'), '0.00');
        System.assertEquals(rowMap.get('rstkf__gljd_cramt__c'), '111350.00');
        System.assertEquals(rowMap.get('rstkf__gljd_gldiv__c'), 'STB');
        System.assertEquals(rowMap.get('rstkf__gljd_linecomment__c'), 'IC-012821/STE10021-C');

        
        rowMap = JournalEntryParser.row_JEDetail(rows[5]);
        System.assertEquals(rowMap.get('rstkf__gljd_glacct__c'), '2401');
        System.assertEquals(rowMap.get('rstkf__gljd_dramt__c'), '111350.00');
        System.assertEquals(rowMap.get('rstkf__gljd_cramt__c'), '0.00');
        System.assertEquals(rowMap.get('rstkf__gljd_gldiv__c'), 'STB');
        System.assertEquals(rowMap.get('rstkf__gljd_linecomment__c'), 'IC-012821/STE10021-C');

        
        rowMap = JournalEntryParser.row_JEDetail(rows[6]);
        System.assertEquals(rowMap.get('rstkf__gljd_glacct__c'), '2401');
        System.assertEquals(rowMap.get('rstkf__gljd_dramt__c'), '23350.00');
        System.assertEquals(rowMap.get('rstkf__gljd_cramt__c'), '0.00');
        System.assertEquals(rowMap.get('rstkf__gljd_gldiv__c'), 'STB');
        System.assertEquals(rowMap.get('rstkf__gljd_linecomment__c'), 'IC-012821/STE10021-C');
    }
}
