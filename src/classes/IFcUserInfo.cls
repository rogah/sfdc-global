public interface IFcUserInfo {
	Id getId();
	Id getProfileId();
	Id getUserRoleId();
	String getFirstName();
	String getLastName();
	String getType();
	String getUserType();
	String getEmail();
	String getUsername();
	Boolean isSuperUser();
	Boolean isPortalEnabled();
	String getUserCurrencyCode();
	String getDefaultCurrencyCode();
	String getLocaleCode();
	String getLanguageCode();
	String getTimeZoneCode();
	Id getAccountId();
	Id getAccountOwnerId();
	String getAccountApprovalStatus();
	String getAccountDealerId();
	String getAccountCountry();
	String getAccountCurrency();
	String getAccountTier();
	String getAccountCommissionType();
	Decimal getAccountMinCommissionPercent();
	Decimal getAccountMaxCommissionPercent();
	Decimal getAccountStandardCommissionPercent();
	Boolean shouldAccountShowCommission();
}