public class FcAccountRepository implements IFcAccountRepository {
	
	public Account getAccountById(Id accountId) {
		return [SELECT Id,
			Approval_Status__c,
			Segment_Description__c,
			eBoss_Dealer_ID__c,
			Country__c,
			CurrencyIsoCode,
			Dealer_Tier__c,
			Commission_Type__c,
			Max_Commission_Percent__c,
			Min_Commission_Percent__c,
			Standard_Commission_Percent__c,
			Show_Commission__c,
			OwnerId,
			Dealer_SBU_Code__c,
			Dealer_Segment_Code__c
		FROM Account 
		WHERE Id = :accountId];
	}
}