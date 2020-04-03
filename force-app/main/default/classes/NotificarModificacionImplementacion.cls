public without sharing class NotificarModificacionImplementacion {    
	@InvocableMethod
    public static void notificarCambio(List<Opportunity> listOpp){
        System.debug('Inicio ');
        Set<String> idsOp=new Set<String>(); 
        for(Opportunity o:listOpp){
            idsOp.add(o.Id);
        }
        Map<Id, Map<String,String>> oppMap = new Map<Id, Map<String,String>>();
        for(WorkOrder wo: [Select Id,OwnerId,Oportunidad__c from WorkOrder where Oportunidad__c IN:idsOp]){
            if(!oppMap.containsKey(wo.Oportunidad__c)){
                Map<String,String> tem=new Map<String,String>();
                tem.put('IdOT',wo.Id);
                tem.put('IdOwner',wo.OwnerId);
                oppMap.put(wo.Oportunidad__c,tem);
            }
        }
        for(String opp:oppMap.keySet()){
            notificar(opp,oppMap.get(opp));
        }
    }
    public static void notificar(String IdOpp,Map<String,String> datosOT){
        System.debug('INICIO notificar');
        try{
            String titulo=' Se realizaron algunas actualizaciones en Volumen de emisión o Fecha estimada de compra,';
            String comm='ingresa a la Orden de trabajo para mas detalles';
            ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
            feedItemInput.subjectId=datosOt.get('IdOT');
            
            ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
            messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
            
            ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
            mentionSegmentInput.id = datosOt.get('IdOwner');
            messageBodyInput.messageSegments.add(mentionSegmentInput);
            
            textSegmentInput.text = titulo+'\n'+ comm;
            messageBodyInput.messageSegments.add(textSegmentInput);
            
            
            
            feedItemInput.body = messageBodyInput;
            feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
            //feedItemInput.subjectId=IdWo;
            ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);
            System.debug('FIN publica');
        }catch(Exception e){
            System.debug('Error: '+e.getMessage()+', linea: '+e.getLineNumber());
        }   
    }
}