public class FcDfsSalesTypeSpecification extends CompositeSpecification {
	
	public override Boolean isSatisfiedBy(Object candidate) {
		User user = (User) candidate;
		if (user == null) return false;
		return String.isNotBlank(user.Type__c) 
			&& user.Type__c.equalsIgnoreCase(FcConstants.USER_TYPE_DFS_SALES);
	}
}