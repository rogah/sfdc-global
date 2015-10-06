public class FcRepositoryFactory implements IFcRepositoryFactory {

	public IFcUserRepository createUserRepository() {
		return new FcUserRepository();
	}

	public IFcAccountRepository createAccountRepostitory() {
		return new FcAccountRepository();
	}
}