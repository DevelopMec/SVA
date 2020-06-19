public  with sharing class WorkDays {
     
    public static string getWorkDays(Datetime initialDay, Datetime finishDay){        
        Integer intMinute59 = 0;
        Integer minutes = 0;
        Integer hour = 0;


        String strRetunValue='';
        Integer workDays = 0;
        Set<Date> holidays = new Set<Date>();
        Date tempDate = date.newinstance( initialDay.year(),initialDay.month(),initialDay.day());
        Date finish = date.newinstance( finishDay.year(),finishDay.month(),finishDay.day());
        Integer days = tempDate.daysBetween(finish);
        hour = finishDay.hour() - initialDay.hour();
       System.debug('***hour : ' + hour);
        
       if(hour > 0 && initialDay.minute() < 60 ){
            System.debug('*************ENTRO 1111');
            intMinute59 = 60 - initialDay.minute();
            minutes =  finishDay.minute()  + intMinute59;
            hour = finishDay.hour() - initialDay.hour() -1 ;            
        }else{
            System.debug('*************ENTRO 22');
            hour = finishDay.hour() - initialDay.hour(); 
            minutes = finishDay.minute() - initialDay.minute();
        }

        if(minutes >= 60){
            System.debug('*************ENTRO 33');
            hour = finishDay.hour() - initialDay.hour(); 
            minutes = finishDay.minute() - initialDay.minute();
        }

        system.debug('**DAYS : ' + days);
        system.debug('**HOURS : ' +hour+ '  ***MINUTES :  '+minutes);
        system.debug('TEMPDATE : '+initialDay.format('E'));

        for(Holiday objholidays : [SELECT ActivityDate FROM Holiday ]){
            holidays.add(objholidays.ActivityDate);
        }   
        for(integer x=0; tempDate.addDays(1) <= finish; x++){
            if(!holidays.contains(tempDate) && initialDay.format('E') != 'Sat' && initialDay.format('E') != 'Sun'){
                if(days > 0 ){
                    workDays++;
                }         
            }
           
            tempDate = tempDate.addDays(1);
            initialDay = initialDay.addDays(1);            
        }
        System.debug('workDays :'+'Dias: '+String.valueOf(workDays)+ ' Hour: '+hour+ ' Minutos: '+minutes);
        strRetunValue = String.valueOf(workDays)+' Dias, '+hour+ ' Horas, '+minutes+ ' Minutos';
        return strRetunValue.replace('-','');
    }
}