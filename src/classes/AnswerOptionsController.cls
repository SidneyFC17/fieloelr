public with sharing class AnswerOptionsController {
  /*****  Data  *****/
  public String csObjectName{get;set;}
  public String cFieldset{get;set;}
  public String cbuttons{get;set;}

  public class Section {
    public String Name{get;set;}
    public List<FormField> Fields{get;set;}
  }

  public class FormField {
    public String Type{get;set;}
    public String Name{get;set;}
    public String onchange{get;set;}
    public String ClassName{get;set;}
    public String Label{get;set;}
    public String Value{get;set;}
    public String WhereCondition{get;set;}
  }

  public List<Section> sections { get {
      if ( sections == null ) {
        if ( !String.isBlank(cFieldset)  ) {
            // Si empieza con [ es un valor seteado en una visual force => lo tiene que modificar para que sea json
            if ( !cFieldset.startsWith('[') ) {
              cFieldset = '[' + cFieldset.replace('\'', '"') + ']';
            }
            try{
              sections = (List<Section>) JSON.deserialize( cFieldset, List<AnswerOptionsController.Section>.class );
            }
            catch(Exception e){
              System.debug('Erro: '+e);
            }
        } else {
            sections = new List<Section>();
        }
      }
      return sections;
  } set;}

  public String fields {get{
    if ( fields == null ) {
          fields = 'Id';
          if(sections!=null)
          for ( Section s :sections ) {
            if(s.fields!=null)
              for ( FormField f :s.fields ) {
                if ( !String.isBlank(f.Name) ) {
                    fields += ', '  + f.Name;
                }
              }
          }
    }
        return fields;
  }set;}

}