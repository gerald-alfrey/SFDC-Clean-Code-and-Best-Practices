@isTest
private class AccountDataAccessorTest {

	private static final String BUSINESS_RECORD_TYPE = 'Business_Account';
	private static final String BUSINESS_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(BUSINESS_RECORD_TYPE).getRecordTypeId();

	private static Account createTestAccount(String recordTypeId, String name) {
		Account testAccount = new Account(
			RecordTypeId = recordTypeId, 
			Name = name
		);

		return testAccount;
	}

	private static Account buildAccount(String recordTypeId, String name) {
		MockSObjectBuilder mockBuilder = new MockSObjectBuilder(Account.sObjectType);
		mockBuilder.setField('Name', name);
		mockBuilder.setField('RecordTypeId', recordTypeId);
		Account testAccount = (Account) mockBuilder.build();

		return testAccount;
	}

	// -----------------------
    // TEST SETUP DATA
    // -----------------------
    @TestSetup
    static void setupTestData() {

        // Create Account
        List<Account> accounts = new List<Account> {
            new Account(Name = 'Test 1', RecordTypeId = BUSINESS_RECORD_TYPE_ID),
            new Account(Name = 'Test 2', RecordTypeId = BUSINESS_RECORD_TYPE_ID)
        };
        insert accounts;
    }

	@isTest 
	static void getAccountById_givenValidID_shouldReturnAccount() {
		AccountDataAccessor accountAccessor = new AccountDataAccessor();

		Account testAccount = createTestAccount(BUSINESS_RECORD_TYPE_ID, 'Test');
		accountAccessor.insertRecords(new List<Account>{testAccount});
		
		Boolean accountQueried = true;
		Account queriedAccount;

		Test.startTest();
			try {
				queriedAccount = accountAccessor.getAccountById(testAccount.Id);
			} catch(Exception ex) {
				accountQueried = false;
			}
		Test.stopTest();

		System.assertEquals(true, accountQueried);
		System.assertEquals(testAccount.Id, queriedAccount.Id);
	}

	@isTest 
	static void getAccountById_givenInvalidID_shouldThrowException() {
		AccountDataAccessor accountAccessor = new AccountDataAccessor();

		String testAccountId = MockIdGenerator.getMockId(Account.sObjectType);
		Boolean accountQueried = true;
		Account queriedAccount;

		Test.startTest();
			try {
				queriedAccount = accountAccessor.getAccountById(testAccountId);
			} catch(Exception ex) {
				accountQueried = false;
			}
		Test.stopTest();

		System.assertEquals(false, accountQueried);
	}

	@IsTest
    static void testGetAccountByIds() {
        AccountDataAccessor accessor = new AccountDataAccessor();
        // Get Account IDs
        Set<String> aIds = new Map<String, Account>([SELECT Id FROM Account]).keySet();
        Account[] accounts;

        Test.startTest();

        accounts = accessor.getAccountByIds(aIds);
        
        Test.stopTest();

        System.assertEquals(false, accounts?.isEmpty());
    }
    
    @IsTest
    static void testGetAccountsByRecordTypeDeveloperName() {
        AccountDataAccessor accessor = new AccountDataAccessor();
        Account[] accounts;

        Test.startTest();

        accounts = accessor.getAccountsByRecordTypeDeveloperName(BUSINESS_RECORD_TYPE);
        
        Test.stopTest();

        System.assertEquals(false, accounts?.isEmpty());
    }    
}