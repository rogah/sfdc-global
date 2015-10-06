public class StandardUserSpecification extends CompositeSpecification {
	
	public override Boolean isSatisfiedBy(Object candidate) {
		User user = (User) candidate;
		if (user == null) return false;
		return String.isNotBlank(user.UserType) 
			&& user.UserType.equalsIgnoreCase(SystemConstants.USER_TYPE_STANDARD);
	}
}