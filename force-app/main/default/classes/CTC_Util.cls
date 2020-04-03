global virtual with sharing class CTC_Util {
	/**
		* Método que ejecuta un determinado SOQL
		*@query Sentencia de SOQL
		*@return Lista de sObject
	*/

	@RemoteAction
    global static List<sObject> query(String query) {
        return Database.query(query);
    }

    @RemoteAction
    global static Database.QueryLocatorIterator queryLocator(String query) {
        return Database.getQueryLocator(query).iterator();
    }

    @RemoteAction
    global static Schema.DescribeSobjectResult[] describe(String[] objs) {
        return Schema.describeSObjects(objs);
    }

    /*@RemoteAction
    global static List<Schema.DescribeSobjectResult> describeById(String[] ids) {
        List<Schema.DescribeSobjectResult> ret = new List<Schema.DescribeSobjectResult>();
        Set<String> unique = new Set<String>();
        for(String obj: ids) {
            if(obj instanceOf Id && !unique.contains(obj)) {
                Schema.DescribeSobjectResult aux = Id.valueOf(obj).getSObjectType().getDescribe();
                if(!unique.contains(aux.getName())) {
                    ret.add(aux);
                    unique.add(aux.getName());
                }
                unique.add(obj);
            }
        }
        return ret;
    }*/

    /*EN PRUEBA
    @RemoteAction
    global static Map<Id, Object> getDataById(String[] ids) {
        Map<Id, Object> ret = new Map<Id, Object>();
        List<String> valids = new List<String>();
        List<String> querys = new List<String>();
        if(ids != null) {
            for(String idval: ids) {
                if(idval instanceOf Id) {
                    valids.add(idval);
                }
            }
            if(valids.size() > 0) {
                Integer index = 0;
                Map<String, String> prefix = new Map<String, String>();

                for(Schema.DescribeSobjectResult dsr : describeById(valids)) {
                    String listFields = '';
                    for(Schema.SObjectField sof : dsr.fields.getMap().values()) {
                        Schema.DescribeFieldResult dfr = sof.getDescribe();
                        if(String.valueOf(dfr.getType()) != 'ADDRESS') {
                            if(listFields.length() > 0) {
                                listFields += ', ';
                            }
                            listFields += dfr.getName();
                        }
                    }
                    prefix.put(dsr.getKeyPrefix(), 'SELECT ' + listFields + ' FROM ' + dsr.getName());
                }
                for(String valid: valids) {
                    querys.add(prefix.get(valid.substring(0, 3)) + ' WHERE Id=\'' + valid +'\'');
                }


            }
        }
        if(querys.size() <= 150) {
            for(String queryobj: querys) {
                sObject instance = query(queryobj)[0];
                ret.put(instance.Id, (Object) instance);
            }
        }
        return ret;
    }*/


    /*@RemoteAction
    global static Object describeTabs() {
        return JSON.deserializeUntyped(JSON.serialize(Schema.describeTabs()));
    }*/

    /*@RemoteAction
    global static Object describeTabsByApp(String appName) {
        Object obj = null;
        List<Schema.DescribeTabSetResult> tabSetDesc = Schema.describeTabs();
        for(Schema.DescribeTabSetResult tsr : tabSetDesc) {
            if (tsr.getLabel() == appName) {
                obj = JSON.deserializeUntyped(JSON.serialize(tsr));
            }            
        }
        return obj;
    }*/

    @RemoteAction
    global static List<Database.DeleteResult> deleteIds(String[] ids) {
        return Database.delete(ids);
    }
    
    @RemoteAction
    global static List<Database.UpsertResult> upsertObjects(String[] args) {
        Type t = Type.forName('List<'+args[0]+'>');
        List<sObject> instances = (List<sObject>) JSON.deserialize(args[1], t);
        return Database.upsert(instances);
    }

    
    @RemoteAction
    global static List<Database.UpsertResult> upsertObjectsMultiple(String[] args, Boolean allOrNot) {
        Type t = Type.forName('List<'+args[0]+'>');
        List<sObject> instances = (List<sObject>) JSON.deserialize(args[1], t);
        return Database.upsert(instances, allOrNot);
    }

    @RemoteAction
    global static List<Database.DeleteResult> deleteIdsMultiple(String[] ids, Boolean allOrNot) {
        return Database.delete(ids, allOrNot);
    }

    @RemoteAction
    global static List<Database.UpsertResult> createPDF(String[] args) {
        List<QuoteDocument> instances = new List<QuoteDocument>();
        if(args.size() > 0) {
            String url = String.isNotBlank(args[0]) ? args[0] : '';
            String quoteId = args.size() > 1 && String.isNotBlank(args[1]) ? args[1] : '';
            if(String.isNotBlank(url) && String.isNotBlank(quoteId)) {
                List<QuoteDocument> documentos = [SELECT Id, Name, QuoteId FROM QuoteDocument WHERE QuoteId =: quoteId];
                if(documentos != null && documentos.size() > 0) {
                    delete documentos;
                }

                PageReference pdf = new PageReference(url);

                if(pdf != null) {
                    if(!Test.isRunningTest()) {
                        Blob body = pdf.getContentAsPDF();
                        instances.add (new QuoteDocument(QuoteId = quoteId, Document = body));
                    }
                }

                Quote quoteAux = new Quote(Id = (Id) quoteId);
                quoteAux.ExpirationDate = System.today();
                quoteAux.ExpirationDate = quoteAux.ExpirationDate.addDays(15);
                Database.update(quoteAux);
            }
        }
        return Database.upsert(instances);
    }
}