/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 10/08/2021
* @description Salesforce mock adapter (provided by Salesforce)
*   suppress reason: Adapter requires global access modifier
*/
@SuppressWarnings('PMD.AvoidGlobalModifier')
global class SalesforceAdapter implements commercepayments.PaymentGatewayAdapter {
    private static final commercepayments.SalesforceResultCodeInfo SUCCESS_SALESFORCE_RESULT_CODE_INFO = 
        new commercepayments.SalesforceResultCodeInfo(commercepayments.SalesforceResultCode.Success);
    private static final commercepayments.SalesforceResultCodeInfo DECLINE_SALESFORCE_RESULT_CODE_INFO = 
        new commercepayments.SalesforceResultCodeInfo(commercepayments.SalesforceResultCode.Decline);
    
    /**
    * @description Processes request
    * @param gatewayContext PaymentGateway context
    * @return PaymentGateway response
    */
    global commercepayments.GatewayResponse processRequest(commercepayments.paymentGatewayContext gatewayContext) {
        commercepayments.RequestType requestType = gatewayContext.getPaymentRequestType();
        commercepayments.GatewayResponse response;

        try 
        {
            if (requestType == commercepayments.RequestType.Authorize) 
            {
                response = createAuthResponse((commercepayments.AuthorizationRequest)gatewayContext.getPaymentRequest());
            }
            else if (requestType == commercepayments.RequestType.Capture)
            {
                response = createCaptureResponse((commercepayments.CaptureRequest)gatewayContext.getPaymentRequest());
            }
            else if (requestType == commercepayments.RequestType.Sale)
            {
                response = createSaleResponse((commercepayments.SaleRequest)gatewayContext.getPaymentRequest());
            }
            else if (requestType == commercepayments.RequestType.ReferencedRefund) 
            {
                response = createRefundResponse((commercepayments.ReferencedRefundRequest)gatewayContext.getPaymentRequest());
            }
            else if (requestType == commercepayments.RequestType.Tokenize) 
            {
                response = createTokenizeResponse();
            }
            return response;
        }
        catch(SalesforceAdapterException e)
        {
             commercepayments.GatewayErrorResponse error = new commercepayments.GatewayErrorResponse('400', e.getMessage());
             return error;
        }
    }

    /**
    * @description Creates response for tokenize request
    * @return PaymentGateway response
    */
    public commercepayments.GatewayResponse createTokenizeResponse() {
        commercepayments.PaymentMethodTokenizationResponse tokenizeResponse = new commercepayments.PaymentMethodTokenizationResponse();
        tokenizeResponse.setGatewayToken(getRandomNumber(8) + getRandomNumber(8));
        tokenizeResponse.setGatewayTokenDetails(getRandomNumber(8) + getRandomNumber(8));
        tokenizeResponse.setGatewayAvsCode(getRandomNumber(8) + getRandomNumber(8));
        tokenizeResponse.setGatewayMessage(getRandomNumber(8) + getRandomNumber(8));
        tokenizeResponse.setGatewayResultCode(getRandomNumber(8) + getRandomNumber(8));
        tokenizeResponse.setGatewayResultCodeDescription(getRandomNumber(8) + getRandomNumber(8));
        tokenizeResponse.setSalesforceResultCodeInfo(SUCCESS_SALESFORCE_RESULT_CODE_INFO);
        tokenizeResponse.setGatewayToken(getRandomNumber(8) + getRandomNumber(8));
        tokenizeResponse.setGatewayDate(System.now());
        return tokenizeResponse;
    }
    
    /**
    * @description Creates response for authorization request
    * @param authRequest Authorization request
    * @return PaymentGateway response
    */
    public commercepayments.GatewayResponse createAuthResponse(commercepayments.AuthorizationRequest authRequest) {
        commercepayments.AuthorizationResponse authResponse = new commercepayments.AuthorizationResponse();
        commercepayments.PaymentMethodTokenizationResponse paymentMethodTokenizationResponse = new commercepayments.PaymentMethodTokenizationResponse();

        if(authRequest.amount != null)
        {
            authResponse.setAmount(authRequest.amount);
        }
        else
        {
            throw new SalesforceAdapterException('Required Field Missing : Amount');
        }
    
        authResponse.setGatewayResultCode('00');
        authResponse.setGatewayResultCodeDescription('Transaction Normal');
        authResponse.setGatewayAuthCode('SF' + getRandomNumber(6));
        authResponse.setGatewayReferenceNumber(getRandomNumber(10));
        authResponse.setSalesforceResultCodeInfo(SUCCESS_SALESFORCE_RESULT_CODE_INFO);
        authResponse.setGatewayDate(System.now());
        paymentMethodTokenizationResponse.setGatewayToken(getRandomNumber(8) + getRandomNumber(8));
        authResponse.setPaymentMethodTokenizationResponse(paymentMethodTokenizationResponse);
        return authResponse;
    }
    
    /**
    * @description Creates response for capture request
    * @param captureRequest Capture request
    * @return PaymentGateway response
    */
    public commercepayments.GatewayResponse createCaptureResponse(commercepayments.CaptureRequest captureRequest) {
        commercepayments.CaptureResponse captureResponse = new commercepayments.CaptureResponse();

        if(captureRequest.amount != null)
        {
            captureResponse.setAmount(captureRequest.amount);
        }
        else
        {
            throw new SalesforceAdapterException('Required Field Missing : Amount');             
        }
   
        captureResponse.setGatewayDate(System.now());
        captureResponse.setGatewayResultCode('00');
        captureResponse.setGatewayResultCodeDescription('Transaction Normal');
        captureResponse.setGatewayReferenceNumber('SF' + getRandomNumber(6));
        captureResponse.setSalesforceResultCodeInfo(SUCCESS_SALESFORCE_RESULT_CODE_INFO);
        return captureResponse;
    }
    
    /**
    * @description Creates response for sale request
    * @param saleRequest Sale request
    * @return PaymentGateway response
    */
    public commercepayments.GatewayResponse createSaleResponse(commercepayments.SaleRequest saleRequest) {
        commercepayments.SaleResponse saleResponse = new commercepayments.SaleResponse();
        commercepayments.PaymentMethodTokenizationResponse paymentMethodTokenizationResponse = new commercepayments.PaymentMethodTokenizationResponse();

        if(saleRequest.amount != null)
        {
            saleResponse.setAmount(saleRequest.amount);
        }
        else
        {
            throw new SalesforceAdapterException('Required Field Missing : Amount');             
        }
   
        saleResponse.setGatewayDate(System.now());
        saleResponse.setGatewayResultCode('00');
        saleResponse.setGatewayResultCodeDescription('Transaction Normal');
        saleResponse.setGatewayReferenceNumber('SF' + getRandomNumber(6));
        saleResponse.setSalesforceResultCodeInfo(SUCCESS_SALESFORCE_RESULT_CODE_INFO);
        paymentMethodTokenizationResponse.setGatewayToken(getRandomNumber(8) + getRandomNumber(8));
        saleResponse.setPaymentMethodTokenizationResponse(paymentMethodTokenizationResponse);
        return saleResponse;
    }
    
    /**
    * @description Creates response for refund request
    * @param refundRequest Refund request
    * @return PaymentGateway response
    */
    public commercepayments.GatewayResponse createRefundResponse(commercepayments.ReferencedRefundRequest refundRequest) {
        commercepayments.ReferencedRefundResponse refundResponse = new commercepayments.ReferencedRefundResponse();
        
        if (refundRequest.amount != null) 
        {
            refundResponse.setAmount(refundRequest.amount);
        } 
        else 
        {
            throw new SalesforceAdapterException('Required Field Missing : Amount');
        }

        refundResponse.setGatewayResultCode('00');
        refundResponse.setGatewayDate(System.now());
        refundResponse.setGatewayResultCodeDescription('Transaction Normal');
        refundResponse.setGatewayReferenceNumber('SF' + getRandomNumber(6));
        refundResponse.setSalesforceResultCodeInfo(SUCCESS_SALESFORCE_RESULT_CODE_INFO);
        return refundResponse;
    }  

    /**
    * @description Generates random number based on length
    * @param stringLength Length of the string
    * @return Random number as string
    */
    private String getRandomNumber(integer stringLength) {
        Integer max = integer.valueOf(Math.pow(10, stringLength) - 1);
        return String.valueOf(Math.Round(Math.Random() * MAX)).leftPad(stringLength, '0');
    }

    private class SalesforceAdapterException extends Exception { }
}