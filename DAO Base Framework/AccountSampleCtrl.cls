public with sharing class AccountSampleCtrl {

	public static AccountDAO accountAccessor = new AccountDataAccessor();

	@AuraEnabled
	public static String getAccount(String accountId){
		try {
			Account acc = accountAccessor.getAccountById(accountId);
			return JSON.serialize(acc);
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

	@AuraEnabled
	public static String updateAccount(Account acc){
		try {
			accountAccessor.updateRecords(new List<Account>{acc});
			return JSON.serialize(acc);
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

	public String getAccount2(String accountId) {
		try {
			Account acc = accountAccessor.getAccountById(accountId);
			return JSON.serialize(acc);
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

}