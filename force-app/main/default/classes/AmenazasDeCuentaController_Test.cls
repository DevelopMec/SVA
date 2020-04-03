@isTest
private class AmenazasDeCuentaController_Test {
    @isTest static void test_method_one() {
        
        Account acc = new Account();
        acc.Name = 'Acc Test';
        insert acc;

        Amenaza__c amenaza = new Amenaza__c();
        amenaza.Cuenta__c = acc.Id;
        amenaza.Type_of_threat__c = 'Atrición Total';
        insert amenaza;

        Case caso = new Case();
        caso.AccountId = acc.Id;
        caso.Type = 'Solicitud';        
        caso.Status = 'Abierto';
        caso.Origin = 'Web';
        caso.SuppliedName = 'Prueba';
        insert caso;

        List<Amenaza__c> listAmenazas = AmenazasDeCuentaController.getAmenazas(caso.Id);
    }
}