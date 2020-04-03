public class Utils {
    public static String removeCaracteres(String input) {
        // Cadena de caracteres original a sustituir.
        List<String> original = new List<String>{'á','à','ä','é','è','ë','í','ì','ï','ó','ò','ö','ú','ù','u','ñ','Á','À','Ä','É','È','Ë','Í','Ì','Ï','Ó','Ò','Ö','Ú','Ù','Ü','Ñ','ç','Ç'};
        // Cadena de caracteres ASCII que reemplazarán los originales.
         List<String>  ascii = new List<String> {'a','a','a','e','e','e','i','i','i','o','o','o','u','u','u','n','A','A','A','E','E','E','I','I','I','O','O','O','U','U','U','N','c','C'};
        String output = input;
        for (Integer i=0; i<original.size(); i++) {
            // Reemplazamos los caracteres especiales.
            output = output.replaceAll( original[i] , ascii[i] );
        }//for i
        return output;
    }
    
    public static String OBTENER_NOMBRETARIFA(String producto,String referencia){
        String nombre;
        lIST<Tarifa__c> tarifita;
        try{
        	tarifita= Database.query('SELECT '+String.join(new List<String>(SObjectType.Tarifa__c.Fields.getMap().keySet()), ', ')+' FROM Tarifa__c where CodigoProducto__c =: producto AND ClaveReferencia__c =: referencia ');
        }catch(Exception e){
            
           tarifita= new lIST<Tarifa__c>();
        }
        if(tarifita.size()>1){
            String uno = tarifita[0].TipoCargo__c;
            uno= uno.replaceAll(' ','');
            String dos = tarifita[1].TipoCargo__c;
            dos= dos.replaceAll(' ','');
            Integer i;
            for( i =0;(uno.subString(0,i)).equals(dos.substring(0,i)) && i< uno.length() && i<dos.length();i++);
			nombre= uno.substring(0,i-1);
	            
        }else{
            nombre= tarifita[0].TipoCargo__c;
            
        }
          return nombre == null ? 'Tarifa':nombre.replaceAll(' ','').replaceAll('-','');
       
    }
    public static Tarifa__c OBTENER_TARIFA(String producto,String referencia,String tipoCargo){
        
        Tarifa__c tarifita;
        try{
        	tarifita= Database.query('SELECT '+String.join(new List<String>(SObjectType.Tarifa__c.Fields.getMap().keySet()), ', ')+' FROM Tarifa__c where CodigoProducto__c =: producto AND ClaveReferencia__c =: referencia AND TipoCargo__c =: tipoCargo Limit 1');
        }catch(Exception e){
            
           tarifita= new Tarifa__c();
        }
          return tarifita;
       
    }
    
    public static Map<String,String> MAP_GIRO{
        get{
            if(MAP_GIRO==null){
                MAP_GIRO = new map<String,String>();
                for(catalogo__c cat: [SELECT Id, Name, Clave__c, Tipo__c, Descripcion__c FROM catalogo__c WHERE Tipo__c='Giro']){
                    MAP_GIRO.put( cat.Descripcion__c,cat.Clave__c);
                }
            }
            return MAP_GIRO;
        }set;
    }
    
    public static Map<String,String> MAP_SECTOR{
        get{
            if(MAP_SECTOR==null){
                MAP_SECTOR = new map<String,String>();
                for(catalogo__c cat: [SELECT Id, Name, Clave__c, Tipo__c, Descripcion__c FROM catalogo__c WHERE Tipo__c='Sector']){
                    MAP_SECTOR.put( cat.Descripcion__c,cat.Clave__c);
                }
            }
            return MAP_SECTOR;
        }set;
    }
    public static Map<String,String> MAP_ESTADOCLAVE{
        get{
            if(MAP_ESTADOCLAVE==null){
                MAP_ESTADOCLAVE = new map<String,String>();
                for(catalogo__c cat: [SELECT Id, Name, Clave__c, Tipo__c, Descripcion__c FROM catalogo__c WHERE Tipo__c='Estado']){
                    MAP_ESTADOCLAVE.put( cat.Descripcion__c,cat.Clave__c);
                }
            }
            return MAP_ESTADOCLAVE;
        }set;
    }
    public static Map<String,String> MAP_ESTADOCLAVEDOS{
        get{
            if(MAP_ESTADOCLAVEDOS==null){
                MAP_ESTADOCLAVEDOS = new map<String,String>();
                for(catalogo__c cat: [SELECT Id, Name, Clave__c,Clave2__c, Tipo__c, Descripcion__c FROM catalogo__c WHERE Tipo__c='Estado']){
                    MAP_ESTADOCLAVEDOS.put( cat.Descripcion__c,cat.Clave2__c);
                }
            }
            return MAP_ESTADOCLAVEDOS;
        }set;
    }
    public static Map<String,String> MAP_ESTADO{
        get{
            if(MAP_ESTADO==null){
                MAP_ESTADO = new map<String,String>();
                for(catalogo__c cat: [SELECT Id, Name, Clave__c, Tipo__c, Descripcion__c FROM catalogo__c WHERE Tipo__c='Estado']){
                    MAP_ESTADO.put( cat.Descripcion__c,cat.Clave__c);
                }
            }
            return MAP_ESTADO;
        }set;
    }
    public static Map<String,String> MAP_SUCURSAL{
        get{
            if(MAP_SUCURSAL==null){
                MAP_SUCURSAL = new map<String,String>();
                for(catalogo__c cat: [SELECT Id, Name, Clave__c, Tipo__c, Descripcion__c FROM catalogo__c WHERE Tipo__c='Sucursal']){
                    MAP_SUCURSAL.put( cat.Clave__c,cat.Descripcion__c);
                }
            }
            return MAP_SUCURSAL;
        }set;
    }
    public static Map<String,String> MAP_ORIGENVENTA{
        get{
            if(MAP_ORIGENVENTA==null){
                MAP_ORIGENVENTA = new map<String,String>();
                for(catalogo__c cat: [SELECT Id, Name, Clave__c, Tipo__c, Descripcion__c FROM catalogo__c WHERE Tipo__c='Origen de Venta']){
                    MAP_ORIGENVENTA.put( cat.Clave__c,cat.Descripcion__c);
                }
            }
            return MAP_ORIGENVENTA;
        }set;
    }
    public static Map<String,String> MAP_COMPETIDOR{
        get{
            if(MAP_COMPETIDOR==null){
                MAP_COMPETIDOR = new map<String,String>();
                for(catalogo__c cat: [SELECT Id, Name, Clave__c, Tipo__c, Descripcion__c FROM catalogo__c WHERE Tipo__c='Competidor']){
                    MAP_COMPETIDOR.put( cat.Clave__c,cat.Descripcion__c);
                }
            }
            return MAP_COMPETIDOR;
        }set;
    }
    
    //   Modificacion maquila 20/12/2016
        public static Map<String,String> MAP_MAQUILA{
        get{
            if(MAP_MAQUILA==null){
                MAP_MAQUILA = new map<String,String>();
                for(catalogo__c cat: [SELECT Id, Name, Clave__c, Tipo__c, Descripcion__c FROM catalogo__c WHERE Tipo__c='Maquila']){
                    MAP_MAQUILA.put( cat.Clave__c,cat.Descripcion__c);
                }
            }
            return MAP_MAQUILA;
        }set;
    }
    
    //   Modificacion maquila 20/12/2016
    
    public static Map<String,String> MAP_TIPOPAGO{
        get{
            if(MAP_TIPOPAGO==null){
                MAP_TIPOPAGO = new map<String,String>();
                for(Catalogo__c cat: [SELECT Id, Name, Clave__c, Tipo__c, Descripcion__c FROM catalogo__c WHERE Tipo__c='Tipo de Pago']){
                    MAP_TIPOPAGO.put( cat.Clave__c,cat.Descripcion__c);
                }
            }
            return MAP_TIPOPAGO;
        }set;
    }
    public static Map<String,String> MAP_MEDIOPAGO{
        get{
            if(MAP_MEDIOPAGO==null){
                MAP_MEDIOPAGO = new map<String,String>();
                for(Catalogo__c cat: [SELECT Id, Name, Clave__c, Tipo__c, Descripcion__c FROM catalogo__c WHERE Tipo__c='Medio de pago']){
                    MAP_MEDIOPAGO.put( cat.Clave__c,cat.Descripcion__c);
                }
            }
            return MAP_MEDIOPAGO;
        }set;
    }
    public static Map<String,String> MAP_FRECUENCIALIBERACIONAUTOMATICA{
        get{
            if(MAP_FRECUENCIALIBERACIONAUTOMATICA==null){
                MAP_FRECUENCIALIBERACIONAUTOMATICA = new map<String,String>();
                for(Catalogo__c cat: [SELECT Id, Name, Clave__c, Tipo__c, Descripcion__c FROM catalogo__c WHERE Tipo__c='Frecuencia de liberación automática']){
                    MAP_FRECUENCIALIBERACIONAUTOMATICA.put( cat.Clave__c,cat.Descripcion__c);
                }
            }
            return MAP_FRECUENCIALIBERACIONAUTOMATICA;
        }set;
    }
    public static Map<String,String> MAP_TIPOFACTURACION{
        get{if(MAP_TIPOFACTURACION==null){
            MAP_TIPOFACTURACION = new map<String,String>();
            for(Catalogo__c cat: [SELECT Id, Name, Clave__c, Tipo__c, Descripcion__c FROM catalogo__c WHERE Tipo__c='Tipo de facturación']){
                MAP_TIPOFACTURACION.put( cat.Clave__c,cat.Descripcion__c);
            }
        }
            return MAP_TIPOFACTURACION;
           }set;
    } 
    public static Map<String,String> MAP_FRECUENCIAFACTURACION{
        get{
            if(MAP_FRECUENCIAFACTURACION==null){
                MAP_FRECUENCIAFACTURACION = new map<String,String>();
                for(Catalogo__c cat: [SELECT Id, Name, Clave__c, Tipo__c, Descripcion__c FROM catalogo__c WHERE Tipo__c='Frecuencia de Facturación']){
                    MAP_FRECUENCIAFACTURACION.put( cat.Clave__c,cat.Descripcion__c);
                }
            }
            return MAP_FRECUENCIAFACTURACION;
        }set;
    }
    public static Map<String,String> MAP_COMOFACTURA{
        get{
            if(MAP_COMOFACTURA==null){
                MAP_COMOFACTURA = new map<String,String>();
                for(Catalogo__c cat: [SELECT Id, Name, Clave__c, Tipo__c, Descripcion__c FROM catalogo__c WHERE Tipo__c='Cómo factura']){
                    MAP_COMOFACTURA.put( cat.Clave__c,cat.Descripcion__c);
                }
            }
            return MAP_COMOFACTURA;
        }set;
    }
    public static Map<String,String> MAP_TIPOCLIENTE{
        get{
            if(MAP_TIPOCLIENTE==null){
                MAP_TIPOCLIENTE = new map<String,String>();
                for(Catalogo__c cat: [SELECT Id, Name, Clave__c, Tipo__c, Descripcion__c FROM catalogo__c WHERE Tipo__c='Tipo de Cliente']){
                    MAP_TIPOCLIENTE.put( cat.Clave__c,cat.Descripcion__c);
                }
            }
            return MAP_TIPOCLIENTE;
        }set;
    }
    public static Map<String,String> MAP_FACTURACIONCOMISION{
        get{
            if(MAP_FACTURACIONCOMISION==null){
                MAP_FACTURACIONCOMISION = new map<String,String>();
                for(Catalogo__c cat: [SELECT Id, Name, Clave__c, Tipo__c, Descripcion__c FROM catalogo__c WHERE Tipo__c='Facturación Comisión']){
                    MAP_FACTURACIONCOMISION.put( cat.Clave__c,cat.Descripcion__c);
                }
            }
            return MAP_FACTURACIONCOMISION;
        }set;
    }
    public static Map<String,String> MAP_FACTURACIONPLASTICO{
        get{
            if(MAP_FACTURACIONPLASTICO==null){
                MAP_FACTURACIONPLASTICO = new map<String,String>();
                for(Catalogo__c cat: [SELECT Id, Name, Clave__c, Tipo__c, Descripcion__c FROM catalogo__c WHERE Tipo__c='Facturación Plástico']){
                    MAP_FACTURACIONPLASTICO.put( cat.Clave__c,cat.Descripcion__c);
                }
            }
            return MAP_FACTURACIONPLASTICO;
        }set;
    }
    public static Map<String,String> MAP_ITEMCONTRATACION{
        get{
            if(MAP_ITEMCONTRATACION==null){
                MAP_ITEMCONTRATACION = new map<String,String>();
                for(Catalogo__c cat: [SELECT Id, Name, Clave__c, Tipo__c, Descripcion__c FROM catalogo__c WHERE Tipo__c='Item de contratación']){
                    MAP_ITEMCONTRATACION.put( cat.Clave__c,cat.Descripcion__c);
                }
            }
            return MAP_ITEMCONTRATACION;
        }set;
    }
    public static Map<String,String> MAP_PUESTO{
        get{
            if(MAP_PUESTO==null){
                MAP_PUESTO = new map<String,String>();
                for(Catalogo__c cat: [SELECT Id, Name, Clave__c, Tipo__c, Descripcion__c FROM catalogo__c WHERE Tipo__c='Puesto']){
                    MAP_PUESTO.put( cat.Clave__c,cat.Descripcion__c);
                }
            }
            return MAP_PUESTO;
        }set;
    }
    //--
    
    
    public static Map<String,String> MAP_FACTURACIONCARGOS{
        get{
            if(MAP_FACTURACIONCARGOS == null){
                MAP_FACTURACIONCARGOS = new Map<String,String>();
                for(Catalogo__c cat: [SELECT Id, Name, Clave__c, Tipo__c, Descripcion__c FROM catalogo__c WHERE Tipo__c='Facturación Cargos']){
                    MAP_FACTURACIONCARGOS.put(cat.Clave__c,cat.Descripcion__c);
                }
            }
            return MAP_FACTURACIONCARGOS;
        }
    }
                
    
    
    public static Map<String,String> MAP_MANEJA{
        get{
            if(MAP_MANEJA == null){
                MAP_MANEJA = new Map<String,String>();
                for(Catalogo__c cat: [SELECT Id, Name, Clave__c, Tipo__c, Descripcion__c FROM catalogo__c WHERE Tipo__c='Maneja']){
                    MAP_MANEJA.put(cat.Clave__c,cat.Descripcion__c);
                }
            }
            return MAP_MANEJA;
        }set;
    }
    public static Map<String,String> MAP_RED{
        get{
            if(MAP_RED == null){
                MAP_RED = new Map<String,String>();
                for(Catalogo__c cat: [SELECT Id, Name, Clave__c, Tipo__c, Descripcion__c FROM catalogo__c WHERE Tipo__c='Red']){
                    MAP_RED.put(cat.Clave__c,cat.Descripcion__c);
                }
            }
            return MAP_RED;
        }set;
    }
    public static Map<String,String> MAP_OPERACIONMODOOFFLINE{
        get{
            if(MAP_OPERACIONMODOOFFLINE == null){
                MAP_OPERACIONMODOOFFLINE = new Map<String,String>();
                for(Catalogo__c cat: [SELECT Id, Name, Clave__c, Tipo__c, Descripcion__c FROM catalogo__c WHERE Tipo__c='Operación modo offline']){
                    MAP_OPERACIONMODOOFFLINE.put(cat.Clave__c,cat.Descripcion__c);
                }
            }
            return MAP_OPERACIONMODOOFFLINE;
        }set;
    }
    public static Map<String,String> MAP_DESCRIPCIONLINEAIMPRESION{
        get{
            if(MAP_DESCRIPCIONLINEAIMPRESION == null){
                MAP_DESCRIPCIONLINEAIMPRESION = new Map<String,String>();
                for(Catalogo__c cat: [SELECT Id, Name, Clave__c, Tipo__c, Descripcion__c FROM catalogo__c WHERE Tipo__c='Descripción línea de Impresión']){
                    MAP_DESCRIPCIONLINEAIMPRESION.put(cat.Clave__c,cat.Descripcion__c);
                }
            }
            return MAP_DESCRIPCIONLINEAIMPRESION;
        }set;
    }
    public static Map<String,String> MAP_FINANCIAMIENTO{
        get{
            if(MAP_FINANCIAMIENTO == null){
                MAP_FINANCIAMIENTO = new Map<String,String>();
                for(Catalogo__c cat: [SELECT Id, Name, Clave__c, Tipo__c, Descripcion__c FROM catalogo__c WHERE Tipo__c='Financiamiento']){
                    MAP_FINANCIAMIENTO.put(cat.Clave__c,cat.Descripcion__c);
                }
            }
            return MAP_FINANCIAMIENTO;
        }set;
    }
    public static Map<String,String> MAP_TIPOFINANCIAMIENTO{
        get{
            if(MAP_TIPOFINANCIAMIENTO == null){
                MAP_TIPOFINANCIAMIENTO = new Map<String,String>();
                for(Catalogo__c cat: [SELECT Id, Name, Clave__c, Tipo__c, Descripcion__c FROM catalogo__c WHERE Tipo__c='Tipo financiamiento']){
                    MAP_TIPOFINANCIAMIENTO.put(cat.Clave__c,cat.Descripcion__c);
                }
            }
            return MAP_TIPOFINANCIAMIENTO;
        }set;
    }
    public static Map<String,String> MAP_TIPOPLASTICOTARJETAFINANCIERA{
        get{
            if(MAP_TIPOPLASTICOTARJETAFINANCIERA == null){
                MAP_TIPOPLASTICOTARJETAFINANCIERA = new Map<String,String>();
                for(Catalogo__c cat: [SELECT Id, Name, Clave__c, Tipo__c, Descripcion__c FROM catalogo__c WHERE Tipo__c='Tipo plástico (Tarjeta Financiera)']){
                    MAP_TIPOPLASTICOTARJETAFINANCIERA.put(cat.Clave__c,cat.Descripcion__c);
                }
            }
            return MAP_TIPOPLASTICOTARJETAFINANCIERA;
        }set;
    }
    public static Map<String,String> MAP_TIPOPLASTICOTARJETASTOCK{
        get{
            if(MAP_TIPOPLASTICOTARJETASTOCK == null){
                MAP_TIPOPLASTICOTARJETASTOCK = new Map<String,String>();
                for(Catalogo__c cat: [SELECT Id, Name, Clave__c, Tipo__c, Descripcion__c FROM catalogo__c WHERE Tipo__c='Tipo plástico (Tarjeta Stock)']){
                    MAP_TIPOPLASTICOTARJETASTOCK.put(cat.Clave__c,cat.Descripcion__c);
                }
            }
            return MAP_TIPOPLASTICOTARJETASTOCK;
        }set;
    }
    
    
    public static List<SelectOption> obtenerCatalogo(String Campo){ 
	 	List<SelectOption> catalogo=new List<SelectOption>();
         catalogo.add(new SelectOption('',''));
        for(catalogo__c cat: [SELECT Id, Name, Clave__c, Tipo__c, Descripcion__c FROM catalogo__c WHERE Tipo__c=:Campo]){
            catalogo.add(new SelectOption(cat.Clave__c,cat.Descripcion__c));
        }
        return catalogo;
	 }
    
    public static String obtenerNombreObjeto(String idObjeto){
		String objectAPIName = '';
		if(idObjeto != null  && idObjeto != ''){
			Id idConvertido  = Id.valueOf (idObjeto);
			objectAPIName = idConvertido.getSObjectType().getDescribe().getName();
		}
		return objectAPIName;
	}
    
     
}