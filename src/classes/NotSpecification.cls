public class NotSpecification extends CompositeSpecification {
    private Specification spec;
    
    public NotSpecification(Specification spec){
        this.spec = spec;
    }
    
    public override Boolean isSatisfiedBy(Object candidate){
        return !spec.isSatisfiedBy(candidate);
    }
}