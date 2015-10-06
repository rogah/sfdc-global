public class FcContextService implements IFcContextService {

	IFcUserRepository userRepository;
	IFcAccountRepository accountRepository;

	public FcContextService(IFcRepositoryFactory respositoryFactory) {
		this.userRepository = respositoryFactory.createUserRepository();
		this.accountRepository = respositoryFactory.createAccountRepostitory();
	}

	public FinancingConnectContext getContextFor(Id userId) {

		User user = this.userRepository.getUserById(userId);

		Specification standardUserSpec = new StandardUserSpecification();
		Specification dfsSalesTypeSpec = new FcDfsSalesTypeSpecification();
		Specification userWithAccountSpec = new FcUserWithAccountSpecification();
		Specification dfsSalesUserSpec = standardUserSpec.andSpec(dfsSalesTypeSpec).andSpec(userWithAccountSpec);

		if (dfsSalesUserSpec.isSatisfiedBy(user)) {
			Account account = accountRepository.getAccountById(user.Account_Id__c);
			if (account == null)
				return createInvalidUserContext(user);
			return createUserContext(user, account);
		}
		
		return createInvalidUserContext(user);
	}

	private FinancingConnectContext createUserContext(User user, Account account) {
		FinancingConnectContext context = new FinancingConnectContext();
		context.id = user.Id;
		context.profileId = user.ProfileId;
		context.userRoleId = user.UserRoleId;
		context.name = user.Name;
		context.firstName = user.FirstName;
		context.lastName = user.LastName;
		context.type = user.Type__c;
		context.userType = user.UserType;
		context.email = user.Email;
		context.username = user.Username;
		context.isSuperUser = user.IsPrmSuperUser;
		context.isPartnerUser = false;
		context.currencyCode = user.CurrencyIsoCode;
		context.languageCode = user.LanguageLocaleKey;
		context.localeCode = user.LocaleSidKey;
		context.timezone = user.TimeZoneSidKey;
		context.businessUnit = user.Business_Unit__c;
		context.dealerId = account.Id;
		context.dealerOwnerId = account.OwnerId;
		context.dealerApprovalStatus = account.Approval_Status__c;
		context.dealerEbossDealerId = account.eBoss_Dealer_ID__c;
		context.dealerCountry = account.CurrencyIsoCode;
		context.dealerCurrency = account.Dealer_Tier__c;
		context.dealerTier = account.Commission_Type__c;
		context.dealerCommissionType = account.Commission_Type__c;
		context.dealerMinCommissionPercent = account.Min_Commission_Percent__c;
		context.dealerMaxCommissionPercent = account.Max_Commission_Percent__c;
		context.dealerStandardCommissionPercent = account.Standard_Commission_Percent__c;
		context.dealerShowCommission = account.Show_Commission__c;
		context.isValid = true;
		System.debug(context);
		return context;
	}

	private FinancingConnectContext createInvalidUserContext(User user) {
		FinancingConnectContext context = new FinancingConnectContext();
		context.id = user.Id;
		context.profileId = user.ProfileId;
		context.userRoleId = user.UserRoleId;
		context.firstName = user.FirstName;
		context.lastName = user.LastName;
		context.type = user.Type__c;
		context.userType = user.UserType;
		context.email = user.Email;
		context.username = user.Username;
		context.isSuperUser = user.IsPrmSuperUser;
		context.isPartnerUser = false;
		context.currencyCode = user.CurrencyIsoCode;
		context.languageCode = user.LanguageLocaleKey;
		context.localeCode = user.LocaleSidKey;
		context.timezone = user.TimeZoneSidKey;
		context.businessUnit = user.Business_Unit__c;
		context.isValid = false;
		System.debug(context);
		return context;
	}
}