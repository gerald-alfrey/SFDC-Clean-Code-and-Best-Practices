public inherited sharing class ContactDataAccessor extends DmlBase implements ContactDAO {

	public Contact getContactById(String contactId) {
		return [
			SELECT Id
				, FirstName
				, LastName
				, AccountId
				, CreatedDate
			FROM Contact
			WHERE Id = :contactId
		];
	}

	public List<Contact> getContactsByAccountId(String accountId) {
		return [
			SELECT Id
				, FirstName
				, LastName
				, AccountId
				, CreatedDate
			FROM Contact
			WHERE AccountId = :accountId
		];
	}

}