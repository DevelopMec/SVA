@isTest
global class AltaCliente_WS_Mock implements HttpCalloutMock {    
    public Integer indicador{get;set;}    
    public AltaCliente_WS_Mock(Integer ind){
        this.indicador=ind;
    }
    global HTTPResponse respond(HTTPRequest req){
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        if(indicador==1){
            res.setBody('{ "meta": { "status": "failed", "messages": [ { "text": "KETIPO: CONTACTO KENSEQ: 0 KENFOL: 217570 DESERR: Cliente: 001-030-16474-682 Ya fue dado de alta anteriormente ", "code": "AS400", "level": "error" }, { "text": "Message: CodigoEspada: 00116474682-3 ErrorCode:01", "code": "AS400", "level": "error" } ] }, "data": { "folio": "104", "process_date": "/Date(1570821029687)/", "espada_code": "00116474682-3", "user_ref": "*AN1" } }');
        }else if(indicador==2){
            res.setBody('{ "meta": { "status": "succeeded", "messages": [ ] }, "data": { "folio": "104", "process_date": "/Date(1570821029687)/", "espada_code": "00116474682-3", "user_ref": "*AN1" } }');
        }else if(indicador==3){
            res.setBody('{ "access_token": "eyJhbGciOiJSUzI1NiIsImtpZCI6IjUyQkMzREMwQUM2NkRCREYyOTMzNzk3NjFBRjQzMjM3MkIxNDVFNjYiLCJ0eXAiOiJKV1QiLCJ4NXQiOiJVcnc5d0t4bTI5OHBNM2wyR3ZReU55c1VYbVkifQ.eyJuYmYiOjE1NzA4MTkyOTcsImV4cCI6MTU3MDgyMjg5NywiaXNzIjoiaHR0cDovLzE3Mi4xNi4xNDIuMjg6ODAvaWRzcHJvdmlkZXIiLCJhdWQiOlsiaHR0cDovLzE3Mi4xNi4xNDIuMjg6ODAvaWRzcHJvdmlkZXIvcmVzb3VyY2VzIiwiaGFuYS5teC5mbGVldCJdLCJjbGllbnRfaWQiOiIzODAiLCJzY29wZSI6WyJoYW5hLm14LmZsZWV0Il19.oGyb0ggU9XoJ5jBbusLSeE_zCelYg3n3cIcVWii-4TxiFXtBuSMZolkR9LeEGCySYkBw4XnVoh1dAGcmV2l5hf9BSNLktozjYXtRimQjIJC7UVzlE3Yx6IP16qRqLvlgkS73VETjoi5NEuVDL_cWWmrQiggGfl7an5sK43FSuS53DZewL1F_zyUvwFHRGeJfLyWqBENfV7DjqpW659BWJAU2ZSf9zfesI3tvb9jkZX5KNI907fJoMLIGJwxgtEo6Jt5fpjRqqlNoaKT9yXA86kbqZVKqH3uN4IBA3oKHK9LEyyshpHmZ0q7KhWV4PsnSS83s7AzbJJCOXCaHNKAYpw", "expires_in": 3600, "token_type": "Bearer" }');
        }
        res.setStatusCode(200);
        return res;
    }
}