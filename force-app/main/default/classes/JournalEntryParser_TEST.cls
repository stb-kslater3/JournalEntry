@isTest
private class JournalEntryParser_TEST {
    // --------------------------------------------------------------------------------------------------
    // ---------------------------------- account_cell Tests -----------------------------------------------
    // --------------------------------------------------------------------------------------------------
    @isTest
    static void testAccountCell_BaseCase() {
        String[] s_n = new String[] { 
            '1234(bla bla), bla',
            '1234, bla',
            ' , bla',
            ', bla'
        };
            
        String row;
        String[] accountParsed;
        
            
        accountParsed = JournalEntryParser.account_cell(s_n[0]);
        System.assertEquals('1234', accountParsed[0]);
        System.assertEquals('bla', accountParsed[1]);

        accountParsed = JournalEntryParser.account_cell(s_n[1]);
        System.assertEquals('1234', accountParsed[0]);
        System.assertEquals('bla', accountParsed[1]);

        accountParsed = JournalEntryParser.account_cell(s_n[2]);
        System.assertEquals(null, accountParsed[0]);
        System.assertEquals('bla', accountParsed[1]);

        accountParsed = JournalEntryParser.account_cell(s_n[3]);
        System.assertEquals(null, accountParsed[0]);
        System.assertEquals('bla', accountParsed[1]);
    }


    // --------------------------------------------------------------------------------------------------
    // ---------------------------------- money_cell Tests -----------------------------------------------
    // --------------------------------------------------------------------------------------------------
    @isTest
    static void testMoneyCell_BaseCase() {
        String[] s_n = new String[] {
            '"11,356.25", bla', 
            '31234.56, bla',
            '$1234, bla',
            '"$12,345.67", bla',
            '-124.5, bla',
            '-$"11,245.63", bla',
            '"-$22,313.27", bla',
            '23.5, bla',
            ' , bla',
            ', bla'
        };
            
        String row;
        String[] moneyParsed;
        
            
        moneyParsed = JournalEntryParser.money_cell(s_n[0]);
        System.assertEquals('11356.25', moneyParsed[0]);
        System.assertEquals('bla', moneyParsed[1]);

        moneyParsed = JournalEntryParser.money_cell(s_n[1]);
        System.assertEquals('31234.56', moneyParsed[0]);
        System.assertEquals('bla', moneyParsed[1]);

        moneyParsed = JournalEntryParser.money_cell(s_n[2]);
        System.assertEquals('1234', moneyParsed[0]);
        System.assertEquals('bla', moneyParsed[1]);

        moneyParsed = JournalEntryParser.money_cell(s_n[3]);
        System.assertEquals('12345.67', moneyParsed[0]);
        System.assertEquals('bla', moneyParsed[1]);

        moneyParsed = JournalEntryParser.money_cell(s_n[4]);
        System.assertEquals('124.5', moneyParsed[0]);
        System.assertEquals('bla', moneyParsed[1]);

        moneyParsed = JournalEntryParser.money_cell(s_n[5]);
        System.assertEquals('11245.63', moneyParsed[0]);
        System.assertEquals('bla', moneyParsed[1]);

        moneyParsed = JournalEntryParser.money_cell(s_n[6]);
        System.assertEquals('22313.27', moneyParsed[0]);
        System.assertEquals('bla', moneyParsed[1]);

        moneyParsed = JournalEntryParser.money_cell(s_n[7]);
        System.assertEquals('23.5', moneyParsed[0]);
        System.assertEquals('bla', moneyParsed[1]);

        moneyParsed = JournalEntryParser.money_cell(s_n[8]);
        System.assertEquals(null, moneyParsed[0]);
        System.assertEquals(null, moneyParsed[1]);

        moneyParsed = JournalEntryParser.money_cell(s_n[9]);
        System.assertEquals(null, moneyParsed[0]);
        System.assertEquals(null, moneyParsed[1]);
    }


    // --------------------------------------------------------------------------------------------------
    // ---------------------------------- division_cell Tests -----------------------------------------------
    // --------------------------------------------------------------------------------------------------
    @isTest
    static void testDivisionCell_BaseCase() {
        String[] s_n = new String[] {
            'SUMMIT TRUCK EQUIPMENT (STE), bla', 
            'STB, bla',
            'STE(Summit Truck Equipment), bla',
            ' , bla',
            ', bla'
        };
            
        String row;
        String[] divisionParsed;
        
            
        divisionParsed = JournalEntryParser.division_cell(s_n[0]);
        System.assertEquals('STE', divisionParsed[0]);
        System.assertEquals('bla', divisionParsed[1]);

        divisionParsed = JournalEntryParser.division_cell(s_n[1]);
        System.assertEquals('STB', divisionParsed[0]);
        System.assertEquals('bla', divisionParsed[1]);

        divisionParsed = JournalEntryParser.division_cell(s_n[2]);
        System.assertEquals('STE', divisionParsed[0]);
        System.assertEquals('bla', divisionParsed[1]);

        divisionParsed = JournalEntryParser.division_cell(s_n[3]);
        System.assertEquals(null, divisionParsed[0]);
        System.assertEquals('bla', divisionParsed[1]);

        divisionParsed = JournalEntryParser.division_cell(s_n[4]);
        System.assertEquals(null, divisionParsed[0]);
        System.assertEquals('bla', divisionParsed[1]);
    }



    // --------------------------------------------------------------------------------------------------
    // ---------------------------------- project_cell Tests -----------------------------------------------
    // --------------------------------------------------------------------------------------------------
    @isTest
    static void testProjectCell_BaseCase() {
        String[] s_n = new String[] {
            '1234(bla bla, bla bla), bla', 
            '1234(bla bla), bla',
            '1234, bla',
            ' , bla',
            ', bla'
        };
            
        String row;
        String[] projectParsed;
        
            
        projectParsed = JournalEntryParser.project_cell(s_n[0]);
        System.assertEquals('1234', projectParsed[0]);
        System.assertEquals('bla', projectParsed[1]);

        projectParsed = JournalEntryParser.project_cell(s_n[1]);
        System.assertEquals('1234', projectParsed[0]);
        System.assertEquals('bla', projectParsed[1]);

        projectParsed = JournalEntryParser.project_cell(s_n[2]);
        System.assertEquals('1234', projectParsed[0]);
        System.assertEquals('bla', projectParsed[1]);

        projectParsed = JournalEntryParser.project_cell(s_n[3]);
        System.assertEquals(null, projectParsed[0]);
        System.assertEquals('bla', projectParsed[1]);

        projectParsed = JournalEntryParser.project_cell(s_n[4]);
        System.assertEquals(null, projectParsed[0]);
        System.assertEquals('bla', projectParsed[1]);
    }


    // --------------------------------------------------------------------------------------------------
    // ---------------------------------- rowJEDetail Tests -----------------------------------------------
    // --------------------------------------------------------------------------------------------------
    @isTest
    static void testRowJEDetail_BaseCase() {
        String[] rows = new String[]{
            // 0
            '7411,32.54,Summit Truck Bodies (STB), STE1234, Vendor 05038 Invoice AMX OCT2020 KRIS',

            // 1
            '2401,"-111,350.00",Summit Truck Bodies (STB), STE1234, IC-012821/STE10020-C',

            // 2
            '7411,(3.4),Summit Truck Bodies (STB), STE1234, Vendor 12805 Invoice 1N6W-NN9C-PPC6',

            // 3
            '7421,-7.2,Summit Truck Bodies (STB), STE1234, Voided Check 432668 Sequence 12500792',

            // 4
            '2401,"(-111,350.00)",Summit Truck Bodies (STB), STE1234, IC-012821/STE10021-C',

            // 5
            '2401,"111,350.00",Summit Truck Bodies (STB), STE1234, IC-012821/STE10021-C',

            // 6
            '2401,"23,350.00",Summit Truck Bodies (STB), STE1234, IC-012821/STE10021-C'
        };


        Map<String, Object> rowMap;


        rowMap = JournalEntryParser.row_JEDetail(rows[0]);
        System.assertEquals(rowMap.get('rstkf__gljd_glacct__c'), '7411');
        System.assertEquals(rowMap.get('rstkf__gljd_dramt__c'), '32.54');
        System.assertEquals(rowMap.get('rstkf__gljd_cramt__c'), '0.00');
        System.assertEquals(rowMap.get('rstkf__gljd_gldiv__c'), 'STB');
        System.assertEquals(rowMap.get('rstkf__gljd_glproj__c'), 'STE1234');
        System.assertEquals(rowMap.get('rstkf__gljd_linecomment__c'), 'Vendor 05038 Invoice AMX OCT2020 KRIS');


        rowMap = JournalEntryParser.row_JEDetail(rows[1]);
        System.assertEquals(rowMap.get('rstkf__gljd_glacct__c'), '2401');
        System.assertEquals(rowMap.get('rstkf__gljd_dramt__c'), '0.00');
        System.assertEquals(rowMap.get('rstkf__gljd_cramt__c'), '111350.00');
        System.assertEquals(rowMap.get('rstkf__gljd_gldiv__c'), 'STB');
        System.assertEquals(rowMap.get('rstkf__gljd_glproj__c'), 'STE1234');
        System.assertEquals(rowMap.get('rstkf__gljd_linecomment__c'), 'IC-012821/STE10020-C');


        rowMap = JournalEntryParser.row_JEDetail(rows[2]);
        System.assertEquals(rowMap.get('rstkf__gljd_glacct__c'), '7411');
        System.assertEquals(rowMap.get('rstkf__gljd_dramt__c'), '0.00');
        System.assertEquals(rowMap.get('rstkf__gljd_cramt__c'), '3.4');
        System.assertEquals(rowMap.get('rstkf__gljd_gldiv__c'), 'STB');
        System.assertEquals(rowMap.get('rstkf__gljd_glproj__c'), 'STE1234');
        System.assertEquals(rowMap.get('rstkf__gljd_linecomment__c'), 'Vendor 12805 Invoice 1N6W-NN9C-PPC6');

        
        rowMap = JournalEntryParser.row_JEDetail(rows[3]);
        System.assertEquals(rowMap.get('rstkf__gljd_glacct__c'), '7421');
        System.assertEquals(rowMap.get('rstkf__gljd_dramt__c'), '0.00');
        System.assertEquals(rowMap.get('rstkf__gljd_cramt__c'), '7.2');
        System.assertEquals(rowMap.get('rstkf__gljd_gldiv__c'), 'STB');
        System.assertEquals(rowMap.get('rstkf__gljd_glproj__c'), 'STE1234');
        System.assertEquals(rowMap.get('rstkf__gljd_linecomment__c'), 'Voided Check 432668 Sequence 12500792');

        
        rowMap = JournalEntryParser.row_JEDetail(rows[4]);
        System.assertEquals(rowMap.get('rstkf__gljd_glacct__c'), '2401');
        System.assertEquals(rowMap.get('rstkf__gljd_dramt__c'), '0.00');
        System.assertEquals(rowMap.get('rstkf__gljd_cramt__c'), '111350.00');
        System.assertEquals(rowMap.get('rstkf__gljd_gldiv__c'), 'STB');
        System.assertEquals(rowMap.get('rstkf__gljd_glproj__c'), 'STE1234');
        System.assertEquals(rowMap.get('rstkf__gljd_linecomment__c'), 'IC-012821/STE10021-C');

        
        rowMap = JournalEntryParser.row_JEDetail(rows[5]);
        System.assertEquals(rowMap.get('rstkf__gljd_glacct__c'), '2401');
        System.assertEquals(rowMap.get('rstkf__gljd_dramt__c'), '111350.00');
        System.assertEquals(rowMap.get('rstkf__gljd_cramt__c'), '0.00');
        System.assertEquals(rowMap.get('rstkf__gljd_gldiv__c'), 'STB');
        System.assertEquals(rowMap.get('rstkf__gljd_glproj__c'), 'STE1234');
        System.assertEquals(rowMap.get('rstkf__gljd_linecomment__c'), 'IC-012821/STE10021-C');

        
        rowMap = JournalEntryParser.row_JEDetail(rows[6]);
        System.assertEquals(rowMap.get('rstkf__gljd_glacct__c'), '2401');
        System.assertEquals(rowMap.get('rstkf__gljd_dramt__c'), '23350.00');
        System.assertEquals(rowMap.get('rstkf__gljd_cramt__c'), '0.00');
        System.assertEquals(rowMap.get('rstkf__gljd_gldiv__c'), 'STB');
        System.assertEquals(rowMap.get('rstkf__gljd_glproj__c'), 'STE1234');
        System.assertEquals(rowMap.get('rstkf__gljd_linecomment__c'), 'IC-012821/STE10021-C');
    }
}
