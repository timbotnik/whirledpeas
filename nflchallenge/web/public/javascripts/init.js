var FB_ON     = false;
var APP_ID    = '266077590075606';
var ACC_TOK   = 0;
var REQUESTS  = [];

function sortByName(a, b) {
    var x = a.name.toLowerCase();
    var y = b.name.toLowerCase();
    return ((x < y) ? -1 : ((x > y) ? 1 : 0));
}

function inviteFriends() {
  if (USER.id == '0') {
    initConnect();
    return;
  }
  
  FB.ui({
    method: 'apprequests', 
    message: CHALLENGE.challenge.challenge_expression, 
    data: CHALLENGE.challenge.id
  },function(response) {
    if (response && response.request_ids) {
      $.each(response.request_ids,function(i,id) {
        /* Get User IDs */
        FB.api(id+'?access_token='+USER.token, function(resp){
          var fb_id = resp.to.id;
          var challenge_id = resp.data;
          var req_id = resp.id;    
          /* Save Invitations */    
          API({
            call:'api/challenges/invite/'+challenge_id,
            dataMethod:'POST',
            async:true,
            data: {
              data: {
                fb_number : fb_id,
                request_id : req_id
              }
            },
            response:function(resp,args) { }
          });
        });
      });
    }
  });
  
  /* Old Friend Invites, May reuse 

  $('body').append(
    '<div class="overlay">'+
    ' <div class="holder">'+
    '  <ul><li>Loading...</li></ul>'+
    ' <div class="button" id="close_invitations" style="float: right; margin-top: 5px;">Close Invitations</div>'+
    ' <div class="clear"></div>'+
    ' </div>'+
    '</div>'
  );

  $('div.overlay div.holder').css('marginTop',$(window).height()/2-$('div.overlay div.holder').height()/2);
  $('#close_invitations').unbind('mousedown').mousedown(function() { $('.overlay').fadeOut('slow',function(){ $(this).remove(); }); })
  
  FB.api('/me/friends?access_token='+USER.token, function(resp){
    $('div.overlay ul').empty();
    
    var friends = resp.data.sort(sortByName)
    
    $.each(friends,function(i,friend) {
      $('div.overlay ul').append(
        '<li id="'+friend.id+'">'+
        ' <div class="thumb" style="background-image: url(https://graph.facebook.com/'+ friend.id+'/picture)"></div>'+
        ' <span>'+friend.name+'</span>'+
        ' <div class="clear"></div>'+
        '</li>');
    });

    $('div.overlay ul li').unbind('mousedown').mousedown(function() {
      var friend_id = $(this).attr('id');

      FB.ui({
        method:       'stream.publish',
        title:        'Courtesy of Bloomberg Sports',
        name:         CHALLENGE.challenge.challenge_expression,
        description:  USER.nickname +' thinks they\'re the NFL expert! Show them who\'s boss by winning the challenge!',
        action_links: [{
            text: 'Take the Challenge!',
            href: 'http://apps.facebook.com/bloombergsports/challenges/'+ CHALLENGE.challenge.id +'/'
        }],
        link: 'http://apps.facebook.com/bloombergsports/challenges/'+ CHALLENGE.challenge.id+'/',
        from: USER.id,
        to:   friend_id
      },
      function(response) {
        if (response && response.post_id) {
          API({
            call:'api/challenges/invite/'+CHALLENGE.challenge.id,
            dataMethod:'POST',
            async:true,
            data: {
              data: {
                fb_number : friend_id
              }
            },
            response:function(resp,args) {
              if (resp.success)
                alert('Your friend has been invited!')
            }
          });
        } else {
          // Nothing
        }
      });
    })
  });
  */
}

function fbConnect() {
  window.fbAsyncInit = function() {
    FB.init({appId: APP_ID, status: true, cookie: true, xfbml: true});
    
    FB.Event.subscribe('auth.login', function(response) {
      setToken(response,true);
      postLoad();
    });
		
    FB.Canvas.setSize();
    
    FB.Event.subscribe('auth.logout', function(response) {
      FB_ON = false;
      //processRequests();
      postLoad();
    });

    FB.getLoginStatus(function(response) {
      if (response.session) {
        setToken(response,false);
      } else {
        FB_ON = false;
      }
      postLoad();
    });
  };

  (function() {
      var e   = document.createElement('script');
      e.type  = 'text/javascript';
      e.src   = document.location.protocol +'//connect.facebook.net/en_US/all.js';
      e.async = true;
      document.getElementById('fb-root').appendChild(e);
  }());
  
  $('.sign-out').mouseup(function() { 
    FB.logout(function(response) { 
      document.location.href = '/welcome/logout';
    })
  })
}

function initConnect() {
  FB.login(function(response) {
    if (response.session) {
      if (response.perms) {
        //setToken(response);
      } else {
        FB_ON = false;
      }
    }
  },
  {perms:'read_stream,publish_stream,user_about_me,user_birthday,user_photos,email,read_friendlists,offline_access'});
}

function setToken(obj,process) {
  FB_ON   = true;
  ACC_TOK = obj.session.access_token;
  document.cookie='access_token'+ "=" +ACC_TOK;
  if (process == undefined)
    process = false;
  // alert((USER.token != ACC_TOKEN));
  //console.log(USER.token + ' = ' + ACC_TOK)
  if (USER.token != ACC_TOK) {
    FB.api('/me', function(resp) {
      USER.token    = obj.session.access_token;
      USER.id       = obj.session.uid;
      USER.nickname = resp.name;
      
      var data      = {
        data: {
          fb_number:  obj.session.uid,
          fb_token:   obj.session.access_token,
          email:      resp.email,
          nickname:   resp.name
        }
      }
      
      // var url = document.location.toString();
      // console.log(url.indexOf('/login/'));
      // if (url.indexOf('/login/') != -1) {
      //   console.log('GO!');
      //   document.location.href = gup('next');
      // }

      API({
        call:       'api/users/create',
        dataMethod: 'POST',
        data:       data,
        async:      false,
        response:function(resp,args) {
          if (!resp.success)  { alert(resp.message);  }
          else                { if (process) processRequests();    }

          // Reload challenge page if required.
          var url = document.location.toString();
          if (url.indexOf('/challenges/') != -1) {
            if(confirm('We\'ve found your account. Press OK to load up your stats.'))
              document.location.reload();
          }
        }
      });
    });
  }
  else {
    processRequests();
  }
}

function postLoad() {
  if (FB_ON) {
    $('h2#header').empty().append('<a href="/welcome/history/">History</a> <a href="/welcome/logout">Sign Out</a>');
  } else {
    $('h2#header').empty().append('<a href="javascript:initConnect();">Sign In</a>');
  }
}

function processRequests() {
  if (REQUESTS.length) {
    $.each(REQUESTS, function(i, request) {
      setTimeout(function() { API(request); }, 250);
    });
    
    REQUESTS = [];
  }
}

function API(args) {
  if (args.dataType   == undefined) args.dataType   = 'json';
  if (args.dataMethod == undefined) args.dataMethod = 'GET';
  if (args.data       == undefined) args.data       = { };
  if (args.response   == undefined) args.response   = alert;
  if (args.async      == undefined) args.async      = false;

  $.ajax({
    url:      '/'+args.call+'?d='+this.timestamp(),
    type:     args.dataMethod,
    data:     args.data,
    dataType: args.dataType,
    async:    args.async,
    error: function(XMLHttpRequest,textStatus,errorThrown) {
      args.response({status:0,message:'You must be logged in to do this.',data:{}},args);
    },
    success: function(data, textStatus, XMLHttpRequest) {
      args.response(data,args);
    }
  });
}

function timestamp() {
  var date = new Date();
  return (date.getTime());
}

function gup(name)
{
  name = name.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
  var regexS = "[\\?&]"+name+"=([^&#]*)";
  var regex = new RegExp( regexS );
  var results = regex.exec( window.location.href );
  if( results == null )
    return '';
  else
    return results[1];
}