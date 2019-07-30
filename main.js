Object.assign(Interception, {

  /* Interception.edge(edge_text, is_ex_mode); */
  edge: function (e, b) {
    if (!b) { return; } // this is when ex mode is closed.

    // e is a jquery object for the text div of each edge (this function is 
    // called once per edge (per second? not sure))
    
    var split = e.text().split('::');

    // either the text was something like "Hello World", or it was 
    // "edge-text::foobar". In the former, we don't want to do anything, 
    // in the latter, we want to do something with foobar.
    
    if (split.length > 1) {
      // there are at least two things
      var content = split[1];

      // we could use that value to request another
      // say we had a PHP file containing:
      //    <?php echo json_encode( array( "name"=>"John","time"=>"2pm" ) ); ?>
      // we could fetch that and set the text
      //
      // $.get('test.php', function(data) {
      //   e.text('Meeting ' + data.name + ' at ' + data.time);
      // }, 'json');
      //
      // as a simple action, we'll just set the text to the second part.
      
      e.text(content);

    }

    // finally we should remember to show the text.
    e.show();
  },

};

