public interface ILogger {
	Log__c create(Exception e);
	void createAndLog(Exception e);
	Integer size();
	void log(Log__c log);
	void commitSync();
	void commitAsync();
}