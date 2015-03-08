var objectHelper = require('mixins/object_helper_mixin');
var httpStatuses = require('constants/HttpStatuses');

var refreshableErrors = [404, 401, 403, 404, 500, 503];

var AjaxStateMixin = {
  /**
   * handle ajax errors
   * @see constants/HttpStatuses for generic messages for some common http statuses.
   * If you need to show users specific error messages, format your json response as followed:
   * `{"error": "Custom error messages"}`
   * e.g., in rails: `render json: {error: 'You provided an invalid email address.'}, status: 422`
   *
   * @param  {jqXHR} xhr            jqXHR response object
   * @param  {String} statusText    statusText from the server
   * @param  {String} errorText     errorText from the server
   * @return {void}
   */
  handleError: function(xhr, statusText, errorText) {
    var statusCode = objectHelper.getValue(xhr, 'status');
    var supportedHttpStatus = _.findWhere(httpStatuses, {code: statusCode});
    var title = 'An error has occured';
    var message = 'The issue has been logged and we will investigate it ASAP';
    var buttons;

    if (objectHelper.getValue(xhr, 'responseJSON.error')) {
      if (supportedHttpStatus) {
        title = supportedHttpStatus.type;
      }
      message = objectHelper.getValue(xhr, 'responseJSON.error') || errorText;
    } else if (supportedHttpStatus) {
      title = supportedHttpStatus.type;
      message = supportedHttpStatus.message || message;
    } else {
      title = errorText;
    }

    if (_.contains(refreshableErrors, statusCode)) {
      buttons = {
        OK: {label: 'OK', className: 'btn btnPrimary'},
        refresh: {label: 'Refresh browser', className: 'btnDanger', callback: window.location.reload}
      };
    }

    this.notifyError(message, title, buttons);
  },

  notifyError: function(message, title, buttons) {
    title = title || '<span class="typeWarning">An error has occured</span>';
    buttons = buttons || {OK: {label: 'OK', className: 'btn btnPrimary'}};

    bootbox.dialog({
      title: title,
      message: message,
      buttons: buttons
    });
  }
};

module.exports = AjaxStateMixin;
