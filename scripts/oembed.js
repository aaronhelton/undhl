$(init);

function init() {
  //$( '#oePopover' ).hide();
  //var uProt = window.location.protocol;
  //var uHost = window.location.hostname;
  //var uPath = window.location.pathname;
  var encoded = encodeURIComponent(window.location.href);
  //var url = window.location.href;
  var disposition = 'item';
  if ($( 'div#aspect_discovery_SimpleSearch_div_search-results' ).length) {
    disposition = 'list';
  }
  var oeUrl = 'http://dag.un.org/services/oembed?url=' + encoded + '&maxheight=150&maxwidth=500&type=' + disposition;

  $.get(oeUrl, function(data) {
    if(data['html']) {
      $( '#oeCode' ).text( data['html'] );
      $( '#oePreview' ).html( data['html'] );
    }
  });
}

