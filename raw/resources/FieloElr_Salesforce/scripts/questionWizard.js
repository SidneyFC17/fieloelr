(function() {
  'use strict';

  /**
   * @description Controlador para la Landing de Content
   * Implementa los patrones de diseño definidos por MDL en
   * {@link https://github.com/jasonmayes/mdl-component-design-pattern}
   *
   * @version 1
   * @author Nicolás Alejandro Soberón <nicolas.soberon@fielo.com>
   * @param {HTMLElement} element - Elemento que será mejorado.
   * @constructor
   */
  var FieloQuestionWizard = function FieloQuestionWizard(element) {
    this.element_ = element;

    // Initialize instance.
    this.init();
  };
  window.FieloQuestionWizard = FieloQuestionWizard;

  /**
   * Guarda las constantes en un lugar para que sean facilmente actualizadas
   * @enum {string | number}
   * @private
   */
  FieloQuestionWizard.prototype.Constant_ = {
    OBJECT_NAME: 'data-object-name',
    SAVE_CONTROLLER: 'FieloELR.LevelReorderController.reorder',
    DATA_CONTROLLER: 'data-controller-element',
    DATA_UPGRADED: 'data-upgraded',
    FORM_ID: 'FieloELR__Question__cFormWizard'
  };

  /**
   * Guarda strings para nombres de clases definidas por este componente que
   * son usadas por JavaScript.
   * Esto nos permite cambiarlos solo en un lugar
   * @enum {string}
   * @private
   */
  FieloQuestionWizard.prototype.CssClasses_ = {
    RECENT_CONTAINER: 'fielosf-recent-records__container',
    FIELD: 'fielosf-output',
    MODEL: 'fielosf-recent-records__model',
    SAVE: 'fielosf-question-wizard__save',
    SAVE_NEW: 'fielosf-question-wizard__saveNew',
    NEXT: 'fielosf-question-wizard__next',
    NEXT_MULTIPLE_CHOICE: 'fielosf-question-wizard__next-multiplechoice',
    CANCEL: 'fielosf-question-wizard__cancel',
    SECTION_PANEL: 'slds-panel__section',
    FORM_ELEMENT: 'slds-form-element',
    FORM_ELEMENT_LABEL: 'slds-form-element__label',
    REORDER: 'fielosf-recent-reorder',
    ANSWER_OPTIONS: 'fielosf-answer-options',
    ANSWER_OPTIONS_ITEM: 'fielosf-answer-options__item',
    DATA_FIELD_NAME: 'data-field-name',
    DATA_FIELD_TABLE: 'data-field',
    OUTPUT_ELEMENT: 'fielosf-output'
  };
  /**
  * Get Question
  */

  FieloQuestionWizard.prototype.getQuestion_ = function() {
    var questionSection =
      this.form_.getElementsByClassName(this.CssClasses_.SECTION_PANEL)[0];
    var fields =
      $(questionSection).find('.' + this.CssClasses_.FORM_ELEMENT);
    var sObject = {};
    if (this.parameters_.hasOwnProperty('Id') ||
      this.parameters_.hasOwnProperty('cloneId')) {
      sObject.id = this.parameters_.Id ||
      this.parameters_.cloneId;
    }
    [].forEach.call(fields, function(field) {
      sObject[field.FieloFormElement.get('fieldName')] =
        field.FieloFormElement.get('value');
    }, this);
    if (this.questionType_) {
      sObject.FieloELR__Type__c =// eslint-disable-line camelcase
        this.questionType_.FieloFormElement.get('value');
    }

    return sObject;
  };

  FieloQuestionWizard.prototype.getDeletedAnswerIds_ = function() {
    var itemContainer = $(this.form_)
      .find('.' + this.CssClasses_.ANSWER_OPTIONS)[0];
    var deletedIds = null;
    if (itemContainer) {
      deletedIds = itemContainer.FieloAnswerOptions.deletedItems;
    }
    return deletedIds;
  };

  FieloQuestionWizard.prototype.getAnswerOptions_ = function() {
    var itemContainer = $(this.form_)
      .find('.' + this.CssClasses_.ANSWER_OPTIONS)[0];
    var items = null;
    if (itemContainer) {
      items = itemContainer.FieloAnswerOptions.get();
    }
    [].forEach.call(items, function(item) {
      if (item.FieloELR__AnswerOptionText__c === '' ||
        item.FieloELR__AnswerOptionText__c === null ||
        item.FieloELR__AnswerOptionText__c === undefined) {
        item.error = 'Answer Option Text is a required field';
      }
    });
    return items;
  };

  FieloQuestionWizard.prototype.getMatchingAnswerOptions_ = function() {
    var items =
      $(this.form_)
        .find('.' + this.CssClasses_.ANSWER_OPTIONS_ITEM);
    var sObjectList = [];
    var fields = null;
    var fieldName = null;
    var sObject = null;
    var answerOptions = null;
    var answerOptionObject = null;
    [].forEach.call(items, function(item) {
      answerOptions = [];
      sObject = {};
      // Input Fields
      fields = item.getElementsByClassName(
        this.CssClasses_.FORM_ELEMENT);
      [].forEach.call(fields, function(field) {
        var sObjectValue = field.FieloFormElement.get('value');
        fieldName = field.getAttribute(this.CssClasses_.DATA_FIELD_NAME);
        if (fieldName === 'FieloELR__AnswerOptionText__c') {
          answerOptions.push(sObjectValue);
        } else {
          sObject[fieldName] = sObjectValue;
        }
      }, this);

      // Output Fields
      fields = item.getElementsByClassName(this
          .CssClasses_.OUTPUT_ELEMENT);
      [].forEach.call(fields, function(field) {
        var sObjectValue = field.innerHTML;
        fieldName = field.getAttribute(this.CssClasses_.DATA_FIELD_TABLE);
        sObject[fieldName] = sObjectValue;
      }, this);

      sObject.FieloELR__IsCorrect__c = true; // eslint-disable-line camelcase

      // Matching Special Treatment
      if (answerOptions.length > 0) {
        answerOptionObject = {};
        answerOptionObject.option = answerOptions[0];
        answerOptionObject.matches = answerOptions[1];
        if (answerOptionObject.matches === null ||
          answerOptionObject.matches === undefined ||
          answerOptionObject.matches === '') {
          sObject.error = 'Matches is a required field';
        }
        sObject.FieloELR__AnswerOptionText__c = // eslint-disable-line camelcase
          JSON.stringify(answerOptionObject);
      }
      if (item.getAttribute('data-record-id') !== '') {
        sObject.Id = item.getAttribute('data-record-id');
      }
      sObjectList.push(sObject);
    }, this);
    return sObjectList;
  };

  FieloQuestionWizard.prototype.throwMessage = function(type, errorMsg) {
    var notify = fielo.util.notify.create();
    notify.FieloNotify.addMessages(errorMsg);
    notify.FieloNotify.setTheme(type);
    notify.FieloNotify.show();
  };

  FieloQuestionWizard.prototype.retrieve_ = function(source) {
    // traigo los parameters del boton
    this.parameters_ = source.FieloButton.getParameters();

    // Setea parametros default en edit y new
    this.setParameters_();

    // 2 - Hacer retrieve si estoy en edit
    if (
      this.parameters_.hasOwnProperty('Id') ||
      this.parameters_.hasOwnProperty('cloneId')
    ) {
      this.isEditing = true;
      this.recordId_ = this.parameters_.Id;

      var retrieveRecordId = this.parameters_.Id ||
        this.parameters_.cloneId;

      // Si es un record busca los datos y los setea
      this.fields_ = Array.from(this.questionFields_);

      Visualforce.remoting.Manager.invokeAction(
        this.form_.getAttribute('data-retrieve-controller'),
        this.form_.getAttribute('data-object-name'),
        retrieveRecordId,
        this.fields_.join(),
        this.retrieveHandler_.bind(this),
        {escape: true}
      );
    } else {
      this.isEditing = false;
      this.setParameters_();
      this.endRetrieve();
    }
  };

  FieloQuestionWizard.prototype.retrieveProxy_ = function(modal, source) {
    $(modal)
      .closest('.fielosf-question-wizard')[0]
        .FieloQuestionWizard.retrieve_(source);
  };
  window.FieloQuestionWizard_retrieve =// eslint-disable-line camelcase
    FieloQuestionWizard.prototype.retrieveProxy_;

  FieloQuestionWizard.prototype.retrieveHandler_ = function(result) {
    fielo.util.spinner.FieloSpinner.show();
    this.result = result;
    // Set form type
    $('#' + this.Constant_.FORM_ID)
      .find('[data-field-name="FieloELR__Type__c"]')[0]
        .FieloFormElement.set('value',
          result.FieloELR__Type__c);
    this.next_();
    try {
      // analizo si hay listas
      // preparo un hash para representar los campos que tienen listas
      var hash = '|';
      for (var field in result) {
        if (result.hasOwnProperty(field) && field.indexOf('__r') > -1) {
          hash += field.slice(0, -1) + 'c|';
        }
      }

      this.fields_.forEach(function(field) {
        // si es una lista
        if (hash.indexOf(field) > -1) {
          var values;
          switch (typeof result[field.slice(0, -1) + 'r']) {
            case 'object':
              // es un objeto que en su propiedad field contiene un string con id separados por ;
              // siguiendo el formato de salesforce
              // hay que parsear la informacion para pasarlo a la interfaz normal
              values = result[field.slice(0, -1) + 'r'];
              // busco la clave que contiene el campo __c
              var __c;
              for (var key in values) {
                if (values.hasOwnProperty(key) && key.indexOf('__c') > -1) {
                  __c = key;
                  break;
                }
              }
              if (__c) {
                values = values[__c].split(';');
              } else {
                values = result[field];
              }
              break;
            case 'array':
            default:
              // una interfaz normal
              values = result[field.slice(0, -1) + 'r'];
              break;
          }
          this.elements_[field].FieloFormElement.set('value', values);
        } else if (this.elements_[field]) {
          if (
            this.elements_[field].FieloFormElement.get('type') === 'input-date'
          ) {
            result[field] = fielo.util.parseDateFromSF(result[field]);
          }
          this.elements_[field].FieloFormElement.set('value', result[field]);
        }
      }, this);

      if (result.FieloELR__Module__c) {
        this.parameters_.FieloELR__Module__c = // eslint-disable-line camelcase
          result.FieloELR__Module__c; // eslint-disable-line camelcase
      }

      // Set Answers
      if (result.FieloELR__AnswerOptions__r) {
        if (result.FieloELR__AnswerOptions__r.length > 0) {
          this.setAnswers_(result.FieloELR__AnswerOptions__r);
        }
      }
      // 3 - Pisar con los parameters de source en edit y new
      this.setParameters_();
      this.endRetrieve();
    } catch (e) {
      var notify = fielo.util.notify.create();
      notify.FieloNotify.addMessages([e]);
      notify.FieloNotify.setTheme('error');
      notify.FieloNotify.show();
    }
    // Hago focus en el primer elemento del form
    var elements =
      this.element_.getElementsByClassName(this.CssClasses_.ELEMENTS);
    for (var i = 0; i < elements.length; i++) {
      var type = elements[i].FieloFormElement.get('type');
      if (type === 'lookup' || type.indexOf('input') !== -1) {
        elements[i].getElementsByClassName('slds-input')[0].focus();
        break;
      }
    }
    fielo.util.spinner.FieloSpinner.hide();
  };

  FieloQuestionWizard.prototype.setAnswers_ = function(answers) {
    var existingRows = $(this.form_)
        .find('.' + this.CssClasses_.ANSWER_OPTIONS_ITEM).length;
    var row = answers.length - existingRows;
    while (row > 0) {
      this.newAnswer();
      row--;
    }
    row = 0;
    var answerItem = null;
    var field = null;
    [].forEach.call(answers, function(answer) {
      answerItem = $(this.form_)
        .find('.' + this.CssClasses_.ANSWER_OPTIONS_ITEM)[row];
      if (answerItem) {
        [].forEach.call(Object.keys(answer), function(fieldName) {
          field =
            $(answerItem)
              .find('[data-field-name="' + fieldName + '"]')[0];
          if (field) {
            if (fieldName === 'FieloELR__AnswerOptionText__c' &&
                this.result.FieloELR__Type__c === 'Matching Options') {
              var answerOptionObject =
                JSON.parse(this.unencodeHTML(answer[fieldName]));
              field =
                $(answerItem)
                  .find('[data-field-name="' + fieldName + '"]')[0];
              field.FieloFormElement.set('value', answerOptionObject.option);
              field =
                $(answerItem)
                  .find('[data-field-name="' + fieldName + '"]')[1];
              field.FieloFormElement.set('value', answerOptionObject.matches);
            } else {
              field.FieloFormElement.set('value', answer[fieldName]);
            }
          }
          if (!field) {
            field =
              $(answerItem)
                .find('[data-field="' + fieldName + '"]')[0];
            if (field) {
              field.innerHTML = answer[fieldName];
            }
          }
        }, this);
        answerItem.setAttribute('data-record-id', answer.Id);
        row++;
      }
    }, this);
  };

  FieloQuestionWizard.prototype.unencodeHTML = function(htmlString) {
    var encodedStr = htmlString;

    var parser = new DOMParser();
    var dom = parser.parseFromString(
        '<!doctype html><body>' + encodedStr,
        'text/html');
    var decodedString = dom.body.textContent;

    return decodedString;
  };

  FieloQuestionWizard.prototype.setParameters_ = function() {
    for (var field in this.parameters_) {
      if (field in this.parameters_) {
        if (field in this.elements_) {
          this.elements_[field].FieloFormElement.set(
            'value',
            this.parameters_[field]
          );
        }
      }
    }
  };

  FieloQuestionWizard.prototype.saveOnly_ = function() {
    this.isSaveAndNew = false;
    this.save_();
    if (!this.hasError_) {
      $(this.form_).modal('dismiss');
    }
  };

  FieloQuestionWizard.prototype.saveAndNew_ = function() {
    this.isSaveAndNew = true;
    this.save_();
    if (!this.hasError_) {
      $(this.form_).modal('dismiss');
    }
  };

  /**
  * Save Order
  */
  FieloQuestionWizard.prototype.save_ = function() {
    // fielo.util.spinner.FieloSpinner.show();
    var questionValues = this.getQuestion_();
    var questionNullFields = [];

    [].forEach.call(Object.keys(questionValues), function(field) {
      if (questionValues[field] === '' ||
          questionValues[field] === null) {
        questionNullFields.push(field);
      }
    });

    var answerOptionValues =
      questionValues.FieloELR__Type__c === 'Matching Options' ?
        this.getMatchingAnswerOptions_() :
          this.getAnswerOptions_();
    var deletedIds = this.getDeletedAnswerIds_();
    deletedIds = deletedIds ?
      deletedIds :
      [];
    var answerOptionNullFields = {};
    var errorMsgs = new Set();

    if (questionValues.Name === '' ||
      questionValues.Name === null ||
      questionValues.Name === undefined) {
      errorMsgs.add('Name is a required field');
    }

    if (questionValues.FieloELR__QuestionText__c === '' ||
      questionValues.FieloELR__QuestionText__c === null ||
      questionValues.FieloELR__QuestionText__c === undefined) {
      errorMsgs.add('Question Text is a required field');
    }

    answerOptionValues.forEach(function(row) {
      if (questionValues.FieloELR__Type__c === 'Short Answer') {// eslint-disable-line camelcase
        row.FieloELR__IsCorrect__c = true;// eslint-disable-line camelcase
      }
      [].forEach.call(Object.keys(row), function(field) {
        if (row[field] === '' ||
          row[field] === null) {
          if (row.id) {
            if (!answerOptionNullFields[row.Id]) {
              answerOptionNullFields[row.Id] = [];
            }
            answerOptionNullFields[row.id].push(field);
          }
        }
        if (deletedIds) {
          if (deletedIds.includes(row.Id)) {
            delete answerOptionValues[answerOptionValues.indexOf(row)];
          }
        }
      });
      if (row.error) {
        errorMsgs.add(row.error);
      }
    });
    try {
      if (errorMsgs.size > 0) {
        this.hasError_ = true;
        this.throwMessage('error', Array.from(errorMsgs));
      } else {
        this.hasError_ = false;
        Visualforce.remoting.Manager.invokeAction(
          this.form_.getAttribute('data-save-controller'),
          questionValues,
          questionNullFields,
          answerOptionValues,
          answerOptionNullFields,
          deletedIds,
          this.processRemoteActionResult_.bind(this),
          {
            escape: false
          }
        );
      }
    } catch (e) {
      console.warn(e);
    }
  };

  FieloQuestionWizard.prototype.next_ = function() {
    this.questionType_ = $('#' + this.Constant_.FORM_ID)
      .find('[data-field-name="FieloELR__Type__c"]')[0];
    this.formIdSufix_ = '';
    if (this.questionType_) {
      switch (this.questionType_.FieloFormElement.get('value')) {
        case 'Multiple Choice':
          this.formIdSufix_ = 'multiplechoice';
          this.initMultipleChoiceForm();
          break;
        case 'Single Choice':
          this.formIdSufix_ = 'multiplechoice';
          this.initSingleChoiceForm();
          break;
        case 'Short Answer':
          this.formIdSufix_ = 'multiplechoice';
          this.initShortAnswerForm();
          break;
        case 'Statement':
          this.formIdSufix_ = 'multiplechoice';
          this.initStatementForm();
          break;
        case 'Matching Options':
          this.formIdSufix_ = 'multiplechoice';
          this.initMatchingForm();
          break;
        default:
          this.formIdSufix_ = 'error';
          break;
      }
      this.questionType_.FieloFormElement.clear();
      this.questionType_.FieloFormElement.set('value', '');
    }
    if (this.formIdSufix_ === 'error' ||
        this.formIdSufix_ === '') {
      this.throwMessage('error', 'Must choose a question type.');
    } else if (!$(this.form_).is(':visible')) {
      $(this.element_)
        .find('.' + this.CssClasses_.NEXT + '-' + this.formIdSufix_)[0]
          .click();
    }
  };

  FieloQuestionWizard.prototype.initMultipleChoiceForm = function() {
    this.form_ = $('#' + this.formId_ + '-' + this.formIdSufix_)[0];
    var answerOptions = $(this.form_)
      .find('.fielosf-answer-options')[0];
    if (answerOptions) {
      answerOptions.FieloAnswerOptions.clear();
    }
    var fields = $(this.form_)
      .find('.slds-form-element');
    [].forEach.call(fields, function(field) {
      if (field.FieloFormElement) {
        field.FieloFormElement.clear();
      }
    }, this);
    this.getFields_();
    // Undo Single Choice and Statement changes to the form
    this.radioEnabled_ = false;
    // Undo Short Answer changes to the form
    this.showColumn('FieloELR__IsCorrect__c');
    // Undo Statement changes to the form
    $($($(this.form_)
      .find('[data-field-name="FieloELR__AnswerOptionText__c"]')[0])
        .find('input')[0]).prop('disabled', false);
    $($(this.form_)
      .find('[data-field-name="FieloELR__Type__c"]')[0])
        .toggle(false);
    $($(this.form_)
      .find('.slds-button--new-answer')[0])
        .toggle(true);
    var answerTextFieldLabel = $(this.form_)
      .find('[title="Answer Option Text"]')[0];
    answerTextFieldLabel.innerHTML =
      answerTextFieldLabel.getAttribute('title');
    answerTextFieldLabel = $(this.form_)
      .find('[title="Matches"]')[0];
    if (answerTextFieldLabel) {
      this.removeColumn('Matches');
    }
    this.toggleRemoveButton(true);
  };

  FieloQuestionWizard.prototype.initSingleChoiceForm = function() {
    this.initMultipleChoiceForm();
    this.enableRadio();
  };

  FieloQuestionWizard.prototype.initShortAnswerForm = function() {
    this.initMultipleChoiceForm();
    this.hideColumn('FieloELR__IsCorrect__c');
  };

  FieloQuestionWizard.prototype.initStatementForm = function() {
    this.initMultipleChoiceForm();
    this.enableRadio();
    this.newAnswer();
    this.toggleRemoveButton(false);
    $($(this.form_)
      .find('.slds-button--new-answer')[0])
        .toggle(false);
    var fields = $(this.form_)
      .find('[data-field-name="FieloELR__AnswerOptionText__c"]');
    if (fields) {
      fields[0].FieloFormElement.set('value', 'True');
      $($(fields[0]).find('input')[0]).prop('disabled', true);
      fields[1].FieloFormElement.set('value', 'False');
      $($(fields[1]).find('input')[0]).prop('disabled', true);
    }
  };

  FieloQuestionWizard.prototype.initMatchingForm = function() {
    this.initMultipleChoiceForm();
    this.hideColumn('FieloELR__IsCorrect__c');
    var answerTextField = $(this.form_)
      .find('[data-field-name="FieloELR__AnswerOptionText__c"]')[0];
    var index = $(answerTextField).closest('td').index();
    var headerRow = $(answerTextField)
      .closest('table')
      .find('thead')
        .find('tr')[0];
    var column = headerRow.cells[index];
    var lastColumn = headerRow.cells[headerRow.cells.length - 1];
    $($(column).clone(true)[0]).insertBefore(lastColumn);
    var rows = $(this.form_)
      .find('.slds-table tr');
    rows = $(rows).not(rows[0]);

    [].forEach.call(rows, function(row) {
      $($($(answerTextField)
          .closest('td')[0])
            .clone(true)[0])
              .insertBefore(
                row.cells[row.cells.length - 1]);
    });

    var option = $(headerRow)
      .find('[title="Answer Option Text"]')[0];
    var matches = $(headerRow)
      .find('[title="Answer Option Text"]')[1];
    option.innerHTML = 'Option';
    matches.innerHTML = 'Matches';
    matches.setAttribute('title', 'Matches');

    this.newAnswer();
    this.deleteAnswer(0);
  };

  FieloQuestionWizard.prototype.radioChoice = function(source) {
    if (this.questionType_.FieloFormElement.get('value') ===
        'Single Choice' ||
        this.questionType_.FieloFormElement.get('value') ===
        'Statement') {
      var isCorrectFields = $(this.form_)
        .find('table')
          .find('[data-field-name="FieloELR__IsCorrect__c"]')
            .not(source.currentTarget);

      [].forEach.call(isCorrectFields, function(isCorrect) {
        isCorrect.FieloFormElement.set('value',
            source.currentTarget.FieloFormElement.get('value') ?
              false :
              isCorrect.FieloFormElement.get('value')
          );
      }, this);
    }
  };

  FieloQuestionWizard.prototype.enableRadio = function() {
    // add listener only once
    if (!this.radioEnabled_) {
      $($(this.form_)
        .find('table')
          .find('[data-field-name="FieloELR__IsCorrect__c"]')[0])
            .on('change', this.radioChoice.bind(this));
      $(this.form_)
        .find('table')
          .find('[data-field-name="FieloELR__IsCorrect__c"]')[0]
            .FieloFormElement.set('value', true);
    }
    this.radioEnabled_ = true;
  };

  FieloQuestionWizard.prototype.getFields_ = function() {
    var form = this.form_ === null || this.form_ === undefined ?
      $('#' + this.formId_)[0] :
      this.form_;

    var questionFields = $($(form)
      .find('.' + this.CssClasses_.SECTION_PANEL)[0])
        .find('.' + this.CssClasses_.FORM_ELEMENT);

    this.elements_ = [];
    [].forEach.call(questionFields, function(field) {
      this.addField(field.FieloFormElement.get('fieldName'));
      this.elements_[field.FieloFormElement.get('fieldName')] = field;
    }, this);

    if (this.elements_.FieloELR__ShuffleAnswerOptions__c) {
      this.elements_.FieloELR__ShuffleAnswerOptions__c
        .addEventListener('change',
          this.changeForm.bind(this));
    }
  };

  FieloQuestionWizard.prototype.changeForm = function() {
    var shuffleAnswerOptions =
      $(this.form_)
        .find('[data-field-name="FieloELR__ShuffleAnswerOptions__c"]')[0]
          .FieloFormElement.get('value');
    if (shuffleAnswerOptions) {
      this.hideColumn('FieloELR__Order__c');
    } else {
      this.showColumn('FieloELR__Order__c');
    }
  };

  FieloQuestionWizard.prototype.toggleRemoveButton = function(toggleValue) {
    var removeBtns = $(this.form_)
      .find('.slds-button--delete');
    [].forEach.call(removeBtns, function(button) {
      $(button).toggle(toggleValue);
    });
  };

  FieloQuestionWizard.prototype.removeColumn = function(title) {
    var answerTextFieldLabel = $(this.form_)
      .find('[title="' + title + '"]')[0];
    if (answerTextFieldLabel) {
      var index = $(answerTextFieldLabel)
        .closest('th').index();
      $(answerTextFieldLabel).closest('th').remove();
      var items = $(this.form_)
        .find('.' + this.CssClasses_.ANSWER_OPTIONS_ITEM);
      [].forEach.call(items, function(item) {
        $(item.cells[index]).remove();
      });
    }
  };

  FieloQuestionWizard.prototype.hideColumn = function(fieldName) {
    var items = $(this.form_)
      .find('.' + this.CssClasses_.MODEL);
    var currentField = null;

    [].forEach.call(items, function(item) {
      currentField = $(item)
        .find('[data-field-name="' + fieldName + '"]')[0];
      if (!currentField) {
        currentField = $(item)
          .find('[data-field="' + fieldName + '"]')[0];
      }
      if (currentField) {
        $(currentField).toggle(false);
        $(currentField).closest('td').toggle(false);
      }
    }, this);

    if (currentField) {
      var index = $(currentField).closest('td').index();
      var column = $(currentField).closest('table')
        .find('thead')
          .find('tr')[0].cells[index];
      $(column).toggle(false);
    }
  };

  FieloQuestionWizard.prototype.showColumn = function(fieldName) {
    var items = $(this.form_)
      .find('.' + this.CssClasses_.MODEL);
    var currentField = null;

    [].forEach.call(items, function(item) {
      currentField = $(item)
        .find('[data-field-name="' + fieldName + '"]')[0];
      if (!currentField) {
        currentField = $(item)
          .find('[data-field="' + fieldName + '"]')[0];
      }
      if (currentField) {
        $(currentField).toggle(true);
        $(currentField).closest('td').toggle(true);
      }
    }, this);

    if (currentField) {
      var index = $(currentField).closest('td').index();
      var column = $(currentField).closest('table')
        .find('thead')
          .find('tr')[0].cells[index];
      $(column).toggle(true);
    }
    if (fieldName === 'FieloELR__Order__c') {
      this.reorderObject.enableSort();
    }
  };

  FieloQuestionWizard.prototype.getModule_ = function() {
    var fieldValue =
      this.parameters_.FieloELR__Module__c;
    if (fieldValue) {
      var moduleFields = 'FieloELR__PenaltyMode__c';
      moduleFields += ',FieloELR__WeightedQuestions__c';
      moduleFields += ',FieloELR__ShuffleQuestions__c';
      Visualforce.remoting.Manager.invokeAction(
        this.form_.getAttribute('data-retrieve-controller'),
        'FieloELR__Module__c',
        fieldValue,
        moduleFields,
        this.moduleRetrieveHandler_.bind(this),
        {escape: true}
      );
    }
  };

  FieloQuestionWizard.prototype.moduleRetrieveHandler_ = function(result) {
    var penaltyMode =
      result.FieloELR__PenaltyMode__c;
    var weightedQuestions =
      result.FieloELR__WeightedQuestions__c;
    var shuffleQuestions =
      result.FieloELR__ShuffleQuestions__c;
    if (penaltyMode === 'None') {
      this.hideFormField_(
        'FieloELR__PenaltyPerAttempt__c',
        'FieloELR__IncorrectWeight__c');
    } else if (penaltyMode === 'Percent Decrease') {
      this.hideFormField_('FieloELR__IncorrectWeight__c');
    } else if (penaltyMode === 'Negative Weight') {
      this.hideFormField_('FieloELR__PenaltyPerAttempt__c');
    }
    if (!weightedQuestions) {
      this.hideFormField_('FieloELR__CorrectWeight__c');
    }
    if (shuffleQuestions) {
      this.hideFormField_('FieloELR__Order__c');
    }
    this.changeForm();
  };

  FieloQuestionWizard.prototype.hideFormField_ = function() {
    [].forEach.call(arguments, function(fieldName) {
      var field = $(this.form_)
          .find('[data-field-name="' + fieldName + '"]')[0];
      if (field) {
        $(field).toggle(false);
      }
    }, this);
  };

  FieloQuestionWizard.prototype.endRetrieve = function() {
    this.getModule_();
  };

  /**
  * Process Remote Action
  */

  FieloQuestionWizard.prototype.processRemoteActionResult_ = function(result) {
    var notify = fielo.util.notify.create();
    notify.FieloNotify.addMessages([
      result.messagesSet
    ]);
    if (
      result.messages[0].severity &&
      result.messages[0].severity === 'ERROR'
    ) {
      notify.FieloNotify.setTheme('error');
    } else {
      notify.FieloNotify.setTheme('success');
      window.location.href = this.getNewURL();
      location.reload();
    }
    fielo.util.spinner.FieloSpinner.hide();
    notify.FieloNotify.show();
  };

  FieloQuestionWizard.prototype.getNewURL = function() {
    var url = window.location.href;
    if (this.isSaveAndNew) {
      if (url.substr(-1) === '#') {
        url += this.formId_;
      } else {
        url += '#' + this.formId_;
      }
    }
    return url;
  };

  FieloQuestionWizard.prototype.hideButtons_ = function() {
    $($(this.element_)
      .find('.' + this.CssClasses_.NEXT_MULTIPLE_CHOICE)[0])
      .toggle(false);
  };

  FieloQuestionWizard.prototype.newAnswer = function() {
    if (this.form_) {
      $(this.form_)
        .find('.slds-button--new-answer')[0]
          .click();
    }
  };

  FieloQuestionWizard.prototype.deleteAnswer = function(index) {
    if (this.form_) {
      if ($(this.form_)
        .find('.slds-button--delete')[index]) {
        $(this.form_)
          .find('.slds-button--delete')[index]
            .click();
      }
    }
  };

  FieloQuestionWizard.prototype.addField = function(fieldName) {
    if (!this.questionFields_) {
      this.questionFields_ = new Set();
    }
    this.questionFields_.add(fieldName);
  };

  FieloQuestionWizard.prototype.getUrlParameter = function(sParam) {
    var sPageURL = decodeURIComponent(window.location.search.substring(1));
    var sURLVariables = sPageURL.split('&');
    var sParameterName;
    var i;

    for (i = 0; i < sURLVariables.length; i++) {
      sParameterName = sURLVariables[i].split('=');
      if (sParameterName[0] === sParam) {
        return sParameterName[1] === undefined ? true : sParameterName[1];
      }
    }
  };

  /**
  * Inicializa el elemento
  */
  FieloQuestionWizard.prototype.init = function() {
    if (this.element_) {
      this.element_.getElementsByClassName(this.CssClasses_.NEXT)[0]
        .addEventListener('click', this.next_.bind(this));
      this.reorderObject = $('.' + this.CssClasses_.REORDER)[0]
        .FieloRecentReorder;
      this.formId_ =
        this.element_.getAttribute('form-id');
      if (this.reorderObject) {
        this.reorderObject.disableReorder = true;
      }
      this.hideButtons_();

      this.multipleChoiceform_ =
        $('#' + this.formId_ + '-multiplechoice')[0];
      $(this.multipleChoiceform_)
        .find('.' + this.CssClasses_.SAVE)[0]
          .addEventListener('click',
            this.saveOnly_.bind(this));
      $(this.multipleChoiceform_)
        .find('.' + this.CssClasses_.SAVE_NEW)[0]
          .addEventListener('click',
            this.saveAndNew_.bind(this));
      this.form_ = this.multipleChoiceform_;
      this.getFields_();
      this.hideFormField_('FieloELR__IncorrectWeight__c',
        'FieloELR__CorrectWeight__c',
        'FieloELR__PenaltyPerAttempt__c');

      var hash = window.location.hash;
      if (hash) {
        console.log(hash);
        var button =
          $('[data-action="' + hash.replace('#','') + '"]')[0];
        console.log(button);
        if (button) {
          window.location.href =
            window.location.href.replace(hash,'#');
          button.click();
        }
      }
    }
  };

  // El componente se registra por si solo.
  // Asume que el componentHandler esta habilitado en el scope global
  fielo.helper.register({
    constructor: FieloQuestionWizard,
    classAsString: 'FieloQuestionWizard',
    cssClass: 'fielosf-question-wizard',
    widget: true
  });
})();
