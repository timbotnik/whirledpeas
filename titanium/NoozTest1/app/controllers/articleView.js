var args = arguments[0] || {};
$.articleWebView.url = args.feedUrl || '';
$.customNav.getView('navLeftButton').title = " < ";
$.customNav.getView('navLeftButton').visible = true;
