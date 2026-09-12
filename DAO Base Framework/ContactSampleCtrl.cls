public with sharing class ContactSampleCtrl {

	public static ContactDAO contactAccessor = new ContactDataAccessor();

	@AuraEnabled
	public static String getContact(String contactId){
		try {
			Contact contact = contactAccessor.getContactById(contactId);
			return JSON.serialize(contact);
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

	@AuraEnabled
	public static String getAllAccountContacts(String accountId){
		try {
			List<Contact> contacts = contactAccessor.getContactsByAccountId(accountId);
			return JSON.serialize(contacts);
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

	@AuraEnabled
	public static String updateContact(Contact contact){
		try {
			contactAccessor.updateRecords(new List<Contact>{contact});
			return JSON.serialize(contact);
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

}