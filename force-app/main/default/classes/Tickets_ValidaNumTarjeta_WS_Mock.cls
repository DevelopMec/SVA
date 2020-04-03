@isTest
global class Tickets_ValidaNumTarjeta_WS_Mock implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest req){  
            System.debug('Entro Mock');
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"card": {"product_identifier": 12,"number": "1234567890123456","serial": "","status": "NonRegistered","is_additional": false,"account": "","account_status": "Inactive","available_balance": 1.23,"reference": "","is_balance_hidden": false,"balance_type": "Money","tag_identifier": "","token_type": "PhysicCard","technology_type_identifier": "None"},"security": {"application_identifier": "E0AED02F-A2D2-4673-840A-031FE7DE8DFE","user_name": "GESTION_USUARIOS","end_user_identifier": "GESTION_USUARIOS","end_user_ip": "1.1.1.1"}}');
            res.setStatus('OK');
            res.setStatusCode(200);
            return res;
        }
    }