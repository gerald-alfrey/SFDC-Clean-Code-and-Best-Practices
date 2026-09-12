public interface ContactDAO extends DmlInterface {
	Contact getContactById(String contactId);
	List<Contact> getContactsByAccountId(String accountId);
}