@isTest
private class TriggerTarifaOporunidadHandlerTest {
    @isTest
	static void itShould()
    {
        Producto__c producto = new 	Producto__c(Name='hsodia', Uso__c='sjd;jsda', Subproductos__c='sdas,fassa,fsa');
        insert producto;
        Account cta = new Account(Name='cuenta', NumberOfEmployees = 12, NumeroEmpleados__c = '1-25');
        insert cta;
        Opportunity opp = new Opportunity(Name = 'test', StageName = 'test',
                                          Producto__c=producto.Id, UsoProducto__c='1;32', TipoSolucion__c='ddas',
                                          CloseDate=date.today().addDays(5),Familia__c = 'familiaTest', Account=cta );
        insert opp;
        Tarifa__c nueva = new Tarifa__c();
        insert nueva;
        Tarifa__c escalonamiento= new Tarifa__c(TipoCargo__c='- Escalonamiento');
        insert escalonamiento;
        escalonamiento= new Tarifa__c(TipoCargo__c='- Escalonamiento');
        insert escalonamiento;
        TarifaOportunidad__c tarifa1= new TarifaOportunidad__c(  Producto__c=producto.Id, Importe__c=12.3, Porcentaje__c=0.2, Observaciones__c='Ninfuna',TipoCargo__c='21', TipoSolucion__c='21',Uso__c='213;21',Oportunidad__c=opp.Id,Tarifa__c=nueva.Id ,ClaveReferencia__c='1231');         
        insert tarifa1; 
        BonificacionEscalonamiento__c nuevaBonificacion = new BonificacionEscalonamiento__c(TarifaOportunidad__C=tarifa1.Id,ValorPorcentual__c=0.4);
        upsert nuevaBonificacion;
    }
	
}