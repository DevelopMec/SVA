@isTest
global class GetGruposPrime_Mock implements HttpCalloutMock {    
    public Integer indicador{get;set;}    
    public GetGruposPrime_Mock(Integer ind){
        this.indicador=ind;
    }
    global HTTPResponse respond(HTTPRequest req){
        PrimeGroupResponse_WP response=new PrimeGroupResponse_WP();
        PrimeGroupResponse_WP.metaWP me=new PrimeGroupResponse_WP.metaWP();
        PrimeGroupResponse_WP.dataWP dat=new PrimeGroupResponse_WP.dataWP();
        List<PrimeGroupResponse_WP.messageWP> lisMe=new List<PrimeGroupResponse_WP.messageWP>();
        PrimeGroupResponse_WP.messageWP mess=new PrimeGroupResponse_WP.messageWP();
        mess.code='1';
        mess.description='test';
        mess.level='1';
        lisMe.add(mess);
        me.messages=lisMe;
        
        PrimeGroupResponse_WP.primeGroupWP pg=new PrimeGroupResponse_WP.primeGroupWP();
        pg.client_identifier=1;
        pg.group_identifier=1;
        pg.prime_identifier=1;
        pg.prime_name='test';
        pg.product_identifier=1;
        pg.sucursal_identifier=1;
        
        List<PrimeGroupResponse_WP.primeGroupWP> listPg=new List<PrimeGroupResponse_WP.primeGroupWP>{pg};
        dat.group_prime_list=listPg;
            
        response.meta=me;
        response.data=dat;
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        if(indicador==1){//failed
            me.status='failed';
            res.setStatusCode(404);
            res.setBody(JSON.serialize(response));
        }else if(indicador==2){//success
            me.status='success';
            res.setStatusCode(200);
            res.setBody(JSON.serialize(response));
        }else if(indicador==3){//token
            res.setBody('{ "access_token": "123457", "expires_in": 3600, "token_type": "Bearer" }');
        }        
        return res;
    }
}