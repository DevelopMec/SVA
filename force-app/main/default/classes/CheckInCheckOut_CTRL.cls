public with sharing class CheckInCheckOut_CTRL {

	/**
		* @author ibautista@ctconsulting.com.mx
		* @date 06/11/2017
		* @description Controlador de Apex del componente de lightning CheckInCheckOut_LC
	*/
    /** * @CAMBIOS
		* @Cindy Hernández
		* @date 30/01/2020
		* @description Se modifica el método updateEvent para incluir la valoración y el check out en el ‘else if’ del estatus del evento ‘Iniciado’.
	*/
	
	@AuraEnabled
	public static String getUITheme() {
		return UserInfo.getUiThemeDisplayed();
	}
	
	@AuraEnabled
	public static Object getUserInfo(Id userId) {
		User usr = [SELECT Segmento__c, Profile.Name FROM User WHERE Id = :userId];
		return usr;
	}
	
	@AuraEnabled
	public static Map<String, Object> saveStartLocation(Map<String, Object> eventLocation) {
		//System.debug('saveStartLocation, eventLocation.values()' + eventLocation.values());
		//System.debug('saveStartLocation, eventLocation.get(\'Id\')' + eventLocation.get('Id'));
		//System.debug('saveStartLocation, eventLocation.get(\'UbicacionInicio__Latitude__s\')' + eventLocation.get('UbicacionInicio__Latitude__s'));
		//System.debug('saveStartLocation, eventLocation.get(\'UbicacionInicio__Longitude__s\')' + eventLocation.get('UbicacionInicio__Longitude__s'));
		Event currentEvent = new Event(Id = (Id)eventLocation.get('Id'), UbicacionInicio__Latitude__s = (Double)eventLocation.get('UbicacionInicio__Latitude__s'), UbicacionInicio__Longitude__s = (Double)eventLocation.get('UbicacionInicio__Longitude__s'));
		update currentEvent;
		//System.debug('saveStartLocation, currentEvent:' + currentEvent);
		return eventLocation;
	}
	
	@AuraEnabled
	public static Map<String, Object> saveEndLocation(Map<String, Object> eventLocation) {
		//System.debug('saveEndLocation, eventLocation.values()' + eventLocation.values());
		Event currentEvent = new Event(Id = (Id)eventLocation.get('Id'), UbicacionFin__Latitude__s = (Double)eventLocation.get('UbicacionFin__Latitude__s'), UbicacionFin__Longitude__s = (Double)eventLocation.get('UbicacionFin__Longitude__s'));
		update currentEvent;
		return eventLocation;
	}
	
	@AuraEnabled
	public static Event getEventInformation(Id eventId) {
		Event currentEvent = new Event();
        currentEvent = [SELECT EstatusEvento__c, StartDateTime, Asunto__c, Who.Name, FechaHoraInicio__c, DireccionInicio__c, FechaHoraFin__c, DireccionFin__c, ValoracionCita__c, UbicacionFin__Latitude__s, UbicacionFin__Longitude__s FROM Event WHERE Id = :eventId];
		return currentEvent;
	}
	
	@AuraEnabled
	public static Date getTodayDate() {
		return System.today();
	}
	
	@AuraEnabled
	public static Event updateEvent(Id eventId, String status, String startAddress, String endAddress, String assessment, String assessmentOptions, String assessmentComment) {
		Event updatedEvent;
		//List<Event> currentEvent = [SELECT EstatusEvento__c FROM Event WHERE Id = 'eventId'];
		//String eventStatus = currentEvent[0].EstatusEvento__c;
		if (status == 'Planeado') {
			updatedEvent = new Event(Id = eventId, FechaHoraInicio__c = System.now(), EstatusEvento__c = 'Iniciado', DireccionInicio__c = startAddress);
		} else if (status == 'Iniciado') {
			updatedEvent = new Event(Id = eventId, FechaHoraFin__c = System.now(), EstatusEvento__c = 'Finalizado', DireccionFin__c = endAddress, ValoracionCita__c = assessment, ComentariosValoracion__c = assessmentOptions, Comentarios__c = assessmentComment);
		} /*else if (status == 'Finalizado') {
			updatedEvent = new Event(Id = eventId, ValoracionCita__c = assessment, ComentariosValoracion__c = assessmentOptions, Comentarios__c = assessmentComment);
		}*/
		update updatedEvent;
		return updatedEvent;
	}
	
	/*@AuraEnabled
	public static Map<String, Object> getEstatusEventoOptions() {
		Map<String, Object> mapEstatusEvento = new Map<String, Object>();
		for (Schema.PicklistEntry sPe : Event.EstatusEvento__c.getDescribe().getPicklistValues()) {
			mapEstatusEvento.put(sPe.getValue(), sPe.getLabel());
		}
		return mapEstatusEvento;
	}*/
	
	@AuraEnabled
	public static Map<String, Object> getComentariosValoracionOptions() {
		Map<String, Object> mapCVOptions = new Map<String, Object>();
		for (schema.PicklistEntry sPe : Event.ComentariosValoracion__c.getDescribe().getPicklistValues()) {
			mapCVOptions.put(sPe.getLabel(), sPe.getValue());
		}
		return mapCVOptions;
	}
}