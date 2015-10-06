public class FcUserWithAccountSpecification extends CompositeSpecification {
	
	public override Boolean isSatisfiedBy(Object candidate) {
		User user = (User) candidate;
		if (user == null) return false;
		return String.isNotBlank(user.Account_Id__c);
	}
}