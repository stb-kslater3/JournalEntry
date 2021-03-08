public class JournalEntryParser {
    public static List<String> money_cell(String frontRow) {
        List<String> row_split = new List<String>();

        Pattern amountPattern = Pattern.compile('(\\d{1,3}+\\,(\\d{3}\\,)*\\d{3}(\\.\\d{0,2})?)|(\\d+(\\.\\d{0,2})?)');

        Matcher amountMatcher = amountPattern.Matcher(frontRow);
        amountMatcher.find();

        String amountCell = amountMatcher.group();
        String[] cells = amountCell.split(',');
        amountCell = cells[0];
        for(Integer i = 1; i < cells.size(); i++) {
            amountCell += cells[i];
        }

        String[] splitOff = frontRow.split('((((\\(\\")|(\\"\\()|(\\"))?\\-?\\d{1,3}\\,(\\d{3}\\,)*\\d{3}(\\.\\d{0,2})?((\\)\\")|(\\"\\))|(\\"))?)|((\\(|\\-)?\\d+(\\.\\d{0,2})?\\)?))\\,', 2);

        row_split.add(amountCell);
        row_split.add(splitOff[1]);

        return row_split;
    }

    
    public static Map<String, Object> row_JEDetail(String row) {
        Map<String, Object> fieldValuePairs = new Map<String, Object>();

        String[] csvCells;

        // Parse Account
        csvCells = row.split(',', 2);

        String accountCell = '';

        Pattern accountPattern = Pattern.compile('\\d+(\\.\\d+)*');
        Matcher accountMatcher = accountPattern.Matcher(csvCells[0]);
        accountMatcher.find();

        accountCell = accountMatcher.group();

        fieldValuePairs.put('rstkf__gljd_glacct__c', accountCell);
        row = csvCells[1];
System.debug(accountCell + ' || ' + csvCells[1]);


        // Parse Amount
        Pattern amountPattern = Pattern.compile('((((\\(\\")|(\\"\\()|(\\"))?\\-?\\d{1,3}\\,(\\d{3}\\,)*\\d{3}(\\.\\d{0,2})?((\\)\\")|(\\"\\))|(\\"))?)|((\\(|\\-)?\\d+(\\.\\d{0,2})?\\)?))\\,');
        Matcher amountMatcher = amountPattern.Matcher(row);
        amountMatcher.find();

        string[] amount_split = money_cell(row);

        if(amountMatcher.group().contains('-') | amountMatcher.group().contains('(')) {
            fieldValuePairs.put('rstkf__gljd_dramt__c', '0.00');
            fieldValuePairs.put('rstkf__gljd_cramt__c', amount_split[0]);
        }else {
            fieldValuePairs.put('rstkf__gljd_dramt__c', amount_split[0]);
            fieldValuePairs.put('rstkf__gljd_cramt__c', '0.00');
        }

        row = amount_split[1];
System.debug(amount_split[0] + ' || ' + amount_split[1]);
    /*
        // Parse Amount
        csvCells = row.split(',', 2);
        
        if( csvCells[0].contains('(') || csvCells[0].contains('-') ) {
            Pattern amountPattern = Pattern.compile('\\d+\\.\\d{2}'); 
            Matcher amountMatcher = amountPattern.Matcher(csvCells[0]);
            amountMatcher.find();

            fieldValuePairs.put('rstkf__gljd_dramt__c', '0.00');
            fieldValuePairs.put('rstkf__gljd_cramt__c', amountMatcher.group());
        }else {
            fieldValuePairs.put('rstkf__gljd_dramt__c', csvCells[0]);
            fieldValuePairs.put('rstkf__gljd_cramt__c', '0.00');
        }

        row = csvCells[1];
    */
    /*
    // OLD PARSE DEBIT CREDIT
        String[] tempCells;

        // Parse Debit
        if(row.split(',')[0].containsAny('"')) {
            csvCells = row.split('"', 2);
            row = csvCells[1];
            csvCells = row.split('",', 2);

            tempCells = csvCells[0].split(',');
            String debitCell = '';

            for(String cell : tempCells) {
                debitCell += cell;
            }

            fieldValuePairs.put('rstkf__gljd_dramt__c', debitCell);
            row = csvCells[1];
        }else {
            csvCells = row.split(',', 2);
            fieldValuePairs.put('rstkf__gljd_dramt__c', csvCells[0]);
            row = csvCells[1];
        }


        // Parse Credit
        if(row.split(',')[0].containsAny('"')) {
            csvCells = row.split('"', 2);
            row = csvCells[1];
            csvCells = row.split('",', 2);

            tempCells = csvCells[0].split(',');
            String creditCell = '';

            for(String cell : tempCells) {
                creditCell += cell;
            }

            fieldValuePairs.put('rstkf__gljd_cramt__c', creditCell);
            row = csvCells[1];
        }else {
            csvCells = row.split(',', 2);
            fieldValuePairs.put('rstkf__gljd_cramt__c', csvCells[0]);
            row = csvCells[1];
        }
    */

        // Parse Division
        csvCells = row.split(',', 2);

        String divisionCell = '';

        Pattern divisionPattern = Pattern.compile('ST(E|B)');
        Matcher divisionMatcher = divisionPattern.Matcher(csvCells[0]);
        divisionMatcher.find();

        divisionCell = divisionMatcher.group();

        fieldValuePairs.put('rstkf__gljd_gldiv__c', divisionCell);
        row = csvCells[1];
System.debug(divisionCell + ' || ' + csvCells[1]);

        // Parse Comment
        csvCells = row.split(',', 2);
        fieldValuePairs.put('rstkf__gljd_linecomment__c', csvCells[0]);
System.debug(csvCells[0]);

        return fieldValuePairs;
    }
}
