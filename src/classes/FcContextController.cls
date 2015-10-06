public class FcContextController {

    public FcContextController(ApexPages.StandardController stdController) { }

    @RemoteAction
    public static String getUserContext() {
        return UserInfo.getName();
    }
}