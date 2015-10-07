public with sharing class FcSearchControllerExtension {

    public FcSearchControllerExtension(FinancingConnectController controller) { }

    @RemoteAction
    public static List<List<SObject>> search(String searchInput, FinancingConnectContext context) {
        IFcObjectFinder objectFinder = new FcObjectFinder();
        return objectFinder.findDealsAndQuotes(searchInput, context);
    }
}