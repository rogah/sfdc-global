@isTest
private Class LoggerTest {

	@testSetup static void setup() {
		FCSystemSettings__c settings = new FCSystemSettings__c();
		settings.Name = 'Default settings';
		settings.LogPurgeInterval__c = 3;
		settings.LogForcedPurgeInterval__c = 6;
		insert settings;
    }

	static testMethod void createShouldReturnLogForTheGivenExceptionWithDefaultSource() {
		ILogger logger = new Logger();

		try {
			Integer i = 1/0;
		} catch(Exception e) {
			Log__c log = logger.create(e);
			System.assertEquals(log.Source__c, 'Salesforce');
		}
	}

	static testMethod void createShouldReturnLogForTheGivenApplicationExceptionWithName(){
		ApplicationException e = new ApplicationMockException('Test Message: {0}', new String[] { 'foo' });
		Logger logger = new Logger();
		Log__c log = logger.create(e);
		System.assertEquals('LoggerTest.ApplicationMockException', log.Name);
	}

	static testMethod void createShouldReturnLogForTheGivenFinancingConnectExceptionWithName(){
		FinancingConnectException e = new FinancingConnectMockException('Test Message: {0}', new String[] { 'foo' });
		Logger logger = new Logger();
		Log__c log = logger.create(e);
		System.assertEquals('LoggerTest.FinancingConnectMockException', log.Name);
	}

	static testMethod void createShouldReturnLogForTheGivenApplicationExceptionWithMessage(){
		ApplicationException e = new ApplicationMockException('Test Message: {0}', new String[] { 'foo' });
		Logger logger = new Logger();
		Log__c log = logger.create(e);
		System.assertEquals(log.Message__c, e.getMessage());
	}

	static testMethod void createShouldReturnLogForTheGivenApplicationExceptionWithStackTrace(){
		ApplicationException e = new ApplicationMockException('Test Message: {0}', new String[] { 'foo' });
		Logger logger = new Logger();
		Log__c log = logger.create(e);
		System.assertEquals(log.StackTrace__c, e.getStackTraceString());
	}

	static testMethod void createShouldReturnLogForTheGivenApplicationExceptionWithLevel(){
		ApplicationException e = new ApplicationMockException('Test Message: {0}', new String[] { 'foo' });
		Logger logger = new Logger();
		Log__c log = logger.create(e);
		System.assertEquals(log.Level__c, 'Error');
	}

	static testMethod void createShouldReturnLogForTheGivenApplicationExceptionWithCode(){
		ApplicationException e = new ApplicationMockException('Test Message: {0}', new String[] { 'foo' });
		Logger logger = new Logger();
		Log__c log = logger.create(e);
		System.assertEquals(log.Code__c, e.code);
	}

	static testMethod void createShouldReturnLogForTheGivenApplicationExceptionWithSource(){
		ApplicationException e = new ApplicationMockException('Test Message: {0}', new String[] { 'foo' });
		Logger logger = new Logger();
		Log__c log = logger.create(e);
		System.assertEquals(log.Source__c, e.source);
	}

	static testMethod void createShouldReturnLogForTheGivenFinancingConnectExceptionWithCountry(){
		FinancingConnectException e = new FinancingConnectMockException('Test Message: {0}', new String[] { 'foo' });
		Logger logger = new Logger();
		Log__c log = logger.create(e);
		System.assertEquals(log.Country__c, e.country);
	}

	static testMethod void createAndLogShouldAcceptSoaServiceException(){
		SoaServiceException e = new SoaServiceMockException('1af97ef50a37c0240c26814f1bbfde38', 'Test Message: {0}', new String[] { 'foo' });
		ILogger logger = new Logger();
		logger.createAndLog(e);
		System.assertEquals(1, logger.size());
	}

	static testMethod void createAndLogShouldAcceptFinancingConnectException(){
		FinancingConnectException e = new FinancingConnectMockException('Test Message: {0}', new String[] { 'foo' });
		ILogger logger = new Logger();
		logger.createAndLog(e);
		System.assertEquals(1, logger.size());
	}

	static testMethod void createAndLogShouldAcceptApplicationException(){
		ApplicationException e = new ApplicationMockException('Test Message: {0}', new String[] { 'foo' });
		ILogger logger = new Logger();
		logger.createAndLog(e);
		System.assertEquals(1, logger.size());
	}

	static testMethod void createAndLogShouldAcceptException(){
		Exception e = new GeneralMockException('Test Message');
		ILogger logger = new Logger();
		logger.createAndLog(e);
		System.assertEquals(1, logger.size());
	}

	static testMethod void createAndLogShouldInsertLogInMemory(){
		FinancingConnectException e = new FinancingConnectMockException('Test Message: {0}', new String[] { 'foo' });
		ILogger logger = new Logger();
		logger.createAndLog(e);
		System.assertEquals(1, logger.size());
	}
	
	static testMethod void sizeShouldReturnTheNumberOfLogsInMemory(){
		Exception e = new ApplicationMockException('Test Message: {0}', new String[] { 'foo' });
		Logger logger = new Logger();
		Log__c log = logger.create(e);
		logger.log(log);
		System.assertEquals(1, logger.size());      
	}

	static testMethod void commitSyncShouldPersistLogsToDatabase(){
		Exception e = new ApplicationMockException('Test Message: {0}', new String[] { 'foo' });
		Logger logger = new Logger();
		Log__c log = logger.create(e);
		logger.log(log);
		
		Test.StartTest();
		logger.commitSync();
		Test.StopTest();
		
		List<Log__c> logs = [SELECT Name FROM Log__c];
		System.assertEquals(log.Name, logs.get(0).Name);      
	}

	static testMethod void commitAsyncShouldPersistLogsToDatabase(){
		Exception e = new ApplicationMockException('Test Message: {0}', new String[] { 'foo' });
		Logger logger = new Logger();
		Log__c log = logger.create(e);
		logger.log(log);
		
		Test.StartTest();
		logger.commitAsync();
		Test.StopTest();
		
		List<Log__c> logs = [SELECT Name FROM Log__c];
		System.assertEquals(log.Name, logs.get(0).Name);      
	}

	static testMethod void logShouldAddTheGivenLogToInMemoryList(){
		Exception e = new ApplicationMockException('Test Message: {0}', new String[] { 'foo' });
		Logger logger = new Logger();
		Log__c log = logger.create(e);
		logger.log(log);
		System.assertEquals(1, logger.size());      
	}

	static testMethod void purgeShouldDeleteLogsOlderThenLogPurgeInterval() {
		Integer purgePeriod = 3;
		createLogsToBePurged(2, purgePeriod, false);
		createLogsToBePurged(2, purgePeriod, true);
		createLogs(2);
        Logger.purge();
        List<Log__c> logs = [Select Id from Log__c];
        System.assertEquals(4, logs.size());
	}

	static testMethod void purgeForceShouldDeleteLogsOlderThenLogForcedPurgeInterval() {
		Integer purgePeriod = 6;
		createLogsToBePurged(2, purgePeriod, false);
		createLogsToBePurged(2, purgePeriod, true);
		createLogs(2);
        Logger.purge(true);
        List<Log__c> logs = [Select Id from Log__c];
        System.assertEquals(2, logs.size());
	}

	private static void createLogsToBePurged(Integer numberOfRecords, Integer purgePeriod, Boolean disablePurge) {
		List<Log__c> logs =  new List<Log__c>();

		DateTime now = System.now().addMonths(-purgePeriod);

		for (Integer i = 1; i <= numberOfRecords; i++) {
			DateTime createdDate = now.addDays(-i);
			String logJSON = '{"attributes":{"type":"Log__c","url":"/services/data/v25.0/sobjects/Log__c/"},"CreatedDate":' + JSON.serialize(createdDate) + ',"Name":"Log Test","DisablePurge__c":' + JSON.serialize(disablePurge) + ',"Source__c":"Test Source"}';
			Log__c log = (Log__c) JSON.deserialize(logJSON, Log__c.class);
			logs.add(log);
		}

		insert logs;
	}

	private static void createLogs(Integer numberOfRecords) {
     	List<Log__c> logs =  new List<Log__c>();

		for (Integer i = 1; i <= numberOfRecords; i++) {
			Log__c log = new Log__c (
				Name = 'Test Log' + i,
				Source__c = 'Test Source' + i,
				DisablePurge__c = false
			);
			logs.add(log);
		}

		insert logs;
	}

	class GeneralMockException extends Exception { }

	class SoaServiceMockException extends SoaServiceException { 
		public SoaServiceMockException(String messageId, String message, List<String> args) {
			super(messageId, 0, 0, message, args);
		}
	}

	class FinancingConnectMockException extends FinancingConnectException {
		public FinancingConnectMockException(String message, List<String> args) {
	        super('Mock Country', 0, 0, message, args);
	    }
	}

	class ApplicationMockException extends ApplicationException {
		public ApplicationMockException(String message, List<String> args) {
	        super('Mock Exception', 0, 0, message, args);
	    }
	}
}