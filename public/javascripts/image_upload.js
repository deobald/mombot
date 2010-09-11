
$('#uploadForm input').change(function(){
 $(this).parent().ajaxSubmit({
  beforeSubmit: function(a,f,o) {
   o.dataType = 'json';
  },
  complete: function(XMLHttpRequest, textStatus) {
   // XMLHttpRequest.responseText will contain the URL of the uploaded image.
   // Put it in an image element you create, or do with it what you will.
   // For example, if you have an image elemtn with id "my_image", then
   //  $('#my_image').attr('src', XMLHttpRequest.responseText);
   // Will set that image tag to display the uploaded image.
  },
 });
});
