/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 10/04/2021
* @description Mock fail response class
*/
@isTest
public class RestFailMock implements HttpCalloutMock {
    /**
    * @description Http respond method
    * @param request HttpRequest object
    * @return HttpResponse object
    */
    public HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        response.setStatusCode(Constants.HTTP_INTERNAL_ERROR_CODE);
        response.setBody(TestDataFactory.getDefaultRestFailMockResponseBody());
        return response;
    }
}