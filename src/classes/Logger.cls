public class Logger implements ILogger, Queueable {

	private List<Log__c> logs = new List<Log__c>();

	public Log__c create(Exception e) {

		Log__c log = new Log__c(
			Name = e.getTypeName().left(80),
			Message__c = e.getMessage().left(255),
			Detail__c = e.getMessage(),
			StackTrace__c = e.getStackTraceString(),
			Level__c = 'Error'
		);

		if (e instanceOf SoaServiceException)
			setExceptionInfo((SoaServiceException) e, log);
		else if (e instanceOf FinancingConnectException)
			setExceptionInfo((FinancingConnectException) e, log);
		else if (e instanceOf ApplicationException)
			setExceptionInfo((ApplicationException) e, log);
		else
			setExceptionInfo(e, log);

		return log;
	}

	public void createAndLog(Exception e) {
		log(create(e));
	}

	public Integer size() {
		return logs.size();
	}

	public void log(Log__c log) {
		if (log != null) {
			logs.add(log);
		}    
	}
	
	public void commitSync() {
		if (logs.size() > 0) {
			commitLogs();
		}
	}
	
	public void commitAsync() {
		if (logs.size() > 0) {
			System.enqueueJob(this);
		}
	}
	
	public void execute(QueueableContext context) {
		commitLogs();
	}

	public static void purge() {
		purge(false);
	}

	public static void purge(Boolean force) {
		FCSystemSettings__c settings = FCSystemSettings__c.getValues('Default settings');
		Integer interval = force 
			? Integer.valueOf(settings.LogForcedPurgeInterval__c) 
			: Integer.valueOf(settings.LogPurgeInterval__c);
		purge(interval, force);
	}

	private static void purge(Integer purgeInterval, Boolean force) {
		DateTime purgeDateTime = System.now().addMonths(-purgeInterval);

		List<Log__c> purgeList = force
			? [SELECT Id FROM Log__c WHERE createdDate < :purgeDateTime LIMIT 50000 ]
			: [SELECT Id FROM Log__c WHERE createdDate < :purgeDateTime AND DisablePurge__c = :false LIMIT 50000 ];

		if(purgeList.size() >= 1) { 
			Database.DeleteResult[] results = Database.delete(purgeList, false);

			for(Database.DeleteResult result : results) { 
				if (result.isSuccess()) {
					System.debug('Successfully deleted Log__c: ' + result.getId());
				} else {
					for(Database.Error error : result.getErrors()) {
						System.debug('The following error has occurred:' + error.getMessage());   
					}
				}
			}
		}
	}

	private static void setExceptionInfo(SoaServiceException e, Log__c log) {
		setExceptionInfo((ApplicationException) e, log);
		if (e.messageStatus != null) {
			log.Message__c = e.messageStatus.message.left(255);
			log.StackTrace__c = e.messageStatus.description;
		}
	}

	private static void setExceptionInfo(FinancingConnectException e, Log__c log) {
		setExceptionInfo((ApplicationException) e, log);
		log.Country__c = e.country;
	}

	private static void setExceptionInfo(ApplicationException e, Log__c log) {
		log.Source__c = e.source;
		log.Code__c = e.code;
	}

	private static void setExceptionInfo(Exception e, Log__c log) {
		String code = String.valueOf(FinancingConnectErrorCodes.SALESFORCE + FinancingConnectErrorCodes.GENERIC_EXCEPTION);
		log.Source__c = 'Salesforce';
		log.Code__c = code;
	}
	
	private void commitLogs() {
		Database.SaveResult[] results = Database.insert(logs,false);

		for (Database.SaveResult result : results) {
			if (result.isSuccess()) {
				System.debug('Successfully inserted Log__c: ' + result.getId());
			} else {              
				for (Database.Error error : result.getErrors()) {
					System.debug('The following error has occurred while inserting the Log__c record.');                    
					System.debug(error.getStatusCode() + ': ' + error.getMessage());
				}
			}
		}
	}
}