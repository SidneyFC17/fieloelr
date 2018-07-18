global class CommutyPages extends VisualEditor.DynamicPickList{
    
    global override VisualEditor.DataRow getDefaultValue(){
        VisualEditor.DataRow defaultValue = new VisualEditor.DataRow('automatic', 'Automatic');
        return defaultValue;
    }
    global override VisualEditor.DynamicPickListRows getValues() {
		List<NavigationMenuItem> commPages = [SELECT Id, Label, Target FROM NavigationMenuItem];
		VisualEditor.DynamicPickListRows  myValues = new VisualEditor.DynamicPickListRows();
		
		for (NavigationMenuItem pg: commPages) {
            myValues.addRow(new VisualEditor.DataRow(pg.Label, pg.Target));
		}
        return myValues;
    }
}