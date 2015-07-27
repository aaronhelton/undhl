$(init);

function init() {
  //$( '#oePopover' ).hide();
  var uProt = window.location.protocol;
  var uHost = window.location.hostname;
  var uPath = window.location.pathname;
  var url = window.location.href;
  var oeUrl = 'http://dag.un.org/services/oembed?url=' + uProt + uHost + uPath + '&maxheight=150&maxwidth=500';

  $.get(oeUrl, function(data) {
    if(data['html']) {
      $( '#oeCode' ).text( data['html'] );
      $( '#oePreview' ).html( data['html'] );
    }
  });
}

