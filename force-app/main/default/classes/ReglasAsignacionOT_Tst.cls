@isTest(SeeAllData=true)
public class ReglasAsignacionOT_Tst {   
    @isTest
    private static void ReglasAsignacionOT(){
        new ReglasAsignacionOT();        
        /*List<String> asignaciones=new List<String>{'TradeMarketing', 'Corporate: Large-Key-Publico', 'Corporate: Occidente', 'Corporate: Norte', 'Corporate: Bajio GT-AS-ZS', 'Corporate: Bajio SP-QT', 'Corporate: TE-MTTO-KAM-CE-NE-SE-MRO', 'Small: Familias Restantes', 'Small-PT: Combustible-Viaticos', 'Small', 'MLK'};
            User u=[Select Id from User where isActive=true and Profile.Name='Implementación' limit 1];
        u.Asignaciones_PL__c = 'Ordenes de trabajo';
        u.filtroAsignacion_MSPL__c=String.join(asignaciones, ';');
        update u;
        test.startTest();
        List<WorkOrder> lWO=[Select Id,Estatus__c,Oportunidad__c from WorkOrder limit 10];
        Map<Id,WorkOrder> mapWO=new Map<Id,WorkOrder>([Select Id,Estatus__c,Oportunidad__c from WorkOrder limit 10]);
        
        ReglasAsignacionOT asigna=new ReglasAsignacionOT(lWO);
        ReglasAsignacionOT asign=new ReglasAsignacionOT(lWO,mapWO);
        test.stopTest();*/
    }
    @isTest
    public static void metodo2(){
        try{
        WorkOrder ot=[Select Id from WorkOrder where Estatus__c='Pedido' and Fechas_pedido_tarjetas__c='LLENO' and Oportunidad__r.StageName IN ('Cotización','Contrato','Implementación') limit 1];
        ot.Estatus__c='Concluida';
        update ot;
        }catch(Exception e){
            
        }
    }
}