public with sharing class CourseViewController extends PageSettingsController {
	public Course__c record {get;set;}
	public String buttonString {get;set;}
	// public String toolsString {get;set;}
	public static String secondaryParameters {get;set;}
	public List<Map<String,Object>> buttonList {get;set;}
	private ApexPages.StandardController controller;
	public FieloPLT__PageSettings__c cloneSettings {get; set;}

	/**
    * @brief constructor
    */
	public CourseViewController(ApexPages.StandardController controller) {
		String objectName = 'FieloELR__Course__c';
		this.controller = controller;
		Id recordId = controller.getId();
		Set<String> fields = new Set<String>();

		
		fields.addAll(Schema.describeSObjects(
			new String[]{objectName})[0].fields.getMap().keySet());

        if(!Test.isRunningTest()){
            this.controller.addFields(new List<String>(fields));
        }
        // Cast all fieldNames to lowercase
        for(String fieldName: fields){
			fields.remove(fieldName);
			fields.add(fieldName.toLowerCase());
		}

        record = (FieloELR__Course__c)controller.getRecord();

		buttonList = new List<Map<String,Object>>();

		if( getshowActivate() ){
			buttonList.add(new Map<String,Object>{
                'Label' => 'Activate',
                'Type' => 'Remote',
                'Action' => 'FieloELR.CourseViewController.activate',
                'Confirm' => true
            });
		}
		if( getShowInactivate() ){
			buttonList.add(new Map<String,Object>{
                'Label' => 'Inactivate',
                'Type' => 'Remote',
                'Action' => 'FieloELR.CourseViewController.inactivate',
                'Confirm' => true
            });
		}

		if(!buttonList.isEmpty()){
            buttonString = JSON.serialize(buttonList);
            buttonString = buttonString.substring(1,buttonString.length()-1);    
        }

        String standardTools = '';
        PageReference exportPage = Page.JSONExport;
		exportPage.getParameters().put( 'retURL', System.currentPageReference().getUrl() );
		exportPage.getParameters().put( 'courseId', recordId );
		exportPage.getParameters().put( 'type', 'courses' );

		
		buttonList = new List<Map<String,Object>>();
		buttonList.add(new Map<String,Object>{
            'Label' => 'Export',
            'Type' => 'Link', //Remote
            'Action' => exportPage.getUrl()
        });
        buttonList.add(new Map<String,Object>{
            'Label' => 'Save as Model',
            'Type' => 'Modal',
            'Action' => 'formModel',
            'Parameters' => '{ "cloneId": "' + recordId + '"}'
        });

		standardTools = JSON.serialize(buttonList);
        standardTools = standardTools.substring(1,standardTools.length()-1);
		

		initPageSettings(objectName, (SObject) record, buttonString, standardTools, '', record.Id);

		editSettings.FieloPLT__Sections__c = getSectionsWithSegmentWhereCondition(editSettings.FieloPLT__Sections__c, record.Program__c);
		try{

			SObjectType convertType = Schema.getGlobalDescribe().get('FieloPLT__PageSettings__c');
        	    SecurityUtils.checkObjectIsReadable(convertType);  


			cloneSettings = [SELECT Id, Name, FieloPLT__Sections__c FROM FieloPLT__PageSettings__c WHERE FieloPLT__Type__c = 'Clone' AND FieloPLT__Object__c = 'FieloELR__Course__c' LIMIT 1];
			cloneSettings.FieloPLT__Sections__c = '[' + cloneSettings.FieloPLT__Sections__c + ']';
			cloneSettings.FieloPLT__Sections__c = getSectionsWithSegmentWhereCondition(cloneSettings.FieloPLT__Sections__c, record.Program__c);
		}catch(Exception e){
			cloneSettings = editSettings;
		}

		if (relatedSettings != null) {
			for(FieloPLT__PageSettings__c settings:relatedSettings) {
				if(settings.FieloPLT__TargetObject__c == 'FieloELR__Module__c') {
					// if( (new ModulesSelector().selectByIdHavingCourses(new Set<Id>{record.Id})).size() > 1 ) {
						settings.FieloPLT__Buttons__c = '{"Label":"Reorder","Type":"Modal","Action":"FieloELR__Module__cFormReorder"}' +
						(settings.FieloPLT__Buttons__c != '' && settings.FieloPLT__Buttons__c != null ?
							',' + settings.FieloPLT__Buttons__c :
							'');	
					// }
				}
			}
		}

		if (relatedFormsSettings != null) {
			for(FieloPLT__PageSettings__c settings:relatedFormsSettings) {
				if(settings.FieloPLT__Object__c == 'FieloELR__CourseDependency__c') {
					settings.FieloPLT__Sections__c = getSectionsWithCourseWhereCondition(
						settings.FieloPLT__Sections__c,
						record.Program__c,
						record.Id
					);
				}
			}
		}
		
		if ( fieldList.size() > 0  ) {
			for(String fieldName:fieldList) {
				fields.add(fieldName);
			}
			if (fields.contains('fieloelr__segment__c') || fields.contains('fieloelr__segment__r.name')) {
				secondaryParameters = 'FieloELR__Segment__c';
			}
			String query = String.format(
				'SELECT {0} FROM {1} WHERE Id = :recordId',
				new String[]{
					String.join(new List<String>(fields), ','),
					objectName
				}
			);
			System.debug('init query: '+query);

			SObjectType convertType = Schema.getGlobalDescribe().get(objectName);

        	SecurityUtils.checkObjectIsReadable(convertType);
            	record = Database.query(query);
				setRecord(record);
         	
		}
	}

	public Boolean getShowActivate() {
		return this.record.FieloELR__Status__c == 'Draft' ||
			this.record.FieloELR__Status__c == 'Inactive';
	}

	public Boolean getShowInActivate() {
		return this.record.FieloELR__Status__c == 'Active' || 
			this.record.FieloELR__Status__c == 'Scheduled' ||
			this.record.FieloELR__Status__c == 'Completed';
	}

	@RemoteAction
	public static Course__c retrieve( String objectName, String recordId, String fields ){
		String query = 'SELECT FieloELR__Segment__r.FieloPLT__RelatedSegments__c,' + fields;
		query += ' FROM ' + objectName;
		query += ' WHERE ID = :recordId' ;
		query += ' LIMIT 1';
		System.debug('retrieve query: '+query);
		List<Course__c> result;
		
		SObjectType convertType = Schema.getGlobalDescribe().get(objectName);

        SecurityUtils.checkObjectIsReadable(convertType);

			result = Database.query(query);

			if(result[0].Segment__r.FieloPLT__RelatedSegments__c != null){
				system.debug(result[0].Segment__r.FieloPLT__RelatedSegments__c);
				List<String> segIds15 = result[0].Segment__r.FieloPLT__RelatedSegments__c.split(';');
				List<Id> segIds18 = segIds15;
				result[0].Segment__r.FieloPLT__RelatedSegments__c = '';
				for(Id id18: segIds18){
					result[0].Segment__r.FieloPLT__RelatedSegments__c += id18 + ';';
				}
				result[0].Segment__r.FieloPLT__RelatedSegments__c = result[0].Segment__r.FieloPLT__RelatedSegments__c.removeEnd(';');
			}

		return result.get(0);
	}

	public static RemoteActionResult save( Course__c record, List<String> nullFields) {
		return save(record, nullFields, new List<String>());
	}

	@RemoteAction
  	public static RemoteActionResult save( Course__c record, List<String> nullFields, List<String> segments) {
		Savepoint sp;
		RemoteActionResult result = new RemoteActionResult();
		try{
			sp = Database.setSavepoint();
			for ( String f :nullFields ) {
         		record.put(f, null );
			}
			if ( segments.size() == 1 ) {
				record.segment__c = segments.get(0);
        	} else if ( segments.size() > 1 ) {
				record.segment__c = SegmentService.getMetaSegmentId( segments, record.Program__c ) ;
			} else {
				record.segment__c = null;
        	}

			if(SecurityUtils.canInsert(Course__c.sObjectType, nullFields) && SecurityUtils.canUpdate(Course__c.sObjectType, nullFields)){
                 upsert record;
                }else{
                    throw new FieloPLT.FieloException(Label.FieloPLT.CannotInsertUpdateRecords);
                }
        	

			//TODO Crear Label DataSavedSuccessfully
			result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.Confirm, Label.DataSavedSuccessfully) );
			result.redirectURL = '/' + record.Id;
    	}catch(DmlException e){
    		if(sp != null){
	            Database.rollback(sp);
        	}
			result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.ERROR,e.getDmlMessage(0)));
    	}catch(Exception e){
        	if(sp != null){
	            Database.rollback(sp);
        	}
        	result.addMessage(new RemoteActionResult.RemoteActionMessage(e));
    	}
    	return result;
  	}

  	@RemoteAction
  	public static RemoteActionResult clone( Course__c record, List<String> nullFields, List<String> segments) {
		Savepoint sp;
		RemoteActionResult result = new RemoteActionResult();
		try{
			sp = Database.setSavepoint();
			for ( String f :nullFields ) {
         		record.put(f, null );
			}
			if ( segments.size() == 1 ) {
				record.segment__c = segments.get(0);
        	} else if ( segments.size() > 1 ) {
				record.segment__c = SegmentService.getMetaSegmentId( segments, record.Program__c ) ;
			} else {
				record.segment__c = null;
        	}

        	String courseJSON = ExportService.exportCourses(new List<Id>{record.Id});
        	SObjectUnitOfWork uow = ExportService.importData(courseJSON, new List<ExportService.MultiSegmentRelation>());
        	Map<String,Schema.SObjectField> fieldMap = record.getSObjectType().getDescribe().fields.getMap();

        	record.put('Id',null);

        	if ( uow.m_newListByType.containsKey('FieloELR__Course__c') ) {
                List<Course__c> courses = (List<Course__c>) uow.m_newListByType.get('FieloELR__Course__c');
                if ( courses.size() > 0 ) {
                    for(String fieldName: record.getPopulatedFieldsAsMap().keySet()) {
                    	if (fieldName != 'Id') {
                    		if (String.valueOf(fieldMap.get(fieldName).getDescribe().getType()) == 'DOUBLE') {
                    			if (record.get(fieldName) != null) {
	                    			courses.get(0).put(fieldName, 
	                    				record.get(fieldName) instanceof String ?
	                    					Decimal.valueOf((String)record.get(fieldName)):
	                    					Decimal.valueOf((Double)record.get(fieldName)));
                    			} else {
                    				courses.get(0).put(fieldName, null);
                    			}
                    		} else {
                    			courses.get(0).put(fieldName, record.get(fieldName));
                    		}
                    	}
					}
					courses.get(0).Status__c = 'Draft';

                    ExportService.saveData(uow, null);
                } else {
                    throw new FieloPLT.FieloException (label.FieloPLT.ModelEmpty);
                }
            } else {
                throw new FieloPLT.FieloException (label.FieloPLT.ModelEmpty);
            }

			//TODO Crear Label DataSavedSuccessfully
			result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.Confirm, Label.DataSavedSuccessfully) );
			result.redirectURL = '/' + uow.m_newListByType.get('FieloELR__Course__c').get(0).Id;
    	}catch(DmlException e){
    		if(sp != null){
	            Database.rollback(sp);
        	}
			result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.ERROR,e.getDmlMessage(0)));
    	}catch(Exception e){
        	if(sp != null){
	            Database.rollback(sp);
        	}
        	result.addMessage(new RemoteActionResult.RemoteActionMessage(e));
    	}
    	return result;
  	}

  	@RemoteAction
  	public static RemoteActionResult saveModule( SObject record, List<String> nullFields) {

		Savepoint sp;
		RemoteActionResult result = new RemoteActionResult();
		
		try{
			sp = Database.setSavepoint();
			for ( String f :nullFields ) {
         		record.put(f, null );
			}
			// TODO: Change to Create API
			if(Schema.sObjectType.Module__c.isUpdateable() && Schema.sObjectType.Module__c.isCreateable()){
				if(SecurityUtils.canInsert(Module__c.sObjectType, nullFields) && SecurityUtils.canUpdate(Module__c.sObjectType, nullFields)){
                  upsert (Module__c) record;
                }else{
                    throw new FieloPLT.FieloException(Label.FieloPLT.CannotInsertUpdateRecords);
                }
            }else{
               throw new FieloException(Label.CannotInsertUpdateRecords);
			}

			//TODO Crear Label DataSavedSuccessfully
			result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.Confirm, Label.DataSavedSuccessfully) );
			result.redirectURL = '/' + record.Id;
			
    	}catch(DMLException e){
    		if(sp != null){
	            Database.rollback(sp);
        	}
            result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.ERROR,e.getDmlMessage(0)));
        }catch(Exception e){
    		system.debug('Exception: ' + e);
        	if(sp != null){
	            Database.rollback(sp);
        	}
        	result.addMessage(new RemoteActionResult.RemoteActionMessage(e));
    	}	    	
	  	
	  	return result;
  	}
  	@RemoteAction
  	public static RemoteActionResult saveCourseDependency( SObject record, List<String> nullFields) {
		Savepoint sp;
		RemoteActionResult result = new RemoteActionResult();
		try{
			sp = Database.setSavepoint();
			for ( String f :nullFields ) {
         		record.put(f, null );
			}
			// TODO: Change to Create API
			if(SecurityUtils.canInsert(CourseDependency__c.sObjectType, nullFields) && SecurityUtils.canUpdate(CourseDependency__c.sObjectType, nullFields)){
                 upsert (CourseDependency__c) record;
                }else{
                    throw new FieloPLT.FieloException(Label.FieloPLT.CannotInsertUpdateRecords);
                }
        	

			//TODO Crear Label DataSavedSuccessfully
			result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.Confirm, Label.DataSavedSuccessfully) );
			result.redirectURL = '/' + ((CourseDependency__c)record).Course__c;
    	}catch(DMLException e){
    		if(sp != null){
	            Database.rollback(sp);
        	}
            result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.ERROR,e.getDmlMessage(0)));
        }catch(Exception e){
    		system.debug('Exception: ' + e);
        	if(sp != null){
	            Database.rollback(sp);
        	}
        	result.addMessage(new RemoteActionResult.RemoteActionMessage(e));
    	}
    	return result;
  	}

  	@RemoteAction
    public static List<SObject> getSegments( String programId ) {
        return new SegmentsSelector(new Set<String>{'Id','Name'}).selectByProgramAndWithoutProgramWithCriteria(programId, new Set<String>{'Id','Name'});
    }

    public class Section {
        public String Name{get;set;}
        public List<List<FormField>> Rows{get;set;}
        public String CssClass{get;set;}
    }

    public class FormField {
        public String Type{get;set;}
        public String MetaField{get;set;}
        public String Name{get;set;}
        public String onchange{get;set;}
        public String Label{get;set;}
        public String Value{get;set;}
        public String WhereCondition{get;set;}
        public Boolean Required{get;set;}

        public String getRequiredValue () {
            if ( Required != null ) {
                return Required ? 'true' : 'false';
            }
            return '';
        }
    }

    public static String getSectionsWithSegmentWhereCondition(String sectionsString, String programId){
        List<Section> sections = (List<Section>) JSON.deserialize( sectionsString, List<CourseViewController.Section>.class );
        for ( Section s :sections ) {
          for ( List<FormField> r :s.rows ) {
            for ( FormField f :r ) {
              if(f.Name != null) {
                if(f.Name == 'FieloELR__Segment__c') {
                    f.WhereCondition = ' FieloPLT__Program__c IN ( //, /' + programId + '/ ) AND RecordType.Name <> /Metasegment/ ';
                    secondaryParameters = 'FieloELR__Segment__c';
                }
              }
            }
          }
        }
        return JSON.serialize(sections);
    }

    public static String getSectionsWithCourseWhereCondition(String sectionsString, String programId, String courseId){
	    Section section = (Section) JSON.deserialize( sectionsString, CourseViewController.Section.class );
		for ( List<FormField> r :section.rows ) {
			for ( FormField f :r ) {
		  		if(f.Name != null) {
		    		if(f.Name == 'FieloELR__Predecessor__c') {
		        		f.WhereCondition = ' FieloELR__Program__c = /' + programId + '/ AND Id != /' + courseId + '/';
		    		}
		  		}
			}
		}
        return JSON.serialize(section);
    }

    @RemoteAction
  	public static RemoteActionResult activate( Id recordId ){
		RemoteActionResult result = new RemoteActionResult();
		try{
			CourseService.activateCourses(new Set<Id>{recordId});
			
			result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.Confirm, Label.CourseActivated) );

			result.redirectURL = '/' + recordId;

		} catch(DmlException e){
			result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.ERROR,e.getDmlMessage(0)));
		} catch(Exception e) {
			result.addMessage(new RemoteActionResult.RemoteActionMessage(e));
		}
		return result;
	}

	@RemoteAction
  	public static RemoteActionResult inactivate( Id recordId ){
		RemoteActionResult result = new RemoteActionResult();
		try{
			CourseService.inactivateCourses(new Set<Id>{recordId});
			
			result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.Confirm, Label.CourseInactivated) );

			result.redirectURL = '/' + recordId;

		} catch(DmlException e){
			result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.ERROR,e.getDmlMessage(0)));
		} catch(Exception e) {
			result.addMessage(new RemoteActionResult.RemoteActionMessage(e));
		}
		return result;
	}
}