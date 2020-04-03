/** * @CAMBIOS
		* @Cindy Hernández
		* @date 31/01/2020
		* @description Se comentó el método updateEventTest3 porque ya no se realiza una actualización del evento cuando está como 'Finalizado'.
	*/
@isTest
private class CheckInCheckOut_TEST {
	
	@isTest
	static void getUIThemeTest() {
		String userUITheme = CheckInCheckOut_CTRL.getUITheme();
		// System.assert();
	}
	
	@isTest
    static void getUserInfoTest() {
		User u = (User)CheckInCheckOut_CTRL.getUserInfo(UserInfo.getUserId());
		// System.assert();
	}
	
	@isTest
    static void saveStartLocationTest() {
		Event e = TestDataFactory_TEST.createEvent();
		Map<String, Object> el = new Map<String, Object>();
		el.put('Id', e.Id);
		el.put('UbicacionInicio__Latitude__s', 0.0);
		el.put('UbicacionInicio__Longitude__s', 0.0);
		Map<String, Object> ue = CheckInCheckOut_CTRL.saveStartLocation(el);
		System.assertEquals(el, ue);
    }
	
	@isTest
    static void saveEndLocationTest() {
		Event e = TestDataFactory_TEST.createEvent();
		Map<String, Object> el = new Map<String, Object>();
		el.put('Id', e.Id);
		el.put('UbicacionFin__Latitude__s', 0.0);
		el.put('UbicacionFin__Longitude__s', 0.0);
		Map<String, Object> ue = CheckInCheckOut_CTRL.saveEndLocation(el);
		System.assertEquals(el, ue);
	}
	
	@isTest
    static void getEventInformationTest() {
		Event e = TestDataFactory_TEST.createEvent();
		Event ei = CheckInCheckOut_CTRL.getEventInformation(e.Id);
	}
	
	@isTest
    static void getTodayDateTest() {
		System.assertEquals(System.today(), CheckInCheckOut_CTRL.getTodayDate());
	}
	
	@isTest
    static void updateEventTest1() {
		Event e = TestDataFactory_TEST.createEvent();
		Event ue = CheckInCheckOut_CTRL.updateEvent(e.Id, 'Planeado', 'startAddress', '', '', '', '');
	}
	
	@isTest
    static void updateEventTest2() {
		Event e = TestDataFactory_TEST.createEvent();
		Event ue = CheckInCheckOut_CTRL.updateEvent(e.Id, 'Iniciado', '', 'endAddress', '', '', '');
	}
	
	/*@isTest
    static void updateEventTest3() {
		Event e = TestDataFactory_TEST.createEvent();
		Event ue = CheckInCheckOut_CTRL.updateEvent(e.Id, 'Finalizado', '', '', 'assessment', 'assessmentOptions', 'assessmentComment');
	}*/
	
	@isTest
    static void getComentariosValoracionOptionsTest() {
		Map<String, Object> mapCvo = CheckInCheckOut_CTRL.getComentariosValoracionOptions();
	}
}