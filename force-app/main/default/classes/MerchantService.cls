@RestResource(urlMapping='/MerchantService/*')
global  class MerchantService {
    @HttpPost
    global static ResponseWprWs getRecords(Decimal BranchId, Decimal ProductId, Decimal ChainId, Decimal AffiliateId, Decimal WattsId, Decimal ATPVId,
    	String LegalEntityId, String OperationGroupId, String OPCOIdentifier,  String LegalEntityIdentifier,  String GroupIdentifier) {
			
			Boolean blnStatusResponse = false;
			List<Errors> lstErrors = new List<Errors>();
			Errors objresponseError = new Errors();
			ResponseWprWs responseJSON = new ResponseWprWs();


			System.debug(' *******  VALORES JSON ****** ');
			System.debug(BranchId);
			System.debug(ProductId);
			System.debug(ChainId);
			System.debug(AffiliateId);
			System.debug(WattsId);
			System.debug(ATPVId);
			System.debug(LegalEntityId);
			System.debug(OperationGroupId);
			System.debug(OPCOIdentifier);
			System.debug(LegalEntityIdentifier);
			System.debug(GroupIdentifier);

			/** VALIDA QUE TODOS LOS PARAMETROS SEAN OBLIGATORIOS  */
			if(BranchId !=null && ProductId !=null  && ChainId !=null  && AffiliateId !=null && WattsId !=null && ATPVId !=null &&
				LegalEntityId != null  && LegalEntityId !='' &&
				OperationGroupId != null  && OperationGroupId !='' && 
				OPCOIdentifier != null  && OPCOIdentifier !='' &&
				LegalEntityIdentifier != null  && LegalEntityIdentifier !='' &&
				GroupIdentifier != null  && GroupIdentifier !=''){

				blnStatusResponse = true;

			}

			// SI TODO ES CORRECTO SE MANDA 200
			if(blnStatusResponse){
				responseJSON.message = 'Id Procesado correctamente';
				responseJSON.success = true;
				responseJSON.statusCode = 200;
				responseJSON.errors = new List<Errors>() ;
			}else{
				responseJSON.message = 'Error';
				responseJSON.success = false;
				responseJSON.statusCode = 500;

				objresponseError.message = 'Error Faltan valores';
				objresponseError.code = '500';
				lstErrors.add(objresponseError);
				responseJSON.errors = lstErrors;
			}
			
			

		return responseJSON;    

	}

	global class ResponseWprWs {
		global String message {get;set;}
		global Boolean success{get;set;}
		global Integer statusCode{get;set;}
		global List<Errors> errors{get;set;}
	} 

	global class Errors {
		global String message{get;set;}
		global String code{get;set;}
	}
	
}