public abstract class CompositeSpecification implements Specification {
	
	public abstract Boolean isSatisfiedBy(Object candidate);
    
    public Specification andSpec(Specification other){
        return new AndSpecification(this, other);
    }
    
    public Specification orSpec(Specification other){
        return new OrSpecification(this, other);
    }
    
    public Specification notSpec(){
        return new NotSpecification(this);
    }
}