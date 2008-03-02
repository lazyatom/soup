$(document).ready(function() {

  $('a#add').click(function() {
    $('dl.attributes').append('<dt><input class="attribute_name" type="text"></input></dt><dd><textarea></textarea></dd>');
    return false;
  });

  $('input.attribute_name').change(function() {
    var dl_children = $('dl.attributes').children();
    var dt_index = dl_children.index(this.parentNode) + 1;
    var textarea_for_this = dl_children[dt_index].childNodes[0];
    textarea_for_this.name = this.value;
  });

});

