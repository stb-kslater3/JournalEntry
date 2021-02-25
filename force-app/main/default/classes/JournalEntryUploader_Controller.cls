public class JournalEntryUploader_Controller {
    public Blob csvBody {get;set;}
	public String csvString {get;set;}

    @TestVisible
    private String[] csvRows;

    public String headerName {get;set;}
    public String headerResultText {get;set;}

    @TestVisible
    private Id headerId;

    @TestVisible
    private Decimal startingLineNumber;

    public List<rstkf__gljd__c> loadedRecords {get;set;}
    

    public JournalEntryUploader_Controller() {
        this.csvRows = new String[]{};

        this.headerResultText = 'Enter a header';

        this.loadedRecords = new List<rstkf__gljd__c>();

        this.startingLineNumber = 1;
    }
    

    public void findHeaderId() {
        String headerNameIdentifier = '';

        Pattern headerPattern = Pattern.compile('\\#\\d+');
        Matcher headerMatcher = headerPattern.Matcher(this.headerName);
        
        if(headerMatcher.find()) {
            headerNameIdentifier = headerMatcher.group();

            String likeHeader = '%' + headerNameIdentifier + '%';

            rstkf__gljh__c[] headerMatch = [
                SELECT Id, Name, rstkf__gljh_maxlineno__c
                FROM rstkf__gljh__c
                WHERE Name LIKE :likeHeader
            ];

            if(headerMatch.size() > 0) {
                Integer matchIndex = 0;
                Boolean matchFound = false;

                String headerMatchNameIdentifier = '';

                while(!matchFound && matchIndex < headerMatch.size()) {
                    headerMatcher = headerPattern.Matcher(headerMatch[matchIndex].Name);
                    
                    if(headerMatcher.find()) {
                        headerMatchNameIdentifier = headerMatcher.group();

                        if(headerMatchNameIdentifier.equals(headerNameIdentifier)) {
                            matchFound = true;
                            break;
                        }
                    }

                    matchIndex += 1;
                }

                this.headerId = headerMatch[matchIndex].Id;

                if(headerMatch[matchIndex].rstkf__gljh_maxlineno__c != null) {
                    this.startingLineNumber = headerMatch[matchIndex].rstkf__gljh_maxlineno__c + 1;
                }
                
                this.headerResultText = 'Found the Header, the header id is: ' + this.headerId;
            }else {
                this.headerResultText = 'Header not found, either it doesn\'t exist, or something went wrong';
            }
        }else {
            this.headerResultText = 'The header name entered doesn\'t appear to have the #xxxx within it. Please re enter with the name with number included. Use the full name if you can';
        }
    }


/*
    public Map<String, Object> parseRow(String row) {
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
/*
        // Parse Division
        csvCells = row.split(',', 2);

        String divisionCell = '';

        Pattern divisionPattern = Pattern.compile('ST(E|B)');
        Matcher divisionMatcher = divisionPattern.Matcher(csvCells[0]);
        divisionMatcher.find();

        divisionCell = divisionMatcher.group();

        fieldValuePairs.put('rstkf__gljd_gldiv__c', divisionCell);
        row = csvCells[1];


        // Parse Comment
        csvCells = row.split(',', 2);
        fieldValuePairs.put('rstkf__gljd_linecomment__c', csvCells[0]);


        return fieldValuePairs;
    }
*/

    
    @TestVisible
    private Id getAccountIdFromName(String accountName, String divisionName) {
        String likeAccount = '%' + accountName + '%';
        String likeDivision = '%' + divisionName + '%';

        rstkf__glacct__c[] accountMatch = [
            SELECT Id
            FROM rstkf__glacct__c
            WHERE Name LIKE :likeAccount AND rstkf__glacct_cmpno__r.Name LIKE :likeDivision
        ];

        Id accountId = accountMatch[0].Id;
        
        return accountId;
    }


    @TestVisible
    private Id getDivisionIdFromName(String divisionName) {
        String likeDivision = '%' + divisionName + '%';

        rstkf__gldiv__c[] divisionMatch = [
            SELECT Id
            FROM rstkf__gldiv__c
            WHERE Name LIKE :likeDivision
        ];

        Id divisionId = divisionMatch[0].Id;

        return divisionId;
    }


    public void loadCSV() {
        try {
            if(this.csvBody == null) {
                ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'You haven\'t chosen a file to load');
                ApexPages.addMessage(errorMessage);
            }else {
                csvString = csvBody.toString();
                
                csvRows = csvString.split('\n');

                Map<String, Object> rowMap;
                
                rstkf__gltxn__c[] matches;

                for(Integer i = 1; i < csvRows.size(); i++) {
                    //rowMap = parseRow(csvRows[i]);
                    rowMap = Parse_CSV.row_JEDetail(csvRows[i]);


                    this.loadedRecords.add(new rstkf__gljd__c());

                    this.loadedRecords[i - 1].rstkf__gljd_glacct__c = getAccountIdFromName(
                        String.valueOf( rowMap.get('rstkf__gljd_glacct__c') ), 
                        String.valueOf( rowMap.get('rstkf__gljd_gldiv__c') )
                    );

                    this.loadedRecords[i - 1].rstkf__gljd_dramt__c = Double.valueOf( String.valueOf( rowMap.get('rstkf__gljd_dramt__c') ) );

                    this.loadedRecords[i - 1].rstkf__gljd_cramt__c = Double.valueOf( String.valueOf( rowMap.get('rstkf__gljd_cramt__c') ) );

                    this.loadedRecords[i - 1].rstkf__gljd_gldiv__c = getDivisionIdFromName(
                        String.valueOf( rowMap.get('rstkf__gljd_gldiv__c') )
                    );

                    this.loadedRecords[i - 1].rstkf__gljd_linecomment__c = String.valueOf( rowMap.get('rstkf__gljd_linecomment__c') );
                }

            }
        }catch(Exception e) {
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(errorMessage);

            System.debug(e.getMessage());
        }
    }

    
    public void insertData() {
        try {
            if(this.loadedRecords.size() == 0) {
                ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'No data has been loaded');
                ApexPages.addMessage(errorMessage);
            }

            if(this.headerId == null) {
                ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'You haven\'t entered a valid header');
                ApexPages.addMessage(errorMessage);
            }else {
                for(Integer i = 0; i < this.loadedRecords.size(); i++) {
                    this.loadedRecords[i].rstkf__gljd_gljh__c = this.headerId;

                    this.loadedRecords[i].rstkf__gljd_lineno__c = this.startingLineNumber + i;
                }

                Database.SaveResult[] results = Database.insert(this.loadedRecords, true);

                Boolean isInserted = true;

                for(Database.SaveResult result : results) {
                    if(!result.isSuccess()) {
                        ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Something Went Wrong, CSV not Inserted');
                        ApexPages.addMessage(errorMessage);

                        isInserted = false;

                        break;
                    }
                }

                if(isInserted) {
                    ApexPages.Message goodMessage = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'CSV Uploaded');
                        ApexPages.addMessage(goodMessage);
                }

            }
        }catch(Exception e) {
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(errorMessage);

            System.debug(e.getMessage());
        }
    }
}