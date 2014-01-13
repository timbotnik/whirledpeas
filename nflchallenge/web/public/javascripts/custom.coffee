# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
	
	# some hover reactivity for the tabs
	
	$('.tabs li').hover ->
		$(this).find('h1, .icon').css({ opacity: .8 })
	, ->
		$(this).find('h1, .icon').css({ opacity: 1 })
		
	# switching the tabs
	
	$('.tabs .tablist li').click ->
		if !$(this).hasClass 'active'
			$(this).parent().find('.active').removeClass('active')
			$(this).addClass('active')

	# Custom scrollbar and radio buttons
		
	$('.tabs .content').jScrollPane()
	$('input').customInput()
	
	$('.jspContainer').css({ width: '684px', height: '274px' })
	
	# weird hacky thing to control the custom radio buttons
	$('.radio-1').parent().css({ float: 'right' })
	$('.radio-2').parent().css({ float: 'left' })
	
	# hilight area on select
	
	$('.radio-1 label, .radio-2 label').click ->
		$('.custom-radio').parent().css({ background: 'rgba(255, 255, 255, 0.3)' })
		$(this).parent().parent().css({ background: 'rgba(255, 255, 255, 0.5)' })
		
	# make the challenges look nice on hover
	
	$('.dropdown').hover ->
		$(this).find('.heading').css({ width: '660px' })
	, ->
		$(this).find('.heading').css({ width: '665px' })
		
	$('.featured .dropdown').hover ->
		$(this).find('.heading').css({ width: '640px' })
	, ->
		$(this).find('.heading').css({ width: '645px' })
		
	# slide down functionality for challenges - enormously huge, i know
		
	$('.dropdown .heading').click ->
		dd = $(this).parent()
		details = $(this).next(".details")
		$(this).addClass('current')
		
		$('.dropdown .heading').each ->			
			if $(this).parent().hasClass('down') && !$(this).hasClass('current')
				$(this).next(".details").slideUp()
				$(this).parent().removeClass('down')
				
				icon = $(this).prev()
				if icon.hasClass('contract')
					$(this).prev().removeClass('contract')
				else
					$(this).prev().addClass('contract')
			
		if dd.hasClass('down')
			details.slideUp()
			dd.removeClass('down')
			$(this).removeClass('current')
		else
			details.slideDown()
			dd.addClass('down')
			$(this).removeClass('current')
		
		icon = $(this).prev()
		if icon.hasClass('contract')
			$(this).prev().removeClass('contract')
		else
			$(this).prev().addClass('contract')
			
	$('.dropdown .expand, .dropdown .contract').click ->
		
		dd = $(this).parent()
		details = $(this).next().next()
		$(this).next().addClass('current')
		
		$('.dropdown .heading').each ->			
			if $(this).parent().hasClass('down') && !$(this).hasClass('current')
				$(this).next(".details").slideUp()
				$(this).parent().removeClass('down')
				
				icon = $(this).prev()
				if icon.hasClass('contract')
					$(this).prev().removeClass('contract')
				else
					$(this).prev().addClass('contract')

		if dd.hasClass('down')
			details.slideUp()
			dd.removeClass('down')
			$(this).next().removeClass('current')
		else
			details.slideDown()
			dd.addClass('down')
			$(this).next().removeClass('current')

		icon = $(this)
		if icon.hasClass('contract')
			icon.removeClass('contract')
		else
			icon.addClass('contract')
	
	# call the wonderful plugin on tagged select boxes
	
	$('select.player-challenge').sweetSelect()
	$('select.game-pick').sweetSelect("Select a game and challenge")
	$('select.game-select').sweetSelect()
	$('select.game-challenge').sweetSelect()
	$('select.challenge1').sweetSelect()
	$('select.team-challenge').sweetSelect()
	$('select.team-pick').sweetSelect()
	$('select.stakes-drop').sweetSelect("Set your stakes")
	
	# emphasize the custom stakes option on stakes dropdowns, make the input box appear on click
	
	$('.stakes-drop-custom .options li:first-child').css({ 'font-weight' : 'bold', 'color' : '#F9BA29' })
	$('.stakes-drop-custom .options li:first-child').live 'mouseup', ->
		search_field = "<input class='custom-stakes-field' placeholder='Time to up the ante...' />";
		input = $(this).closest('.row').find('custom-stakes-field');
		$(this).closest('.row').append(search_field);
		input.hide()
		$(this).closest('.stakes-drop-custom').hide();
		input.fadeIn();
	
	# zebra stripe the rows in 'build your challenge'
	$('.actions li.row:nth-child(even)').css({ background: '#C6C6C6' })
	
	# The 'getting started' modal
	# $('.gs').click ->
	# 	$('.body-overlay').fadeIn()
	# 	$('.getting-started').css({ 'z-index': '101' })
	# 	$('.getting-started').animate({ opacity: '1', top: '60px' })
	# 	
	# 	$('.close').click ->
	# 		$('.body-overlay').fadeOut()
	# 		$('.getting-started').animate({ opacity: '0' }, 200, ->
	# 			$('.getting-started').css({ 'z-index': '-101', top: 0 })
	# 		)
			
	# small fix for featured challenges page
	$('.btn-red').each ->
		if $(this).prev().hasClass('decision-maker-featured')
			$(this).css({ 'margin-top': '7px', 'margin-right': '10px' })
			
	$('.featured_challenge').each ->
		$(this).sweetSelect()
		
	# auto-center the dropdowns on challenge pages
	
	# on page load
	if !$('.hilight-box .center').hasClass('spc1')
		$('.hilight-box .center').css({ width: 'auto' })
		initial_width = $('.custom-select').width()
		if initial_width < 165 # because there's a weird bug with really short values
			initial_width = 75
		$('.hilight-box .center').css({ width: initial_width + initial_width/22 })
	
	# on select
	$('.hilight-box .center .custom-select li').click ->
		if !$(this).hasClass('spc1')
			$('.hilight-box .center').css({ width: 'auto' })
			wth = $(this).closest('.custom-select').width()
			console.log wth

			$('.hilight-box .center').css({ width: wth })
			
		
		
		
		
		
			