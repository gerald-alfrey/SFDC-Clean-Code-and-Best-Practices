@isTest
public with sharing class AccountSampleCtrlTest {

	private static final String BUSINESS_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_Account').getRecordTypeId();

	private static Account buildAccount(String recordTypeId, String name, String recordId) {
		MockSObjectBuilder mockBuilder = new MockSObjectBuilder(Account.sObjectType);
		mockBuilder.setField('Name', name);
		mockBuilder.setField('RecordTypeId', recordTypeId);
		mockBuilder.setField('Id', recordId);
		Account testAccount = (Account) mockBuilder.build();

		return testAccount;
	}

	@isTest 
	static void getAccount_givenValidId_shouldReturnAccount() {
		AccountDataAccessor accountAccessor = new AccountDataAccessor();
		String testAccountId = MockIdGenerator.getMockId(Account.sObjectType);

		Account testAccount = buildAccount(BUSINESS_RECORD_TYPE_ID, 'Test', testAccountId);
		
		AccountDataAccessorMock mockAccountAccessor = new AccountDataAccessorMock();
		mockAccountAccessor.mockDatabaseAccounts = new List<Account>{testAccount};

		AccountSampleCtrl.accountAccessor = mockAccountAccessor;

		Boolean accountReturned = true;

		Test.startTest();
			try {
				String testReturnedAccount = AccountSampleCtrl.getAccount(testAccountId);
			} catch(Exception ex) {
				accountReturned = false;
			}
		Test.stopTest();

		Assert.isTrue(accountReturned);
	}

	@isTest 
	static void getAccount_givenInvalidId_shouldthrowError() {
		AccountDataAccessor accountAccessor = new AccountDataAccessor();
		String testAccountId = MockIdGenerator.getMockId(Account.sObjectType);
		String invalidAccountId = MockIdGenerator.getMockId(Account.sObjectType);

		Account testAccount = buildAccount(BUSINESS_RECORD_TYPE_ID, 'Test', testAccountId);
		
		AccountDataAccessorMock mockAccountAccessor = new AccountDataAccessorMock();
		mockAccountAccessor.mockDatabaseAccounts = new List<Account>{testAccount};

		AccountSampleCtrl.accountAccessor = mockAccountAccessor;

		Boolean accountReturned = true;

		Test.startTest();
			try {
				String testReturnedAccount = AccountSampleCtrl.getAccount(invalidAccountId);
			} catch(Exception ex) {
				accountReturned = false;
			}
		Test.stopTest();

		Assert.isFalse(accountReturned);
	}

	@isTest
	static void testGetAccount_Success() {
		// --- 1. DATA PREPARATION 
		MockSObjectBuilder mockBuilder = new MockSObjectBuilder(Account.sObjectType);
		mockBuilder.setField(Account.Name, 'Test Tech Corp')
			.setField('CreatedDate', '2025-01-01T12:00:00Z')
			.getMockId();
		
		Account mockAccount = (Account) mockBuilder.build();

		// --- 2. MOCK CONFIGURATION (The Stub API) ---
		// Instantiate the provider
		UniversalMockProvider provider = new UniversalMockProvider();

		// Tell it: "When 'getAccountById' is called, return the mockAccount"
		provider.mockReturn('getAccountById', mockAccount);

		// Generate the Stub (The Magic Step)
		// This dynamically creates an object that looks like AccountDAO but uses our logic
		AccountDAO mockDao = (AccountDAO) Test.createStub(AccountDAO.class, provider);

		// --- 3. INJECTION ---
		// Swap the real DAO in the controller with our Mock
		AccountSampleCtrl.accountAccessor = mockDao;

		// --- 4. EXECUTION ---
		Test.startTest();
		String resultJson = AccountSampleCtrl.getAccount(mockAccount.Id);
		System.debug('testGetAccount_Success: ' + resultJson);
		Test.stopTest();

		// --- 5. ASSERTION ---
		Account resultAcc = (Account) JSON.deserialize(resultJson, Account.class);
		
		Assert.areEqual('Test Tech Corp', resultAcc.Name);
		// This proves your MockSObjectBuilder worked for read-only fields
		Assert.areEqual(
			Datetime.newInstanceGmt(2025, 1, 1, 12, 0, 0),
			resultAcc.CreatedDate
		);
	}

	@isTest 
	static void getAccount2_givenValidId_shouldReturnAccount() {
		AccountDataAccessor accountAccessor = new AccountDataAccessor();
		String testAccountId = MockIdGenerator.getMockId(Account.sObjectType);

		Account testAccount = buildAccount(BUSINESS_RECORD_TYPE_ID, 'Test', testAccountId);
		
		AccountDataAccessorMock mockAccountAccessor = new AccountDataAccessorMock();
		mockAccountAccessor.mockDatabaseAccounts = new List<Account>{testAccount};

		AccountSampleCtrl.accountAccessor = mockAccountAccessor;
		AccountSampleCtrl sample = new AccountSampleCtrl();
		Boolean accountReturned = true;

		Test.startTest();
			try {
				String testReturnedAccount = sample.getAccount2(testAccountId);
			} catch(Exception ex) {
				accountReturned = false;
			}
		Test.stopTest();

		Assert.isTrue(accountReturned);
	}

}