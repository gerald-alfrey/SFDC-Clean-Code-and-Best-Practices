public inherited sharing class AccountDataAccessor extends DmlBase implements AccountDAO {

	public Account getAccountById(String recordId) {
		return [
			SELECT Id
				, Name
				, Type
				, RecordTypeId
				, RecordType.Name
			FROM Account
			WHERE Id = :recordId
		];
	}

	public List<Account> getAccountByIds(Set<String> ids) {
        return [
			SELECT Id 
			FROM Account
			WHERE Id IN :ids
		];
    }
    
    public List<Account> getAccountsByRecordTypeDeveloperName(String recordTypeDeveloperName) {
        return [
			SELECT Id
			FROM Account
			WHERE RecordType.DeveloperName = :recordTypeDeveloperName
			LIMIT 100
		];
    }
}