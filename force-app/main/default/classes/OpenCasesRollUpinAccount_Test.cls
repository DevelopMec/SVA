@isTest
private class OpenCasesRollUpinAccount_Test {

    @isTest static void test_method_one() {
        
        Account acc_1 = new Account();
        acc_1.Name = 'Acc Test';
        insert acc_1;

        Account acc_2 = new Account();
        acc_2.Name = 'Acc Test 2';
        insert acc_2;

        Case caso_1 = new Case();
        caso_1.AccountId = acc_1.Id;
        caso_1.Type = 'Solicitud';      
        caso_1.Status = 'Abierto';
        caso_1.Origin = 'Web';
        caso_1.SuppliedName = 'Prueba';
        insert caso_1;

        caso_1.AccountId = acc_2.Id;
        update caso_1;

        delete caso_1;
    }
    
    @isTest static void test_method_two() {             
        Account acc_3 = new Account();
        acc_3.Name = 'Acc Test 3';
        insert acc_3;

        Case caso_3 = new Case();
        caso_3.AccountId = acc_3.Id;
        caso_3.Type = 'Solicitud';      
        caso_3.Status = 'Abierto';
        caso_3.Origin = 'Web';
        caso_3.SuppliedName = 'Prueba';
        insert caso_3;
        
        caso_3.Status = 'Concluido';
        update caso_3;
        caso_3.Status = 'Abierto';
        update caso_3;
    }
    
    @isTest static void test_method_three() {             
        Account acc_3 = new Account();
        acc_3.Name = 'Acc Test 3';
        insert acc_3;

        Case caso_4 = new Case();
        caso_4.Type = 'Solicitud';      
        caso_4.Status = 'Abierto';
        caso_4.Origin = 'Web';
        caso_4.SuppliedName = 'Prueba';
        insert caso_4;

        caso_4.AccountId = acc_3.Id;
        update caso_4;
    } 
}