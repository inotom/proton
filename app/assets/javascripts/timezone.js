/* jshint strict: true */

(function($) {
  'use strict';
  $(function() {
    $.ajaxSetup({ cache: false });
    document.cookie = 'tzoffset=' + (new Date()).getTimezoneOffset();
  });
})(jQuery);
