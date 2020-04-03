({
	doInit : function(component, event, helper) {
		helper.IniciarComponente(component, event);
	},
    editarInfo : function(component, event, helper) {
		component.set("v.editar",!component.get("v.editar"));
        helper.IniciarComponente(component, event);
	}
})