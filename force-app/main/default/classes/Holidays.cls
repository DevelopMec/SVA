public class Holidays
{
    public BusinessHours bHours;
    /**
     * Constructor para establecer el horario comercial
     * */
    public Holidays(String businessHoursName){      
        bHours = [SELECT Id FROM BusinessHours WHERE Name =: businessHoursName];
    }
    public Holidays(){
        bHours = [SELECT Id FROM BusinessHours WHERE IsDefault = true];
    }
    
    /**
    Agregar número de días hábiles en una fecha
     * */
    public Datetime addDays(Datetime startDate, Integer days)
    {
        startDate = BusinessHours.nextStartDate(bHours.Id, startDate);
		
        for (Integer elapsed = 0; elapsed < days; elapsed++)
        {
            startDate = startDate.addDays(1);
            
            if (!BusinessHours.isWithin(bHours.Id, startDate))
            { 
                startDate = BusinessHours.nextStartDate(bHours.Id, startDate);
            }
        }
        return startDate;
    }
    
    /**
     Resta el número de días hábiles en una fecha
     * */
    public Datetime subtractDays(Datetime startDate, Integer days)
    {
        startDate = getPreviousWorkingDay(startDate);
        for (Integer elapsed = 0; elapsed < days; elapsed++)
        {
            startDate = startDate.addDays(-1);
            if (!BusinessHours.isWithin(bHours.Id, startDate))
            { 
            	startDate = getPreviousWorkingDay(startDate);
            }
        }
        return startDate;
    }
    
    /**
      //Si la fecha que pasó a la función es domingo, regresará un vierner
     * */
    public Datetime getPreviousWorkingDay(Datetime d){
        
        if (!BusinessHours.isWithin(bHours.Id, d))
        {
            
            d = d.addDays(-1);
            return getPreviousWorkingDay(d);
        } else{
            return d;
        }
    }
//  Si el día que pasa es lunes, regresará un lunes  
  // Si el día que pasa es domingo, regresará un lunes
    public Datetime getNextWorkingDay(Datetime d){
        return BusinessHours.nextStartDate(bHours.Id, d);
    }
    
    //Se comprueba si la fecha agregada es día laboral o no
    public Boolean isWorkingDay(Datetime d){
        return BusinessHours.isWithin(bHours.Id, d);
    }
    
    //Obtener el número de días entre dos fechas 
    public Integer getNoOfBusinessDaysBetweenDates(DateTime startDate, DateTime endDate){
        Integer count = 0;
        while(startDate <= endDate){
            if(BusinessHours.isWithin(bHours.Id, startDate)){
                count++;
            }
            startDate = startDate.addDays(1);
        }
        return count;
    }
}