public class GrupoAtencionFlujo_Siguiente {
	 @InvocableMethod(label='Siguiente Grupo Atención' description='Pasa al siguiente grupo de atención')
    public static void SiguienteGrupoAtencion(List<ID> ids) {
        Case ticket=[Select id ,NumberGroupAtention__c, InApprovalProcess__c from Case where Id=:ids LIMIT 1];
        Map<String,String> mapresult = new Map<String,String>();
    	mapresult = GruposAtencionFlujo_CONT.escalarRechazarCaso2(ticket.Id, '', 'escalar');
        System.debug('map ' + mapresult);
    }
}