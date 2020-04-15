public with sharing class Vista_EjecutivosAsignadosBatchProcess {
    
    Map<Id,Account> lupdateCuentas = new Map<Id,Account>;
    List<ContratoFilial__c> contratoF = new List<ContratoFilial__c>();

    Public Vista_EjecutivosAsignadosBatchProcess(List<Account> cuentas, List<ContratoFilial__c> contratoF) {
        this.lupdateCuentas = new Map<Id,Account>(cuentas);
        this.contratoF = contratoF;
    }

    public  List<Account> updateAccountView() {
        List<Account> listToUpdateAcc = new List<Account>();
        for(Accout cuenta : this.lupdateCuentas.values()) {
            if(allContractsInnactive(cuenta)){
                cuenta.Frozen_Segment__c = cuenta.Text_Segment__c;
                cuenta.business__c = '';
                cuenta.Funcion__c = '';
                cuenta.type =  System.Label.exclient;
            } else {
                cuenta.Frozen_Segment__c = '';
                cuentas.type = 'cliente';
            }
            listToUpdateAcc.add(cuenta);
        }
        return listToUpdateAcc;
    }

    private  boolean allContractsInnactive(Account cuenta) {
        List<ContratoFilial__c> contratosCuenta = new List<ContratoFilial__c>();
        Integer contratosInactivos = 0;
        for(ContratoFilial__c contrato : this.contratoF) {
            if(contrato.Entidad_Cuenta__r.Cuenta__c == cuenta.Id) {
                contratosCuenta.add(contrato);
                if(!contrato.isActive__c){
                    contratosInactivos += 1;
                }
            }
        }
        return contratosInactivos == contratosCuenta.size();
    }

}
