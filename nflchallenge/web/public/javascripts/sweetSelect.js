(function() {
  var $;
  $ = jQuery;
  $.fn.sweetSelect = function(default_value) {
    var arrow_down, custom_build, custom_drop, options, options_section;
    options = [];
    this.find('option').each(function() {
      var pair;
      pair = [];
      pair.push($(this).text());
      pair.push($(this).val());
      return options.push(pair);
    });
    if (default_value === void 0) {
      if (options[0]) {
        default_value = options[0][0];
      } else {
        default_value = null;
      }
    }
    custom_build = "<div class='custom-select'>					  <div class='box'>" + default_value + "</div>					  <span class='divider'></span>					  <span class='arrow'></span>					  <ol class='options'></ol>				   </div>";
    this.after(custom_build);
    custom_drop = this.next();
    custom_drop.append(this);
    custom_drop.addClass(this.attr('class') + "-custom");
    options_section = custom_drop.find('.options');
    $.each(options, function() {
      return options_section.append(("<li data-val='" + this[1] + "'>") + this[0] + "</li>");
    });
    arrow_down = false;
    custom_drop.find('.options').hide();
    custom_drop.click(function() {
      $(this).find('.options').slideToggle();
      if (!arrow_down) {
        $(this).find('.arrow').css({
          '-webkit-transform': 'rotate(-180deg)'
        });
        return arrow_down = true;
      } else {
        $(this).find('.arrow').css({
          '-webkit-transform': 'rotate(0deg)'
        });
        return arrow_down = false;
      }
    });
    custom_drop.find('.options li:nth-child(even)').addClass('stripe');
    return custom_drop.find('.options li').click(function() {
      var txt, val;
      txt = $(this).text();
      val = $(this).data(val).val;
      $(this).parent().parent().find('.box').text(txt);
      return $(this).parent().parent().find('select').val(val);
    });
  };
}).call(this);
