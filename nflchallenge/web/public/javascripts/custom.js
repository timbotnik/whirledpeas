(function() {
  $(function() {
    var initial_width;
    $('.tabs li').hover(function() {
      return $(this).find('h1, .icon').css({
        opacity: .8
      });
    }, function() {
      return $(this).find('h1, .icon').css({
        opacity: 1
      });
    });
    $('.tabs .tablist li').click(function() {
      if (!$(this).hasClass('active')) {
        $(this).parent().find('.active').removeClass('active');
        return $(this).addClass('active');
      }
    });
    $('.tabs .content').jScrollPane();
    $('input').customInput();
    $('.jspContainer').css({
      width: '684px',
      height: '274px'
    });
    $('.radio-1').parent().css({
      float: 'right'
    });
    $('.radio-2').parent().css({
      float: 'left'
    });
    $('.radio-1 label, .radio-2 label').click(function() {
      $('.custom-radio').parent().css({
        background: 'rgba(255, 255, 255, 0.3)'
      });
      return $(this).parent().parent().css({
        background: 'rgba(255, 255, 255, 0.5)'
      });
    });
    $('.dropdown').hover(function() {
      return $(this).find('.heading').css({
        width: '660px'
      });
    }, function() {
      return $(this).find('.heading').css({
        width: '665px'
      });
    });
    $('.featured .dropdown').hover(function() {
      return $(this).find('.heading').css({
        width: '640px'
      });
    }, function() {
      return $(this).find('.heading').css({
        width: '645px'
      });
    });
    $('.dropdown .heading').click(function() {
      var dd, details, icon;
      dd = $(this).parent();
      details = $(this).next(".details");
      $(this).addClass('current');
      $('.dropdown .heading').each(function() {
        var icon;
        if ($(this).parent().hasClass('down') && !$(this).hasClass('current')) {
          $(this).next(".details").slideUp();
          $(this).parent().removeClass('down');
          icon = $(this).prev();
          if (icon.hasClass('contract')) {
            return $(this).prev().removeClass('contract');
          } else {
            return $(this).prev().addClass('contract');
          }
        }
      });
      if (dd.hasClass('down')) {
        details.slideUp();
        dd.removeClass('down');
        $(this).removeClass('current');
      } else {
        details.slideDown();
        dd.addClass('down');
        $(this).removeClass('current');
      }
      icon = $(this).prev();
      if (icon.hasClass('contract')) {
        return $(this).prev().removeClass('contract');
      } else {
        return $(this).prev().addClass('contract');
      }
    });
    $('.dropdown .expand, .dropdown .contract').click(function() {
      var dd, details, icon;
      dd = $(this).parent();
      details = $(this).next().next();
      $(this).next().addClass('current');
      $('.dropdown .heading').each(function() {
        var icon;
        if ($(this).parent().hasClass('down') && !$(this).hasClass('current')) {
          $(this).next(".details").slideUp();
          $(this).parent().removeClass('down');
          icon = $(this).prev();
          if (icon.hasClass('contract')) {
            return $(this).prev().removeClass('contract');
          } else {
            return $(this).prev().addClass('contract');
          }
        }
      });
      if (dd.hasClass('down')) {
        details.slideUp();
        dd.removeClass('down');
        $(this).next().removeClass('current');
      } else {
        details.slideDown();
        dd.addClass('down');
        $(this).next().removeClass('current');
      }
      icon = $(this);
      if (icon.hasClass('contract')) {
        return icon.removeClass('contract');
      } else {
        return icon.addClass('contract');
      }
    });
    $('select.player-challenge').sweetSelect();
    $('select.game-pick').sweetSelect("Select a game and challenge");
    $('select.game-select').sweetSelect();
    $('select.game-challenge').sweetSelect();
    $('select.challenge1').sweetSelect();
    $('select.team-challenge').sweetSelect();
    $('select.team-pick').sweetSelect();
    $('select.stakes-drop').sweetSelect("Set your stakes");
    $('.stakes-drop-custom .options li:first-child').css({
      'font-weight': 'bold',
      'color': '#F9BA29'
    });
    $('.stakes-drop-custom .options li:first-child').live('mouseup', function() {
      var input, search_field;
      search_field = "<input class='custom-stakes-field' placeholder='Time to up the ante...' />";
      input = $(this).closest('.row').find('custom-stakes-field');
      $(this).closest('.row').append(search_field);
      input.hide();
      $(this).closest('.stakes-drop-custom').hide();
      return input.fadeIn();
    });
    $('.actions li.row:nth-child(even)').css({
      background: '#C6C6C6'
    });
    $('.btn-red').each(function() {
      if ($(this).prev().hasClass('decision-maker-featured')) {
        return $(this).css({
          'margin-top': '7px',
          'margin-right': '10px'
        });
      }
    });
    $('.featured_challenge').each(function() {
      return $(this).sweetSelect();
    });
    if (!$('.hilight-box .center').hasClass('spc1')) {
      $('.hilight-box .center').css({
        width: 'auto'
      });
      initial_width = $('.custom-select').width();
      if (initial_width < 165) {
        initial_width = 75;
      }
      $('.hilight-box .center').css({
        width: initial_width + initial_width / 22
      });
    }
    return $('.hilight-box .center .custom-select li').click(function() {
      var wth;
      if (!$(this).hasClass('spc1')) {
        $('.hilight-box .center').css({
          width: 'auto'
        });
        wth = $(this).closest('.custom-select').width();
        console.log(wth);
        return $('.hilight-box .center').css({
          width: wth
        });
      }
    });
  });
}).call(this);
