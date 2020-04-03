public with sharing class OpportunityEditCtrl {
	/*
		* @author Carlos Álvarez
		* @description Edición de una oportunidad
	*/

	Opportunity opp {get; set;}


	public OpportunityEditCtrl(ApexPages.StandardController sctrl) {
		opp = (Opportunity) sctrl.getRecord();
	}

	public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        //options.add(new SelectOption('Activa','Activa'));
        options.add(new SelectOption('Inactiva','Inactiva'));
        return options;
    }

    public String getCurrentName() {
    	return UserInfo.getName();
    }

}