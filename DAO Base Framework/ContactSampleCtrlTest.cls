@isTest
public with sharing class ContactSampleCtrlTest {

	private static final String BUSINESS_RECORD_TYPE = 'Business_Account';
	private static final String CUSTOMER_PORTAL_TYPE = 'RD_RDAE_Customer_Portal';
	private static final String BUSINESS_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(BUSINESS_RECORD_TYPE).getRecordTypeId();
	private static final String CUSTOMER_PORTAL_TYPE_ID = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get(CUSTOMER_PORTAL_TYPE).getRecordTypeId();

	private static Account buildAccount(String recordTypeId, String name, String recordId) {
		MockSObjectBuilder mockBuilder = new MockSObjectBuilder(Account.sObjectType);
		mockBuilder.setField('Name', name);
		mockBuilder.setField('RecordTypeId', recordTypeId);
		mockBuilder.setField('Id', recordId);
		Account testAccount = (Account) mockBuilder.build();

		return testAccount;
	}

	private static Contact buildContact(String recordTypeId, String firstName, String lastName, String createdDate, String accountId) {
		MockSObjectBuilder mockBuilder = new MockSObjectBuilder(Contact.sObjectType);
		mockBuilder.setField(Contact.FirstName, firstName);
		mockBuilder.setField('LastName', lastName);
		mockBuilder.setField('RecordTypeId', recordTypeId);
		mockBuilder.setField('CreatedDate', createdDate);
		mockBuilder.setField('AccountId', accountId);
		mockBuilder.setField('Id', mockBuilder.getMockId());
		
		Contact mockContact = (Contact) mockBuilder.build();

		return mockContact;
	}

	@isTest 
	static void getContact_givenValidId_shouldReturnContact() {
		String mockAccountId = MockIdGenerator.getMockId(Account.sObjectType);

		Contact mockContact = buildContact(CUSTOMER_PORTAL_TYPE_ID, 'testing', 'GetContact', '2025-01-01T12:00:00Z', mockAccountId);
		
		ContactDataAccessorMock mockContactAccessor = new ContactDataAccessorMock();
		mockContactAccessor.mockDatabaseContacts = new List<Contact>{mockContact};

		ContactSampleCtrl.contactAccessor = mockContactAccessor;

		Boolean contactReturned = true;

		Test.startTest();
			try {
				String testReturnedContact = ContactSampleCtrl.getContact(mockContact.Id);
				System.debug(testReturnedContact);
			} catch(Exception ex) {
				contactReturned = false;
			}
		Test.stopTest();

		Assert.isTrue(contactReturned);
	}

	@isTest 
	static void getContact_givenInvalidId_shouldThrowError() {
		String mockAccountId = MockIdGenerator.getMockId(Account.sObjectType);
		String mockContactId = MockIdGenerator.getMockId(Contact.sObjectType);
		System.debug('getContact_givenInvalidId_shouldThrowError: ' + mockContactId);

		Contact mockContact = buildContact(CUSTOMER_PORTAL_TYPE_ID, 'testing', 'GetContact', '2025-01-01T12:00:00Z', mockAccountId);
		System.debug('getContact_givenInvalidId_shouldThrowError: ' + mockContact);
		
		ContactDataAccessorMock mockContactAccessor = new ContactDataAccessorMock();
		mockContactAccessor.mockDatabaseContacts = new List<Contact>{mockContact};

		ContactSampleCtrl.contactAccessor = mockContactAccessor;

		Boolean contactReturned = true;

		Test.startTest();
			try {
				String testReturnedContact = ContactSampleCtrl.getContact(mockContactId);
			} catch(Exception ex) {
				contactReturned = false;
			}
		Test.stopTest();

		Assert.isFalse(contactReturned);
	}

	@isTest 
	static void updateContact_givenValidContactWithExistingId_success() {
		String mockAccountId = MockIdGenerator.getMockId(Account.sObjectType);

		Contact mockContact = buildContact(CUSTOMER_PORTAL_TYPE_ID, 'testing', 'GetContact', '2025-01-01T12:00:00Z', mockAccountId);
		
		ContactDataAccessorMock mockContactAccessor = new ContactDataAccessorMock();
		mockContactAccessor.mockDatabaseContacts = new List<Contact>{mockContact};

		ContactSampleCtrl.contactAccessor = mockContactAccessor;

		Boolean dmlSuccess = true;

		Test.startTest();
			try {
				mockContact.Email = 'testing@updateContact_givenValidContactWithExistingId_success.com';
				String testReturnedContact = ContactSampleCtrl.updateContact(mockContact);
			} catch(Exception ex) {
				dmlSuccess = false;
			}
		Test.stopTest();

		Assert.isTrue(dmlSuccess);
	}

	@isTest 
	static void updateContact_givenValidContactWithoutId_Exception() {
		String mockAccountId = MockIdGenerator.getMockId(Account.sObjectType);

		Contact mockContact = buildContact(CUSTOMER_PORTAL_TYPE_ID, 'testing', 'GetContact', '2025-01-01T12:00:00Z', mockAccountId);
		mockContact.Id = null;
		
		ContactDataAccessorMock mockContactAccessor = new ContactDataAccessorMock();
		mockContactAccessor.mockDatabaseContacts = new List<Contact>{mockContact};

		ContactSampleCtrl.contactAccessor = mockContactAccessor;

		Boolean dmlSuccess = true;

		Test.startTest();
			try {
				mockContact.Email = 'testing@updateContact_givenValidContactWithExistingId_success.com';
				String testReturnedContact = ContactSampleCtrl.updateContact(mockContact);
			} catch(Exception ex) {
				dmlSuccess = false;
			}
		Test.stopTest();

		Assert.isFalse(dmlSuccess);
	}

	@isTest 
	static void getAllAccountContacts_givenValidId_shouldReturnContacts() {
		String mockAccountId = MockIdGenerator.getMockId(Account.sObjectType);

		List<Contact> mockContacts = new List<Contact>();
		mockContacts.add(buildContact(CUSTOMER_PORTAL_TYPE_ID, 'testing', 'getAllAccountContacts1', '2025-01-01T12:00:00Z', mockAccountId));
		mockContacts.add(buildContact(CUSTOMER_PORTAL_TYPE_ID, 'testing', 'getAllAccountContacts2', '2025-01-01T12:00:00Z', mockAccountId));
		
		ContactDataAccessorMock mockContactAccessor = new ContactDataAccessorMock();
		mockContactAccessor.mockDatabaseContacts = new List<Contact>(mockContacts);

		ContactSampleCtrl.contactAccessor = mockContactAccessor;

		Boolean contactsReturned = true;

		Test.startTest();
			try {
				String testReturnedContacts = ContactSampleCtrl.getAllAccountContacts(mockAccountId);
				System.debug(testReturnedContacts);
			} catch(Exception ex) {
				contactsReturned = false;
			}
		Test.stopTest();

		Assert.isTrue(contactsReturned);
	}

	@isTest
	static void testGetContact_Success() {
		// --- 1. DATA PREPARATION 
		String mockAccountId = MockIdGenerator.getMockId(Account.sObjectType);
		Contact mockContact = buildContact(CUSTOMER_PORTAL_TYPE_ID, 'testing', 'GetContact', '2025-01-01T12:00:00Z', mockAccountId);

		// --- 2. MOCK CONFIGURATION (The Stub API) ---
		// Instantiate the provider
		UniversalMockProvider provider = new UniversalMockProvider();

		// Tell it: "When 'getContactById' is called, return the mockContact"
		provider.mockReturn('getContactById', mockContact);

		// Generate the Stub
		// This dynamically creates an object that looks like ContactDAO but uses our logic
		ContactDAO mockDao = (ContactDAO) Test.createStub(ContactDAO.class, provider);

		// --- 3. INJECTION ---
		// Swap the real DAO in the controller with our Mock
		ContactSampleCtrl.contactAccessor = mockDao;

		// --- 4. EXECUTION ---
		Test.startTest();
		String resultJson = ContactSampleCtrl.getContact(mockContact.Id);
		Test.stopTest();

		// --- 5. ASSERTION ---
		Contact resultContact = (Contact) JSON.deserialize(resultJson, Contact.class);
		
		Assert.areEqual('GetContact', resultContact.LastName);
		// This proves your MockSObjectBuilder worked for read-only fields
		Assert.areEqual(
			Datetime.newInstanceGmt(2025, 1, 1, 12, 0, 0),
			resultContact.CreatedDate
		);
	}

	@isTest
	static void testUpdateContact_Success() {
		// --- 1. DATA PREPARATION 
		String mockAccountId = MockIdGenerator.getMockId(Account.sObjectType);
		Contact mockContact = buildContact(CUSTOMER_PORTAL_TYPE_ID, 'testing', 'GetContact', '2025-01-01T12:00:00Z', mockAccountId);
		mockContact.Email = 'getContact@test.testUpdateContact_Success.com';

		// --- 2. MOCK CONFIGURATION (The Stub API) ---
		// Instantiate the provider
		UniversalMockProvider provider = new UniversalMockProvider();

		// Tell it: "When 'updateRecords' is called, return the mockContact"
		provider.mockReturn('updateRecords', mockContact);

		// Generate the Stub
		// This dynamically creates an object that looks like ContactDAO but uses our logic
		ContactDAO mockDao = (ContactDAO) Test.createStub(ContactDAO.class, provider);

		// --- 3. INJECTION ---
		// Swap the real DAO in the controller with our Mock
		ContactSampleCtrl.contactAccessor = mockDao;

		// --- 4. EXECUTION ---
		Test.startTest();
		String resultJson = ContactSampleCtrl.updateContact(mockContact);
		Test.stopTest();

		// --- 5. ASSERTION ---
		Contact resultContact = (Contact) JSON.deserialize(resultJson, Contact.class);
		
		Assert.areEqual('getContact@test.testUpdateContact_Success.com', resultContact.Email);
	}
}