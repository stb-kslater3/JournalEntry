public class JournalEntryParser {
    public static String[] account_cell(String row) {
        String[] cell_and_remainder = new String[2];

        try {
            String[] split = row.split(',', 2);

            cell_and_remainder[1] = split[1].trim();

            String regEx = '\\d{4}';
            Pattern accountPattern = Pattern.compile(regex);
            Matcher accountMatcher = accountPattern.Matcher(split[0]);

            if(accountMatcher.find()) {
                cell_and_remainder[0] = accountMatcher.group().trim();
            }else {
                cell_and_remainder[0] = null;

                String exceptionNotification = 'Failed to parse Account from CSV. Check format of Account Cell.';

                System.debug(exceptionNotification);

                ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR, exceptionNotification);
                ApexPages.addMessage(errorMessage);
            }
        }catch(Exception e) {
            String exceptionNotification = 'EXCEPTION in call to JournalEntryParser.account_cell(): ' + e.getMessage();

            System.debug(exceptionNotification + '\nEXCEPTION TYPE: ' + e.getTypeName() + '\nSTACK TRACE: ' + e.getStackTraceString());

            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR, exceptionNotification);
            ApexPages.addMessage(errorMessage);
        }

        return cell_and_remainder;
    }



    public static String[] money_cell(String row) {
        String[] cell_and_remainder = new String[2];

        try {
            String regEx = '(\\d{1,3}\\,(\\d{3}\\,)*\\d{3}(\\.\\d{0,2})?)|(\\d+(\\.\\d{0,2})?)';

            Pattern amountPattern = Pattern.compile(regEx);
            Matcher amountMatcher = amountPattern.Matcher(row);
            if(amountMatcher.find()) {
                String amountCell = amountMatcher.group();

                String[] cells = amountCell.split(',');
                amountCell = cells[0];
                
                for(Integer i = 1; i < cells.size(); i++) {
                    amountCell += cells[i].trim();
                }

                String[] split = row.split('((((\\(\\")|(\\"\\()|(\\"))?\\-?\\d{1,3}\\,(\\d{3}\\,)*\\d{3}(\\.\\d{0,2})?((\\)\\")|(\\"\\))|(\\"))?)|((\\(|\\-)?\\d+(\\.\\d{0,2})?\\)?))\\,', 2);

                cell_and_remainder[0] = amountCell.trim();
                cell_and_remainder[1] = split[1].trim();

                if(String.isEmpty(cell_and_remainder[0])) {
                    cell_and_remainder[0] = '0.00';
                }
            }else {
                String exceptionNotification = 'Check Formatting in Money Cell, couldn\'t find a match.';

                System.debug(exceptionNotification);

                ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR, exceptionNotification);
                ApexPages.addMessage(errorMessage);
            }
        }catch(Exception e) {
            String exceptionNotification = 'EXCEPTION in call to JournalEntryParser.money_cell(): ' + e.getMessage();

            System.debug(exceptionNotification + '\nEXCEPTION TYPE: ' + e.getTypeName() + '\nSTACK TRACE: ' + e.getStackTraceString());

            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR, exceptionNotification);
            ApexPages.addMessage(errorMessage);
        }

        return cell_and_remainder;
    }



    public static String[] division_cell(String row) {
        String[] cell_and_remainder = new String[2];

        try {
            String[] split = row.split(',', 2);

            cell_and_remainder[1] = split[1].trim();

            Pattern divisionPattern = Pattern.compile('ST(E|B)');
            Matcher divisionMatcher = divisionPattern.Matcher(split[0]);

            if(divisionMatcher.find()) {
                cell_and_remainder[0] = divisionMatcher.group().trim();
            }
        }catch(Exception e) {
            String exceptionNotification = 'EXCEPTION in call to JournalEntryParser.division_cell(): ' + e.getMessage();

            System.debug(exceptionNotification + '\nEXCEPTION TYPE: ' + e.getTypeName() + '\nSTACK TRACE: ' + e.getStackTraceString());

            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR, exceptionNotification);
            ApexPages.addMessage(errorMessage);
        }

        return cell_and_remainder;
    }



    public static String[] project_cell(String row) {
        String[] cell_and_remainder = new String[2];

        try {
            String regEx = '(\\(.+\\),)|(\\(.+\\)",)';

            Pattern projectPattern = Pattern.compile(regex);
            Matcher projectMatcher = projectPattern.Matcher(row);

            String[] split;

            if(projectMatcher.find()) {
                split = row.split(regEx, 2);
            }else {
                split = row.split(',', 2);
            }

            cell_and_remainder[0] = split[0].trim();
            cell_and_remainder[1] = split[1].trim();

            if(String.isEmpty(cell_and_remainder[0])) {
                cell_and_remainder[0] = null;
            }else if(cell_and_remainder[0].contains('"')) {
                cell_and_remainder[0] = cell_and_remainder[0].split('"')[1];
            }
        }catch(Exception e) {
            String exceptionNotification = 'EXCEPTION in call to JournalEntryParser.project_cell(): ' + e.getMessage();

            System.debug(exceptionNotification + '\nEXCEPTION TYPE: ' + e.getTypeName() + '\nSTACK TRACE: ' + e.getStackTraceString());

            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR, exceptionNotification);
            ApexPages.addMessage(errorMessage);
        }

        return cell_and_remainder;
    }


    
    public static Map<String, Object> row_JEDetail(String row) {
        Map<String, Object> fieldValuePairs = new Map<String, Object>();

        String[] csvCells;

        //System.debug('ROW_0: ' + row);

        // Parse Account
        String[] accountParsed = account_cell(row);
        fieldValuePairs.put('rstkf__gljd_glacct__c', accountParsed[0]);
        row = accountParsed[1];
        //System.debug('ROW_1: ' + row);


        // Parse Amount
        Pattern amountPattern = Pattern.compile('((((\\(\\")|(\\"\\()|(\\"))?\\-?\\d{1,3}\\,(\\d{3}\\,)*\\d{3}(\\.\\d{0,2})?((\\)\\")|(\\"\\))|(\\"))?)|((\\(|\\-)?\\d+(\\.\\d{0,2})?\\)?))\\,');
        Matcher amountMatcher = amountPattern.Matcher(row);
        amountMatcher.find();

        string[] amountParsed = money_cell(row);

        if(amountMatcher.group().contains('-') | amountMatcher.group().contains('(')) {
            fieldValuePairs.put('rstkf__gljd_dramt__c', '0.00');
            fieldValuePairs.put('rstkf__gljd_cramt__c', amountParsed[0]);
        }else {
            fieldValuePairs.put('rstkf__gljd_dramt__c', amountParsed[0]);
            fieldValuePairs.put('rstkf__gljd_cramt__c', '0.00');
        }

        row = amountParsed[1];
        //System.debug('ROW_2: ' + row);


        // Parse Division
        String[] divisionParsed = division_cell(row);
        fieldValuePairs.put('rstkf__gljd_gldiv__c', divisionParsed[0]);
        row = divisionParsed[1];
        //System.debug('ROW_3: ' + row);


        // Parse Project
        String[] projectParsed = project_cell(row);
        fieldValuePairs.put('rstkf__gljd_glproj__c', projectParsed[0]);
        row = projectParsed[1];
        //System.debug('ROW_4: ' + row);


        // Parse Comment
        csvCells = row.split(',', 2);
        fieldValuePairs.put('rstkf__gljd_linecomment__c', csvCells[0]);

        return fieldValuePairs;
    }
}
