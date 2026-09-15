@isTest 
public with sharing class AccountDataAccessorMock extends DmlBaseMock implements AccountDAO {
	public List<Account> mockDatabaseAccounts;

	public AccountDataAccessorMock() {
		super(new List<Account>());
		this.mockDatabaseAccounts = (List<Account>)super.records;
	}

	public Account getAccountById(String recordId) {
		Account accountToReturn;
		
		for (Account a : mockDatabaseAccounts) { 
			if (String.valueOf(a.Id) == recordId) {
				accountToReturn = a;
			}
		}

		if (accountToReturn != null) {
			return accountToReturn;
		} else {
			throw new QueryException('Account not found'); 
		}
	}
	
	public List<Account> getAccountByIds(Set<String> ids) {
		List <Account> accountsToReturn = new List<Account>();
		for (Account a : mockDatabaseAccounts) {
			for (Id aId : ids) {
				if (a.Id == aId) {
					accountsToReturn.add(a);
				}
			}
		}
		return accountsToReturn;
	}

	public List<Account> getAccountsByRecordTypeDeveloperName(String recordTypeDeveloperName) {
		List <Account> accountsToReturn = new List<Account>();
		for (Account a : mockDatabaseAccounts) {
			if (a?.RecordType?.DeveloperName?.equals(recordTypeDeveloperName)) {
				accountsToReturn.add(a);
			}
		}

		return accountsToReturn;
	}
}