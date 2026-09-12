@isTest
private class ContactDataAccessorTest {

	private static final String BUSINESS_RECORD_TYPE = 'Business_Account';
	private static final String CUSTOMER_PORTAL_TYPE = 'RD_RDAE_Customer_Portal';
	private static final String BUSINESS_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(BUSINESS_RECORD_TYPE).getRecordTypeId();
	private static final String CUSTOMER_PORTAL_TYPE_ID = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get(CUSTOMER_PORTAL_TYPE).getRecordTypeId();

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

	private static Contact buildContact(String recordTypeId, String firstName, String lastName, String accountId) {
		MockSObjectBuilder mockBuilder = new MockSObjectBuilder(Contact.sObjectType);
		mockBuilder.setField('FirstName', firstName);
		mockBuilder.setField('LastName', lastName);
		mockBuilder.setField('AccountId', accountId);
		mockBuilder.setField('RecordTypeId', recordTypeId);
		Contact testContact = (Contact) mockBuilder.build();

		return testContact;
	}

	// @TestSetup
	// static void setupTestData() {
	// 	List<Account> accounts = new List<Account> {
	// 		new Account(Name = 'Test 1', RecordTypeId = BUSINESS_RECORD_TYPE_ID),
	// 		new Account(Name = 'Test 2', RecordTypeId = BUSINESS_RECORD_TYPE_ID)
	// 	};

	// 	insert accounts;

	// }

	@isTest 
	static void getContactById_givenValidID_shouldReturnContact() {
		AccountDAO accountAccessor = new AccountDataAccessor();
		ContactDAO contactAccessor = new ContactDataAccessor();

		Account testAccount = createTestAccount(BUSINESS_RECORD_TYPE_ID, 'Test');
		accountAccessor.insertRecords(new List<Account>{testAccount});

		Contact testContact = buildContact(CUSTOMER_PORTAL_TYPE_ID, 'firstName', 'lastName', testAccount.Id);
		contactAccessor.insertRecords(new List<Contact>{testContact});

		Boolean contactQueried = true;
		Contact queriedContact;

		Test.startTest();
			try {
				queriedContact = contactAccessor.getContactById(testContact.Id);
			} catch(Exception ex) {
				contactQueried = false;
			}
		Test.stopTest();

		System.assertEquals(true, contactQueried);
		System.assertEquals(testContact.Id, queriedContact.Id);
	}

	@isTest 
	static void getAccountById_givenInvalidID_shouldThrowException() {
		ContactDAO contactAccessor = new ContactDataAccessor();

		String testContactId = MockIdGenerator.getMockId(Contact.sObjectType);
		Boolean contactQueried = true;
		Contact queriedContact;

		Test.startTest();
			try {
				queriedContact = contactAccessor.getContactById(testContactId);
			} catch(Exception ex) {
				contactQueried = false;
			}
		Test.stopTest();

		System.assertEquals(false, contactQueried);
	}

	@isTest
	static void getContactsByAccountId_givenValidID_shouldReturnListOfContacts() {
		AccountDAO accountAccessor = new AccountDataAccessor();
		ContactDAO contactAccessor = new ContactDataAccessor();

		Account testAccount = createTestAccount(BUSINESS_RECORD_TYPE_ID, 'Test');
		accountAccessor.insertRecords(new List<Account>{testAccount});

		Contact testContact = buildContact(CUSTOMER_PORTAL_TYPE_ID, 'firstName', 'lastName', testAccount.Id);
		contactAccessor.insertRecords(new List<Contact>{testContact});

		Boolean contactQueried = true;
		List<Contact> queriedContacts = new List<Contact>();

		Test.startTest();
			try {
				queriedContacts = contactAccessor.getContactsByAccountId(testAccount.Id);
			} catch(Exception ex) {
				contactQueried = false;
			}
		Test.stopTest();

		System.assertEquals(true, contactQueried);
	}

}