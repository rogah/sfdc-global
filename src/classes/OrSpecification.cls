public class OrSpecification extends CompositeSpecification {
    private Specification spec1;
    private Specification spec2;
    
    public OrSpecification(Specification spec1, Specification spec2){
        this.spec1 = spec1;
        this.spec2 = spec2;
    }
    
    public override Boolean isSatisfiedBy(Object candidate){
        return spec1.isSatisfiedBy(candidate) || spec2.isSatisfiedBy(candidate);
    }
}