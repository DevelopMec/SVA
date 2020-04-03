trigger TriggerDuplicateRecordItem on DuplicateRecordItem (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
	
	/**
		* @author: Carlos Álvarez
		* @description: Controlador que actualiza un Lead duplicado, aplicando reglas de asignación
		* @date: 15-02-2017
	*/
    new TriggerDuplicateRecordItemHandler().run();
    
}