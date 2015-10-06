public class FcContextControllerExtension {

	public FcContextControllerExtension(FinancingConnectController controller) { }

    @RemoteAction
    public static FinancingConnectContext getUserContext() {
    	IFcRepositoryFactory repositoryFactory = new FcRepositoryFactory();
        System.debug(repositoryFactory);
        IFcContextService contextService = new FcContextService(repositoryFactory);
        System.debug(contextService);
        return contextService.getContextFor(UserInfo.getUserId());
    }
}