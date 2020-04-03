public class ConversionNumeroTexto {
    private static final List<String> UNIDADES = new List<String>{'', 'un ', 'dos ', 'tres ', 'cuatro ', 'cinco ', 'seis ', 'siete ', 'ocho ', 'nueve '};
    private static final List<String> DECENAS  = new List<String>{'diez ', 'once ', 'doce ', 'trece ', 'catorce ', 'quince ', 'dieciseis ', 'diecisiete ', 'dieciocho ', 'diecinueve', 'veinte ', 'treinta ', 'cuarenta ', 'cincuenta ', 'sesenta ', 'setenta ', 'ochenta ', 'noventa '};
    private static final List<String> CENTENAS = new List<String>{'', 'ciento ', 'doscientos ', 'trecientos ', 'cuatrocientos ', 'quinientos ', 'seiscientos ', 'setecientos ', 'ochocientos ', 'novecientos '};
        
    public static String Convertir( String numero, String tipo){

        //Contenedor de la cadena final.
        String literal  = '';
        
        //Si el numero utiliza (.) en lugar de (,) se reemplaza
        numero = numero.replace('.', ',');
        
        //Si el numero no tiene parte decimal, se le agrega ,00
        if(numero.indexOf(',') == -1) {numero = numero + ',00';}

        
        //Si el numero en su parte decimal no contiene un cero (3.1) lo agrega (3.10)
        if(Pattern.matches('\\d{1,9},\\d{1}', numero) && tipo == 'moneda') { numero += '0'; } 

        
        //Se valida formato de entrada 0,00 y 999 999 999,00
        if (Pattern.matches('\\d{1,9},\\d{1,2}', numero)) {

            
            //Se extrae la parte entera y decimal del número en un array
            List<String> Num = numero.split(',');
            

            
            for(Integer i = 0; i <= 1; i++){

            
                if (Integer.valueOf(Num[i]) == 0) {//si el numero es cero
                    literal += 'cero ';

                } else if (Integer.valueOf(Num[i]) > 999999) {//si el numero esta en millones
                    literal += getMillones(Num[i]);
                } else if (Integer.valueOf(Num[i]) > 999) {//si el numero esta en miles
                    literal += getMiles(Num[i]);
                } else if (Integer.valueOf(Num[i]) > 99) {//si el numero esta en centenas
                    literal += getCentenas(Num[i]);
                } else if (Integer.valueOf(Num[i]) > 9) {//si el numero esta en decenas
                    literal += getDecenas(Num[i]);
                } else {//Si el numero son unidades
                    literal += getUnidades(Num[i]);
                }
                
                if(i == 0 && tipo == 'moneda') literal += ' pesos con '; //Si el numero representa moneda agrega el siguiente valor a la cadena resultado
                if(i == 0 && tipo == 'porcentaje') literal += ' punto '; //Si el numero representa porcentaje agrega el siguiente valor a la cadena resultado
            }            
            
            if(tipo == 'moneda'){ 
                literal += ' centavos';
                System.debug('LITERAL ==> ' + literal);
                return (literal).toUpperCase();
            } else {
                literal += ' porciento';
                System.debug('LITERAL ==> ' + literal);
                return (literal).toUpperCase();
            }                 
        } else {//error, no se puede convertir
            return literal = null;
        }
    }
    
    private static String getMillones(String numero) { //000 000 000        
        //se obtiene los miles
        String miles = numero.substring(numero.length() - 6);
        //se obtiene los millones
        String millon = numero.substring(0, numero.length() - 6);
        String n = '';
        if(millon.length()>1){
            n = getCentenas(millon) + 'millones ';
        }else{
            n = getUnidades(millon) + 'millon ';
        }
        return n + getMiles(miles);        
    }
    
    private static String getMiles(String numero) {// 999 999
        //obtiene las centenas
        String c = numero.substring(numero.length() - 3);
        //obtiene los miles
        String m = numero.substring(0, numero.length() - 3);
        String n='';
        //se comprueba que miles tenga valor entero
        if (Integer.valueOf(m) > 0) {
            n = getCentenas(m);           
            return n + 'mil ' + getCentenas(c);
        } else {
            return '' + getCentenas(c);
        }
    }
    
    private static String getCentenas(String num) {// 999 o 099
        if( Integer.valueOf(num)>99 ){//es centena
            if (Integer.valueOf(num) == 100) {//caso especial
                return ' cien ';
            } else {
                 return CENTENAS[Integer.valueOf(num.substring(0, 1))] + getDecenas(num.substring(1));
            } 
        }else{//por Ej. 099 
            //se quita el 0 antes de convertir a decenas
            return getDecenas(Integer.valueOf(num)+'');            
        }        
    }
    
    private static String getDecenas(String num) {// 99                        
        Integer n = Integer.valueOf(num);
        if (n < 10) {//para casos como -> 01 - 09
            return getUnidades(num);
        } else if (n > 19) {//para 20...99
            String u = getUnidades(num);
            if (u.equals('')) { //para 20,30,40,50,60,70,80,90
                return DECENAS[Integer.valueOf(num.substring(0, 1)) + 8];
            } else {
                return DECENAS[Integer.valueOf(num.substring(0, 1)) + 8] + 'y ' + u;
            }
        } else {//numeros entre 11 y 19
            return DECENAS[n - 10];
        }
    }
    
    private static String getUnidades(String numero) {// 1 - 9
        //si tuviera algun 0 antes se lo quita -> 09 = 9 o 009=9
        String num = numero.substring(numero.length() - 1);
        return UNIDADES[Integer.valueOf(num)];
    }       
}