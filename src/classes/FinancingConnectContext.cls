public class FinancingConnectContext {

	public Id id { get; set; }
	public Id profileId { get; set; }
	public Id userRoleId { get; set; }
	public String name { get; set; }
	public String firstName { get; set; }
	public String lastName { get; set; }
	public String type { get; set; }
	public String userType { get; set; }
	public String email { get; set; }
	public String username { get; set; }
	public Boolean isSuperUser { get; set; }
	public Boolean isPartnerUser { get; set; }
	public String currencyCode { get; set; }
	public String languageCode { get; set; }
	public String localeCode { get; set; }
	public String timezone { get; set; }
	public String businessUnit { get; set; }

	public Id dealerId { get; set; }
	public Id dealerOwnerId { get; set; }
	public String dealerApprovalStatus { get; set; }
	public String dealerEbossDealerId { get; set; }
	public String dealerCountry { get; set; }
	public String dealerCurrency { get; set; }
	public String dealerTier { get; set; }
	public String dealerCommissionType { get; set; }
	public Decimal dealerMaxCommissionPercent { get; set; }
	public Decimal dealerMinCommissionPercent { get; set; }
	public Decimal dealerStandardCommissionPercent { get; set; }
	public Boolean dealerShowCommission { get; set; }

	public Boolean isValid { get; set; }
}