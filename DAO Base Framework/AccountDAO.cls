public interface AccountDAO extends DmlInterface {

	Account getAccountById(String recordId);

	List<Account> getAccountByIds(Set<String> ids);
    
    List<Account> getAccountsByRecordTypeDeveloperName(String recordTypeDeveloperName);
}