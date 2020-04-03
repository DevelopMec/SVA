public class TicketControladorInputs {
@AuraEnabled
    public  Static Case EncuentraValores(Id recordId)
    	{
            //Controlador de los campos para componente ligthning
            Map<String, Schema.SObjectField> M = Schema.SObjectType.case.fields.getMap();
            System.Debug('@ > '+ M);
            String strQ;
            for(String strF:m.Keyset())
            {
            System.Debug('@@'+strF);
            
            if(strQ == null)
            strQ=strF;
            else
            strQ= strQ + ','+strF; 
            }
            strQ='Select '+strQ;
            System.Debug('@Query >'+strQ);  
            List<String> ObjetosCaso = strQ.split(',');
            
            Case caso = [SELECT 
                               id,isdeleted,casenumber,contactid,accountid,sourceid,suppliedname,suppliedphone,suppliedcompany,type,recordtypeid,status,reason,origin,isclosed,closeddate,ownerid,createddate,createdbyid,lastmodifieddate,lastmodifiedbyid,systemmodstamp,contactphone,contactmobile,contactemail,contactfax,comments,lastvieweddate,lastreferenceddate,contrato_filial__c,codigo_de_cliente_n_de_cliente__c,asignar_propietario__c,transaccion__c,fecha_movimiento__c,nde_pedido_de_bonos_vales__c,nde_pedido_de_tarjeta__c,nde_pedido_de_saldos__c,fecha_de_pedido_saldos__c,fecha_de_pedido_tarjeta__c,control_de_pedido_n_mero__c,estatus_de_facturas_pendientes_de_pago__c,nde_control_factura__c,importe_de_factura__c,nde_factura_electronica__c,direccion_auxiliar__c,cantidad_de_bonos_y_o_tarjetas__c,nombre_del_contacto_que_recibe_el_pedido__c,motivo__c,score__c,semaforo__c,segmento_comercial__c,canal_de_atencion__c,id_grupo__c,sector__c,sub_estatus__c,sub_motivo__c,temperatura_del_contacto__c,first_call_resolution__c,priorizacion_manager__c,rfc__c,razon_social__c,sla_1__c,sla_2__c,motivo_fcr__c,fecha_de_re_apertura__c,familia__c,grupo_de_atencion__c,grupo_atencion_siguiente__c,grupo_atencion_anterior__c,tipo_de_cliente__c,origen_caso__c
                               FROM case WHERE Id=:recordId LIMIT 1];

        	return caso;
       
    	}
    

    
    }