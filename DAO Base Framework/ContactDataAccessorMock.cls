public with sharing class ContactDataAccessorMock extends DmlBaseMock implements ContactDAO {
	public List<Contact> mockDatabaseContacts;

	public ContactDataAccessorMock() {
		super(new List<Contact>());
		this.mockDatabaseContacts = (List<Contact>)super.records;
	}

	public Contact getContactById(String contactId) {
		Contact contactToReturn;
		
		for (Contact c : mockDatabaseContacts) { 
			if (c.Id == contactId) {
				contactToReturn = c;
			}
		}

		if (contactToReturn != null) {
			return contactToReturn;
		} else {
			throw new QueryException('List has no rows for assignment');
		}
	}

	public List<Contact> getContactsByAccountId(String accountId) {
		List <Contact> contactsToReturn = new List<Contact>();

		for (Contact c : mockDatabaseContacts) {
			if (c.AccountId == accountId) {
				contactsToReturn.add(c);
			}
		}

		return contactsToReturn;
	}

}