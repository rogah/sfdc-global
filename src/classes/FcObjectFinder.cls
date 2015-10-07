public with sharing class FcObjectFinder implements IFcObjectFinder {
	
	public List<List<SObject>> findDealsAndQuotes(String queryString, FinancingConnectContext context) {
		return [
			FIND :queryString IN ALL FIELDS 
			RETURNING 
				Opportunity (
						Id, 
						Name, 
						Company_Name__c, 
						Credit_Expiration_Date__c, 
						Rental_Amount__c,
						Deal_Number__c, 
						Credit_Status__c, 
						Status__c, 
						Equipment_Cost__c,
						RecordType.Name,
						RecordType.DeveloperName,
						Customer_Lessee__r.Name,
						Manage_Deal_For__r.Name,
						Opp_Partner_Owner__c
					WHERE RecordType.Name IN ('New Application Stage', 'Credit Check Stage') 
						AND Status__c NOT IN ('Quote Expired', 'Expired', 'Cancelled')
						AND Customer_Lessee__r.Country__c = :context.dealerCountry),
				Quote (
						Id, 
						Name, 
						Opportunity.PartnerAccount.Country__c, 
						OpportunityId, 
						QuoteNumber, 
						Company_name__c, 
						Lease_Type__c, 
						ExpirationDate, 
						Rental_Amount__c, 
						Opportunity.Equipment_Cost__c,                       
						Opportunity.Customer_Lessee__r.Name,
						Opportunity.Manage_Deal_For__r.Name,
						Opportunity.Opp_Partner_Owner__c
					WHERE Opportunity.RecordType.Name = 'Quote Stage'
                        AND Opportunity.Customer_Lessee__r.Country__c = :context.dealerCountry)
		];
	} 
}