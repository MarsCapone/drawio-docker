/** 
 * These are the onpage modals that were previously in the _partial.html file
 * 
 * It should be an array of strings. Each string should be valid HTML, and
 * to be used must (eventually) have a unique id, and a class of 'modal'.
 *
 * In order to inject dynamic content, a function that immediately executes
 * may be used.
 */
Modals = [
  '<div id="include" class="modal">\
    <h1>Included title</h1>\
    <p>Included text</p>\
  </div>',

  (function() {
    return '<div id="include2" class="modal"></div>';
  })(),
]
