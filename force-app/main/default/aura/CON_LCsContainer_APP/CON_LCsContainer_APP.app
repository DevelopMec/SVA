<aura:application access="GLOBAL" extends="ltng:outApp">
	
	<!-- <aura:dependency resource="ui:button"/> -->
	<aura:dependency resource="c:CON_ValidationChecklist_LC"/>
	<aura:dependency resource="c:CON_ContractsContainer_LC"/>
	<aura:dependency resource="c:CON_DownloadUploadLayout_LC"/>
	<aura:dependency resource="c:CON_MessageForCC_EVENT"/>
	<aura:dependency resource="c:CON_GeneratePDF_EVENT"/>
	<aura:dependency resource="c:CON_CreateDatepicker_EVENT"/>
	<aura:dependency resource="c:CON_InvokeSaveMethod_EVENT"/>
	<!-- <aura:dependency resource="c:CON_ComponenteBase_LC"/> -->
	<aura:dependency resource="c:CON_FileReady_EVENT"/>
	<aura:dependency resource="markup://force:*" type="EVENT"/>
	
</aura:application>