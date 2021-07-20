/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 10/04/2021
* @description Mock success response class
*/
@isTest
public class RestSuccessMock implements HttpCalloutMock {
    /**
    * @description Http respond method
    * @param request HttpRequest object
    * @return HttpResponse object
    */
    public HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        response.setStatusCode(Constants.HTTP_SUCCESS_CODE);
        response.setBody(TestDataFactory.getDefaultRestSuccessMockResponseBody());
        return response;
    }
}