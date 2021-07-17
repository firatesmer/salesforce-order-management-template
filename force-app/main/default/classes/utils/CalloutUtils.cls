/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 10/04/2021
* @description Callout utils class
*/
public with sharing class CalloutUtils {
	private static HttpRequest request;
	private static List<OmsLog__c> logsToInsert = new List<OmsLog__c>();

	/**
	* @description Http request callout
	* @param endpoint Endpoint
	* @param method Http method
	* @param headers Request headers (if any)
	* @param body String body (if any)
	* @return Http response
	*/
	@suppressWarnings('PMD.ExcessiveParameterList')
	public static HttpResponse doCallout(String endpoint, String method, Map<String, String> headers, String body) {
		return doCallout(endpoint, method, headers, body, Enums.LogLevel.ERROR_ONLY, true);
	}

	/**
	* @description Http request callout
	* @param endpoint Endpoint
	* @param method Http method
	* @param headers Request headers (if any)
	* @param body String body (if any)
	* @param logLevel NONE|ERRORS_ONLY|ALL
    * @param autoInsertLogs If true inserts the logs automatically after callout
	* @return Http response
	*/
	@suppressWarnings('PMD.ExcessiveParameterList')
	public static HttpResponse doCallout(String endpoint, String method, Map<String, String> headers, String body, Enums.LogLevel logLevel, Boolean autoInsertLogs) {
		request = new HttpRequest();
		request.setEndpoint(endpoint);
		request.setMethod(method);

		if (!headers.isEmpty()) {
			setRequestHeaders(headers);
		}

		if (String.isNotBlank(body)) {
			request.setBody(body);
		}

		HttpResponse response = new Http().send(request);

		createHttpLog(body, response, logLevel, autoInsertLogs);

		return response;
	}

	/**
	* @description Logs Http request and response
	* @param request Request body, string
	* @param response Http response
	* @param logLevel NONE | ERRORS_ONLY | ALL
	* @param autoInsert If true inserts the logs automatically after callout
	*/
    @suppressWarnings('PMD.ExcessiveParameterList')
	private static void createHttpLog(String request, HttpResponse response, Enums.LogLevel logLevel, Boolean autoInsert) {
		if (logLevel == Enums.LogLevel.NONE) {
			return;
		}

		Boolean isHttpOk = isHttpResponseOk(response);

		if (logLevel == Enums.LogLevel.ALL || (logLevel == Enums.LogLevel.ERROR_ONLY && !isHttpOk)) {
			// log Http request
			if (String.isNotBlank(request)) {
				OmsLog__c requestLog = LogUtils.createInfoLog(Constants.HTTP_REQUEST, request);
				logsToInsert.add(requestLog);
			}
			// log Http response
			OmsLog__c responseLog = isHttpOk
				? LogUtils.createInfoLog(Constants.HTTP_RESPONSE, response.getBody())
				: LogUtils.createErrorLog(Constants.HTTP_RESPONSE, response.getBody());
			logsToInsert.add(responseLog);
		}

		if (autoInsert) {
			insertHttpLogs();
		}
	}

	/**
	* @description Inserts Http logs
	*/
	public static void insertHttpLogs() {
		if (!logsToInsert.isEmpty()) {
			DatabaseUtils.insertRecords(logsToInsert, false);
			clearHttpLogs();
		}
	}

	/**
	* @description Clears Http logs
	*/
	public static void clearHttpLogs() {
		logsToInsert.clear();
	}

	/**
	* @description Checks if Http response is ok
	* @param response Http response
	* @return Boolean
	*/
	public static Boolean isHttpResponseOk(HttpResponse response) {
		return !(String.valueOf(response.getStatusCode()).startsWith('4') ||
		String.valueOf(response.getStatusCode()).startsWith('5'));
	}

	/**
	* @description Sets headers to Http request
	* @param headers Request headers
	*/
	private static void setRequestHeaders(Map<String, String> headers) {
		for (String header : headers.keySet()) {
			request.setHeader(header, headers.get(header));
		}
	}
}