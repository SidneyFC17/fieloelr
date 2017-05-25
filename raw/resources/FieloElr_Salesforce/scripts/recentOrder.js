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
  var FieloRecentReorder = function FieloRecentReorder(element) {
    this.element_ = element;

    // Initialize instance.
    this.init();
  };
  window.FieloRecentReorder = FieloRecentReorder;

  /**
   * Guarda las constantes en un lugar para que sean facilmente actualizadas
   * @enum {string | number}
   * @private
   */
  FieloRecentReorder.prototype.Constant_ = {
    SAVE_CONTROLLER: 'FieloELR.LevelReorderController.reorder'
  };

  /**
   * Guarda strings para nombres de clases definidas por este componente que
   * son usadas por JavaScript.
   * Esto nos permite cambiarlos solo en un lugar
   * @enum {string}
   * @private
   */
  FieloRecentReorder.prototype.CssClasses_ = {
    CONTAINER: 'fielosf-recent-records__container',
    FIELD: 'fielosf-output',
    MODEL: 'fielosf-recent-records__model',
    SAVE: 'slds-form__save',
    CANCEL: 'slds-form__cancel'
  };
  /**
  * Get
  */

  FieloRecentReorder.prototype.get = function() {
    var items = this.container_.getElementsByClassName(this.CssClasses_.MODEL);
    var sObjectList = [];
    [].forEach.call(items, function(item) {
      var sObject = {};
      sObject.id = item.getAttribute('data-record-id');
      sObject[this.orderByField_] = // eslint-disable-line camelcase
        item.querySelector(
          '[data-field = "' + this.orderByField_ + '"]').innerHTML;
      sObjectList.push(sObject);
    }, this);
    return sObjectList;
  };

  /**
  * Save Order
  */
  FieloRecentReorder.prototype.save_ = function() {
    if (!this.disableReorder) {
      fielo.util.spinner.FieloSpinner.show();
      var orderValues = this.get();
      try {
        Visualforce.remoting.Manager.invokeAction(
          this.element_.getAttribute('data-save-controller'),
          orderValues,
          this.processRemoteActionResult_.bind(this),
          {
            escape: false
          }
        );
      } catch (e) {
        console.warn(e);
      }
    }
  };

  /**
  * Process Remote Action
  */

  FieloRecentReorder.prototype.processRemoteActionResult_ = function(
    result
  ) {
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
      location.reload();
    }
    fielo.util.spinner.FieloSpinner.hide();
    notify.FieloNotify.show();
  };

  /**
  * Inicializa el drag and drop
  */

  FieloRecentReorder.prototype.sortable_ = function() {
    // Si el contenedor es tabla fija el ancho
    if (this.container_.nodeName === 'TBODY') {
      var columns = this.container_.querySelectorAll('td, th');
      $(columns).each(function() {
        var cell = $(this);
        cell.width(cell.width());
      });
    }

    $(this.container_).sortable({
      update: this.order_.bind(this),
      revert: true
    });
  };

  /**
  * Setea el orden de los elementos
  */

  FieloRecentReorder.prototype.order_ = function() {
    var items = this.container_.getElementsByClassName(this.CssClasses_.MODEL);
    var i = 1;

    [].forEach.call(items, function(elem) {
      elem.querySelector(
        '[data-field = "' + this.orderByField_ + '"]').innerHTML = i;
      i++;
    }, this);
  };

  /**
  * Inicializa el elemento
  */
  FieloRecentReorder.prototype.init = function() {
    if (this.element_) {
      this.container_ =
        this.element_.getElementsByClassName(this.CssClasses_.CONTAINER)[0] ||
        null;
      this.orderByField_ =
        this.element_.getAttribute('data-order-by');

      this.sortable_();
      this.order_();
      this.saveBtn_ = this.element_
        .getElementsByClassName(this.CssClasses_.SAVE)[0];
      if (this.saveBtn_) {
        this.saveBtn_.addEventListener('click', this.save_.bind(this));
      }
    }
  };

  // El componente se registra por si solo.
  // Asume que el componentHandler esta habilitado en el scope global
  fielo.helper.register({
    constructor: FieloRecentReorder,
    classAsString: 'FieloRecentReorder',
    cssClass: 'fielosf-recent-reorder',
    widget: true
  });
})();
