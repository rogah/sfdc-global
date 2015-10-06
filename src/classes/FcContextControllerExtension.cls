public class FcContextControllerExtension {

	public FcContextControllerExtension(FinancingConnectController controller) { }

    @RemoteAction
    public static FinancingConnectContext getUserContext() {
    	IFcRepositoryFactory repositoryFactory = new FcRepositoryFactory();
        IFcContextService contextService = new FcContextService(repositoryFactory);
        return contextService.getContextFor(UserInfo.getUserId());
    }
}