public  with sharing class WorkDays {
    
    public static string getWorkDays(Datetime initialDay, Datetime finishDay){
        String strRetunValue='';
        Integer workDays=0;
        Set<Date> holidays = new Set<Date>();
        Date tempDate = date.newinstance( initialDay.year(),initialDay.month(),initialDay.day());
        Date finish = date.newinstance( finishDay.year(),finishDay.month(),finishDay.day());
        Integer days = tempDate.daysBetween(finish);
        Integer hour = finishDay.hour() - initialDay.hour();
        Integer minutes = finishDay.minute() - initialDay.minute();
        
        system.debug('**DAYS : ' + days);
        system.debug('**HOURS : ' +hour+ '  ***MINUTES :  '+minutes);
        system.debug('TEMPDATE : '+initialDay.format('E'));

        for(Holiday objholidays : [SELECT ActivityDate FROM Holiday ]){
            holidays.add(objholidays.ActivityDate);
        }
        system.debug('holidays ');
        System.debug(holidays);
        
        for(integer x=0; tempDate <= finish; x++){
            if(!holidays.contains(tempDate) && initialDay.format('E') != 'Sat' && initialDay.format('E') != 'Sun'){
                system.debug('tempDateFOR NO CONTIENE SET : '+ tempDate);
                workDays++;
            }
           
            tempDate = tempDate.addDays(1);
            initialDay = initialDay.addDays(1);
            system.debug('tempDateSA_BADO O DOMINGO O SI CONTIENE SET  : '+ tempDate);    
            
        }
        system.debug('workDays :'+'Dias: '+String.valueOf(workDays)+ ' Hour: '+hour+ ' Minutos: '+minutes);
        strRetunValue = String.valueOf(workDays)+' Dias, '+hour+ ' Horas, '+minutes+ ' Minutos';
        return strRetunValue.replace('-','');
    }
}