public class FcUserRepository implements IFcUserRepository {
	
	public User getUserById(Id userId) {
		return [SELECT Id,
				Name,
				FirstName,
				LastName,
				Username,
				Country,
				Email,
				DefaultCurrencyIsoCode,
				CurrencyIsoCode,
				IsPortalEnabled,
				IsPrmSuperUser,
				LanguageLocaleKey,
				LocaleSidKey,
				TimeZoneSidKey,
				ProfileId,
				UserRoleId,
				ContactId,
				UserType,
				Type__c,
				Account_Id__c,
				Business_Unit__c
			FROM User WHERE Id = :userId];
	}
}