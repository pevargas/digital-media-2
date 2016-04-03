$(function() {
 /* Cool Navigation Bar BEGIN */
  $( '#navbar a' ).bind( 'click', function( e ) {
      e.preventDefault();
      var $anchor = $( this );
      
      $( 'html, body' ).stop( ).animate({
        scrollTop: $( $anchor.attr( 'href' ) ).offset( ).top - 130
      }, 1000,'easeInOutExpo');
  });
  /* Cool Navigation Bar END */
});