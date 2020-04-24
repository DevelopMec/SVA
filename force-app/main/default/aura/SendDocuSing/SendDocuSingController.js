({
	enviarDocumento : function(component, event, helper){
        var action=component.get("c.generarInformacion");
        action.setParams({recordId : component.get("v.recordId")});
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state=='SUCCESS'){
                var result=response.getReturnValue();
                if(result.status=='success'){
                    window.open(result.urlDocuSign+"?DST="+encodeURI(result.templateId)+"&eId="+encodeURI(result.idDoc)+"&nw=1&sId="+encodeURI(component.get("v.recordId")),"_blank");
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type":"error",
                        "message": result.msj
                    });
                    toastEvent.fire();
                }
            }else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type":"error",
                    "message": "Error al obtener los documentos"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
            /*
        var rc = component.get("v.recordId");
        var CCTM = 'Decision Maker~Signer;Executive Sponsor~Sign In Person';
        var CRL='Email~{!User.Email}; Role~Executive Sponsor; FirstName~{!User.FirstName}; LastName~{!User.LastName}; SignInPersonName~Dan Smith;SignNow~1';
        window.location.href = "https://edenredmexico--preprod--dsfs.visualforce.com/apex/docusign_editenvelope?eId=a1r2F000001ONeRQAW&nw=1&sId=0062F000009I1ltQAC";
    */}
})