({
    doInit : function(component, event, helper) {
        var action = component.get('c.getInfoSemaforos');
        var numRecordId = component.get('v.recordId');
        action.setParams({recordId:numRecordId});
        action.setCallback(this, function(response){
            var state =response.getState();
            if(state == 'SUCCESS'){
                var result=response.getReturnValue();
                component.set("v.objeto",result.objeto);
                if(result.numReas==1){
                    //if(result.objeto=='Lead'){component.set("v.esField",true);}else if(result.objeto=='Opportunity'){component.set("v.esFieldOpp",true);}
                    component.set("v.esField",true);
                    
                    if(result.diasResAct!=-1){
                        var rango;
                        if(result.objeto=='Lead'){
                            rango=parseInt(result.variables.ReasignacionLeadTarea_MLK__c);
                        }else if(result.objeto=='Opportunity'){
                            rango=parseInt(result.variables.ReasignacionOpportunity_MLK__c.split(';')[1]);
                        }                        
                        component.set("v.progresoFA",(result.diasResAct*100)/rango);
                        component.set("v.diasFaltA",rango-result.diasResAct);
                        
                        var prog=component.get("v.progresoFA");
                        if(prog>=0&&prog<100/3){
                            component.set("v.colorFA",'green');
                        }else if(prog>=100/3&&prog<(100/3)*2){
                            component.set("v.colorFA",'orange');
                        }else if(prog>=(100/3)*2){
                            component.set("v.colorFA",'red');
                        }
                        var childComponent = component.find("progressBarAc");
                        childComponent.fillBar();
                        
                    }
                    if(result.diasResFR!=-1){
                        //var rango=parseInt(result.variables.ReasignacionLeadConversion_MLK__c);
                        var rango;
                        if(result.objeto=='Lead'){
                            rango=parseInt(result.variables.ReasignacionLeadConversion_MLK__c);
                        }else if(result.objeto=='Opportunity'){
                            rango=parseInt(result.variables.ReasignacionOpportunity_MLK__c.split(';')[0]);
                        } 
                        component.set("v.progresoF",(result.diasResFR*100)/rango);
                        component.set("v.diasFalt",rango-result.diasResFR);
                        var prog=component.get("v.progresoF");
                        if(prog>=0&&prog<100/3){
                            component.set("v.colorF",'green');
                        }else if(prog>=100/3&&prog<(100/3)*2){
                            component.set("v.colorF",'orange');
                        }else if(prog>=(100/3)*2){
                            component.set("v.colorF",'red');
                        }
                        var childComponent = component.find("progressBar");
                        childComponent.fillBar();
                    }
                }else if(result.numReas==10||result.numReas==11||result.numReas==12||result.numReas==13){
                    //if(result.objeto=='Lead'){component.set("v.esDist",true);}else if(result.objeto=='Opportunity'){component.set("v.esDistOpp",true);}
                    component.set("v.esDist",true);
                    if(result.diasResFR!=-1){
                        //var rangos=result.variables.ReasignacionLead_Small__c.split(";");
                        var rangos;
                        if(result.objeto=='Lead'){
                            rangos=result.variables.ReasignacionLead_Small__c.split(";");
                        }else if(result.objeto=='Opportunity'){
                            rangos=result.variables.ReasignacionOpportunity_Small__c.split(";");
                        } 
                        component.set("v.progresoF",(result.diasResFR*100)/rangos[result.numReas-10]);
                        component.set("v.diasFalt",rangos[result.numReas-10]-result.diasResFR);
                        var prog=component.get("v.progresoF");
                        if(prog>=0&&prog<100/3){
                            component.set("v.colorF",'green');
                        }else if(prog>=100/3&&prog<(100/3)*2){
                            component.set("v.colorF",'orange');
                        }else if(prog>=(100/3)*2){
                            component.set("v.colorF",'red');
                        }
                        var childComponent = component.find("progressBar");
                        childComponent.fillBar();
                    }
                }
            }else{
                console.log("Error doInit");   
            }
        });
        $A.enqueueAction(action);
    }
})