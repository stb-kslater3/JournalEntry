public class JournalEntryManager_Controller {
    //public Blob csvBody {get;set;}
    public String csvBody {get;set;}
	public String csvString {get;set;}

    public String errorMessage {get;set;}

    @TestVisible
    private String[] csvRows;

    public String headerName {get;set;}
    public String headerResultText {get;set;}

    @TestVisible
    private Id headerId;

    @TestVisible
    private Decimal startingLineNumber;

    public List<rstkf__gljd__c> loadedRecords {get;set;}

    public List<rstkf__gljd__c> preReconciledRecords {get;set;}
/*
    public List<rstkf__gljd__c> postReconciledRecords {get;set;}
    public List< Map<String, String> > postUnreconciledRecords {get;set;}

    @TestVisible
    private AggregateResult[] groupedDebits;

    @TestVisible
    private AggregateResult[] groupedCredits;
*/
    public Boolean selectedPreReconciled {get;set;}
    

    public JournalEntryManager_Controller() {
        this.csvRows = new String[]{};

        this.headerResultText = 'Enter a header';

        this.loadedRecords = new List<rstkf__gljd__c>();

        this.preReconciledRecords = new List<rstkf__gljd__c>();
/*
        this.postReconciledRecords = new List<rstkf__gljd__c>();
        this.postUnreconciledRecords = new List< Map<String, String> >();
*/
        this.startingLineNumber = 1;

        //this.selectedPreReconciled = false;
this.selectedPreReconciled = true;
    }


    public void displayErrorToast() {
        ApexPages.Message message = new ApexPages.Message(ApexPages.Severity.ERROR, this.errorMessage);
        ApexPages.addMessage(message);
    }

    public void clearToast() {
        ApexPages.getMessages().clear();
    }
    
    // Stub that holds for when I set selectedPreReconciled with actionFunction
    public void setPreReconciled() {}


    public void findHeaderId() {
        try {
            this.clearToast();

            String headerNameIdentifier = '';
System.debug(this.headerName);
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
                this.headerResultText = 'The header name entered doesn\'t appear to have the number of the format #xxxx within it. Please re enter with the name with number included. Use the full name if you can';
            }
        }catch(Exception e) {
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(errorMessage);

            System.debug(e.getMessage());
        }
    }

    
    @TestVisible
    private Id getAccountIdFromName(String accountName, String divisionName) {
        String likeAccount = '%' + accountName + '%';
        String likeDivision = '%' + divisionName + '%';

        
        rstkf__glacct__c[] accountMatch = [
            SELECT Id
            FROM rstkf__glacct__c
            WHERE Name LIKE :likeAccount AND rstkf__glacct_cmpno__r.Name LIKE :likeDivision
            LIMIT 1
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
            LIMIT 1
        ];

        Id divisionId = divisionMatch[0].Id;

        return divisionId;
    }


/*
    @TestVisible
    private Boolean searchDebitExists(Decimal debit) {
        Integer minIndex = 0;
        Integer maxIndex = this.groupedDebits.size() - 1;
        Integer middleIndex;

        Decimal valueMin, valueMiddle, valueMax;
        
        if(this.groupedDebits.size() > 3) {
            while(minIndex != (maxIndex - 1) && minIndex != maxIndex) {
                middleIndex = (maxIndex + minIndex) / 2;

                valueMiddle = (Decimal) this.groupedDebits[middleIndex].get('expr0');

                if(valueMiddle < debit) {
                    minIndex = middleIndex + 1;
                }else if(valueMiddle > debit) {
                    maxIndex = middleIndex - 1;
                }else if( Math.abs(valueMiddle - debit) < 0.001 ) {
                    return true;
                }

                valueMin = (Decimal) this.groupedDebits[minIndex].get('expr0');
                valueMax = (Decimal) this.groupedDebits[maxIndex].get('expr0');

                if(minIndex == maxIndex) {
                    if( Math.abs(valueMin - debit) < 0.001) {
                        return true;
                    }else {
                        return false;
                    }
                }else if(minIndex == maxIndex - 1) {
                    if( Math.abs(valueMin - debit) < 0.001) {
                        return true;
                    }else if( Math.abs(valueMax - debit) < 0.001) {
                        return true;
                    }else {
                        return false;
                    }
                }
            }
        }else {
            Decimal value;
            for(AggregateResult result : this.groupedDebits) {
                value = (Decimal) result.get('expr0');

                if( Math.abs(value - debit) < 0.001 ) {
                    return true;
                }
            }

            return false;
        }


        return true;
    }


    @TestVisible
    private Boolean searchCreditExists(Decimal credit) {
        Integer minIndex = 0;
        Integer maxIndex = this.groupedCredits.size() - 1;
        Integer middleIndex;

        Decimal valueMin, valueMiddle, valueMax;
        
        if(this.groupedCredits.size() > 3) {
            while(minIndex != (maxIndex - 1) && minIndex != maxIndex) {
                middleIndex = (maxIndex + minIndex) / 2;

                valueMiddle = (Decimal) this.groupedCredits[middleIndex].get('expr0');

                if(valueMiddle < credit) {
                    minIndex = middleIndex + 1;
                }else if(valueMiddle > credit) {
                    maxIndex = middleIndex - 1;
                }else if( Math.abs(valueMiddle - credit) < 0.001 ) {
                    return true;
                }

                valueMin = (Decimal) this.groupedCredits[minIndex].get('expr0');
                valueMax = (Decimal) this.groupedCredits[maxIndex].get('expr0');

                if(minIndex == maxIndex) {
                    if( Math.abs(valueMin - credit) < 0.001 ) {
                        return true;
                    }else {
                        return false;
                    }
                }else if(minIndex == maxIndex - 1) {
                    if( Math.abs(valueMin - credit) < 0.001 ) {
                        return true;
                    }else if( Math.abs(valueMax - credit) < 0.001 ) {
                        return true;
                    }else {
                        return false;
                    }
                }
            }
        }else {
            Decimal value;
            for(AggregateResult result : this.groupedCredits) {
                value = (Decimal) result.get('expr0');

                if( Math.abs(value - credit) < 0.001 ) {
                    return true;
                }
            }

            return false;
        }

        // If all else fails don't reconcile it
        return true;
    }



    @TestVisible
    private AggregateResult[] queryGroupedDebits(Integer loadedRecordIndex) {
        List<AggregateResult> debits = new List<AggregateResult>();


        // Count how many records their are in GL Transaction (rstkf__gltxn__c) so that I can divide by 2000 and find out how many times to
        // run the query
        Integer recordCount = [
            SELECT Count() FROM rstkf__gltxn__c
            WHERE rstkf__gltxn_glacct__c=:this.loadedRecords[loadedRecordIndex - 1].rstkf__gljd_glacct__c
            AND rstkf__gltxn_gldiv__c=:this.loadedRecords[loadedRecordIndex - 1].rstkf__gljd_gldiv__c
            AND rstkf__gltxn_dramt__c>0
        ];

        // How many times will I grab 2000 before grabbing all of them. So divide by 2000 and if there is a remainder then I need to
        // make 1 more additional query to grab the last bit
        Integer numberOfAggregations = recordCount/2000 + (math.mod(recordCount, 2000)!=0?1:0);

        // Keep track of the Id's that I have queried thus far so that I can remove those from what are returned
        // with each call. i.e. don't query the same 2000 over and over again, but actually be able to get all records 2000 at a time
        Set<Id> idsAlreadyQueried = new Set<Id>();


        for(Integer i = 0; i < numberOfAggregations; i++) {
            debits.addAll([
                SELECT Id, rstkf__gltxn_tranno__c, SUM(rstkf__gltxn_dramt__c)
                FROM rstkf__gltxn__c
                WHERE rstkf__gltxn_glacct__c=:this.loadedRecords[loadedRecordIndex - 1].rstkf__gljd_glacct__c
                AND rstkf__gltxn_gldiv__c=:this.loadedRecords[loadedRecordIndex - 1].rstkf__gljd_gldiv__c
                AND rstkf__gltxn_dramt__c>0
                AND Id not in :idsAlreadyQueried
                GROUP BY Id, rstkf__gltxn_tranno__c
                ORDER BY SUM(rstkf__gltxn_dramt__c)
                LIMIT 2000
            ]);
        }


        return debits;
    }

    @TestVisible
    private AggregateResult[] queryGroupedCredits(Integer loadedRecordIndex) {
        List<AggregateResult> credits = new List<AggregateResult>();


        // Count how many records their are in GL Transaction (rstkf__gltxn__c) so that I can divide by 2000 and find out how many times to
        // run the query
        Integer recordCount = [
            SELECT Count() FROM rstkf__gltxn__c
            WHERE rstkf__gltxn_glacct__c=:this.loadedRecords[loadedRecordIndex - 1].rstkf__gljd_glacct__c
            AND rstkf__gltxn_gldiv__c=:this.loadedRecords[loadedRecordIndex - 1].rstkf__gljd_gldiv__c
            AND rstkf__gltxn_cramt__c>0
        ];

        // How many times will I grab 2000 before grabbing all of them. So divide by 2000 and if there is a remainder then I need to
        // make 1 more additional query to grab the last bit
        Integer numberOfAggregations = recordCount/2000 + (math.mod(recordCount, 2000)!=0?1:0);

        // Keep track of the Id's that I have queried thus far so that I can remove those from what are returned
        // with each call. i.e. don't query the same 2000 over and over again, but actually be able to get all records 2000 at a time
        Set<Id> idsAlreadyQueried = new Set<Id>();


        for(Integer i = 0; i < numberOfAggregations; i++) {
            credits.addAll([
                SELECT rstkf__gltxn_tranno__c, SUM(rstkf__gltxn_cramt__c)
                FROM rstkf__gltxn__c
                WHERE rstkf__gltxn_glacct__c=:this.loadedRecords[loadedRecordIndex - 1].rstkf__gljd_glacct__c
                AND rstkf__gltxn_gldiv__c=:this.loadedRecords[loadedRecordIndex - 1].rstkf__gljd_gldiv__c
                AND rstkf__gltxn_cramt__c>0
                AND Id NOT IN :idsAlreadyQueried
                GROUP BY Id, rstkf__gltxn_tranno__c
                ORDER BY SUM(rstkf__gltxn_cramt__c)
                LIMIT 2000
            ]);
        }


        return credits;
    }
*/


    public void loadCSV() {
        try {
            this.clearToast();

            if(this.csvBody == null) {
                ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'You haven\'t chosen a file to load');
                ApexPages.addMessage(errorMessage);
            }else {
                //csvString = csvBody.toString();
                csvString = csvBody;
                
                csvRows = csvString.split('\n');

                Map<String, Object> rowMap;
                
                Id divId;
                rowMap = JournalEntryParser.row_JEDetail(csvRows[1]);
                divId = getDivisionIdFromName( String.valueOf( rowMap.get('rstkf__gljd_gldiv__c') ) );

                Id id1133;
                rowMap = JournalEntryParser.row_JEDetail(csvRows[1]);
                id1133 = getAccountIdFromName(
                    '1133', 
                    String.valueOf( rowMap.get('rstkf__gljd_gldiv__c') )
                );// 1133 account and 'STB or STE' division
                

                for(Integer i = 1; i < csvRows.size(); i++) {
                    rowMap = JournalEntryParser.row_JEDetail(csvRows[i]);

                // CSV Data
                    // Records from csv
                    this.loadedRecords.add(new rstkf__gljd__c());

                    this.loadedRecords[i - 1].rstkf__gljd_glacct__c = getAccountIdFromName(
                        String.valueOf( rowMap.get('rstkf__gljd_glacct__c') ), 
                        String.valueOf( rowMap.get('rstkf__gljd_gldiv__c') )
                    );

                    this.loadedRecords[i - 1].rstkf__gljd_dramt__c = Double.valueOf( String.valueOf( rowMap.get('rstkf__gljd_dramt__c') ) );

                    this.loadedRecords[i - 1].rstkf__gljd_cramt__c = Double.valueOf( String.valueOf( rowMap.get('rstkf__gljd_cramt__c') ) );

                    this.loadedRecords[i - 1].rstkf__gljd_gldiv__c = divId;

                    this.loadedRecords[i - 1].rstkf__gljd_linecomment__c = String.valueOf( rowMap.get('rstkf__gljd_linecomment__c') );

                

                // Pre Reconciled Data
                    // If preReconciled, then record from csv
                    this.preReconciledRecords.add(new rstkf__gljd__c());

                    this.preReconciledRecords[2*(i-1)].rstkf__gljd_glacct__c = this.loadedRecords[i - 1].rstkf__gljd_glacct__c;

                    this.preReconciledRecords[2*(i-1)].rstkf__gljd_dramt__c = this.loadedRecords[i - 1].rstkf__gljd_dramt__c;

                    this.preReconciledRecords[2*(i-1)].rstkf__gljd_cramt__c = this.loadedRecords[i - 1].rstkf__gljd_cramt__c;

                    this.preReconciledRecords[2*(i-1)].rstkf__gljd_gldiv__c = this.loadedRecords[i - 1].rstkf__gljd_gldiv__c;

                    this.preReconciledRecords[2*(i-1)].rstkf__gljd_linecomment__c = this.loadedRecords[i - 1].rstkf__gljd_linecomment__c;

            
                    // If preReconciled then this is the offset to 1133
                    this.preReconciledRecords.add(new rstkf__gljd__c());

                    this.preReconciledRecords[2*(i-1)+1].rstkf__gljd_glacct__c = id1133;

                    this.preReconciledRecords[2*(i-1)+1].rstkf__gljd_dramt__c = this.preReconciledRecords[2*(i-1)].rstkf__gljd_cramt__c;

                    this.preReconciledRecords[2*(i-1)+1].rstkf__gljd_cramt__c = this.preReconciledRecords[2*(i-1)].rstkf__gljd_dramt__c;

                    this.preReconciledRecords[2*(i-1)+1].rstkf__gljd_gldiv__c = this.preReconciledRecords[2*(i-1)].rstkf__gljd_gldiv__c;

                    this.preReconciledRecords[2*(i-1)+1].rstkf__gljd_linecomment__c = this.preReconciledRecords[2*(i-1)].rstkf__gljd_linecomment__c + 'OFFSET';
                }

/*
                rstkf__gltxn__c[] matches;

                Boolean isFound;

                List<rstkf__gljd__c> needMatchCheck = new List<rstkf__gljd__c>();
                List<Integer> parallelNeedMatch = new List<Integer>();


            // Post Reconciled/Unreconciled Data
                // Make a pass for grouped debits/credits
                for(Integer i = 1; i < csvRows.size(); i++) {
                    rowMap = JournalEntryParser.row_JEDetail(csvRows[i]);

                    isFound = false;

                    if(this.loadedRecords[i - 1].rstkf__gljd_dramt__c > 0) {


                        this.groupedDebits = this.queryGroupedDebits(i);

                        if(this.groupedDebits.size() > 0) {					
                            isFound = this.searchDebitExists(this.loadedRecords[i - 1].rstkf__gljd_dramt__c);
                        }
                    }else {
                        this.groupedCredits = this.queryGroupedCredits(i);

                        if(this.groupedCredits.size() > 0) {   
                            isFound = this.searchCreditExists(this.loadedRecords[i - 1].rstkf__gljd_cramt__c);
                        }
                    }
                    
                    if( isFound ) {
                        if(this.loadedRecords[i - 1].rstkf__gljd_dramt__c > 0.00) {
                            this.postUnreconciledRecords.add(
                                new Map<String, String> {
                                    'rstkf__gljd_glacct__c'=>String.valueOf( rowMap.get('rstkf__gljd_glacct__c') ),
                                    'amount'=>'(' + String.valueOf( rowMap.get('rstkf__gljd_dramt__c') ) + ')',
                                    'rstkf__gljd_gldiv__c'=>String.valueOf( rowMap.get('rstkf__gljd_gldiv__c') ),
                                    'rstkf__gljd_linecomment__c'=>String.valueOf( rowMap.get('rstkf__gljd_linecomment__c') )
                                }
                            );
                        }else {
                            this.postUnreconciledRecords.add(
                                new Map<String, String> {
                                    'rstkf__gljd_glacct__c'=>String.valueOf( rowMap.get('rstkf__gljd_glacct__c') ),
                                    'amount'=>String.valueOf( rowMap.get('rstkf__gljd_cramt__c') ),
                                    'rstkf__gljd_gldiv__c'=>String.valueOf( rowMap.get('rstkf__gljd_gldiv__c') ),
                                    'rstkf__gljd_linecomment__c'=>String.valueOf( rowMap.get('rstkf__gljd_linecomment__c') )
                                }
                            );
                        }
                    }else {
                        needMatchCheck.add(this.loadedRecords[i - 1]);
                        parallelNeedMatch.add(i - 1);
                    }  
                }

                // Make a pass for direct matches of debits/credits
                for(Integer i = 0; i < needMatchCheck.size(); i++) {
                    matches = [
                        SELECT Id
                        FROM rstkf__gltxn__c
                        WHERE rstkf__gltxn_glacct__c=:needMatchCheck[i].rstkf__gljd_glacct__c AND rstkf__gltxn_dramt__c=:needMatchCheck[i].rstkf__gljd_dramt__c AND rstkf__gltxn_cramt__c=:needMatchCheck[i].rstkf__gljd_cramt__c AND rstkf__gltxn_gldiv__c=:needMatchCheck[i].rstkf__gljd_gldiv__c
                    ];

                    if(matches.size() > 0) {
                        rowMap = JournalEntryParser.row_JEDetail(csvRows[parallelNeedMatch[i]]);

                        if(needMatchCheck[i].rstkf__gljd_dramt__c > 0.00) {
                            this.postUnreconciledRecords.add(
                                new Map<String, String> {
                                    'rstkf__gljd_glacct__c'=>String.valueOf( rowMap.get('rstkf__gljd_glacct__c') ),
                                    'amount'=>'(' + String.valueOf( rowMap.get('rstkf__gljd_dramt__c') ) + ')',
                                    'rstkf__gljd_gldiv__c'=>String.valueOf( rowMap.get('rstkf__gljd_gldiv__c') ),
                                    'rstkf__gljd_linecomment__c'=>String.valueOf( rowMap.get('rstkf__gljd_linecomment__c') )
                                }
                            );
                        }else {
                            this.postUnreconciledRecords.add(
                                new Map<String, String> {
                                    'rstkf__gljd_glacct__c'=>String.valueOf( rowMap.get('rstkf__gljd_glacct__c') ),
                                    'amount'=>String.valueOf( rowMap.get('rstkf__gljd_cramt__c') ),
                                    'rstkf__gljd_gldiv__c'=>String.valueOf( rowMap.get('rstkf__gljd_gldiv__c') ),
                                    'rstkf__gljd_linecomment__c'=>String.valueOf( rowMap.get('rstkf__gljd_linecomment__c') )
                                }
                            );
                        }
                    }else {
                        this.postReconciledRecords.add(needMatchCheck[i]);

                        // If preReconciled then this is the offset to 1133
                        this.postReconciledRecords.add(new rstkf__gljd__c());

                        this.postReconciledRecords[this.postReconciledRecords.size() - 1].rstkf__gljd_glacct__c = id1133;

                        this.postReconciledRecords[this.postReconciledRecords.size() - 1].rstkf__gljd_dramt__c = needMatchCheck[i].rstkf__gljd_cramt__c;

                        this.postReconciledRecords[this.postReconciledRecords.size() - 1].rstkf__gljd_cramt__c = needMatchCheck[i].rstkf__gljd_dramt__c;

                        this.postReconciledRecords[this.postReconciledRecords.size() - 1].rstkf__gljd_gldiv__c = needMatchCheck[i].rstkf__gljd_gldiv__c;

                        this.postReconciledRecords[this.postReconciledRecords.size() - 1].rstkf__gljd_linecomment__c = needMatchCheck[i].rstkf__gljd_linecomment__c + 'OFFSET';
                    }
                }
*/
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
            }else if(this.headerId == null) {
                ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'You haven\'t entered a valid header');
                ApexPages.addMessage(errorMessage);
            }else {
                Database.SaveResult[]  results;

                if(this.selectedPreReconciled) {
                    for(Integer i = 0; i < this.preReconciledRecords.size(); i++) {
                        this.preReconciledRecords[i].rstkf__gljd_gljh__c = this.headerId;

                        this.preReconciledRecords[i].rstkf__gljd_lineno__c = this.startingLineNumber + i;
                    }

                    results = Database.insert(this.preReconciledRecords, true);
                }else {
/*
                    for(Integer i = 0; i < this.postReconciledRecords.size(); i++) {
                        this.postReconciledRecords[i].rstkf__gljd_gljh__c = this.headerId;

                        this.postReconciledRecords[i].rstkf__gljd_lineno__c = this.startingLineNumber + i;
                    }

                    results = Database.insert(this.postReconciledRecords, true);
*/
                }

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

/*
    public PageReference downloadUnreconciled() {
        if(this.postUnreconciledRecords.size() > 0) {
            return Page.JournalEntryUnreconciledDownloader.setRedirect(false);
        }else {
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'No Unreconciled Records to Download, so no need to click the download button');
            ApexPages.addMessage(errorMessage);

            return null;
        }
    }
*/
}