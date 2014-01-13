$ = jQuery
$.fn.sweetSelect = (default_value) ->
	
	# grab all the values out of the select box and store them
	options = []
	this.find('option').each ->
		pair = []
		pair.push $(this).text()
		pair.push $(this).val()
		options.push pair

	# if no provided default text, use the first option
	if default_value == undefined
		if options[0]
			default_value = options[0][0]
		else
			default_value = null
	
	# build the custom dropdown box
	custom_build = "<div class='custom-select'>
					  <div class='box'>"+ default_value + "</div>
					  <span class='divider'></span>
					  <span class='arrow'></span>

					  <ol class='options'></ol>
				   </div>"
				
	this.after(custom_build) # append the custom box after the select
	custom_drop = this.next() # store the recently appended custom select
	custom_drop.append(this) # pop the vanilla select box into the custom div
	custom_drop.addClass(this.attr('class') + "-custom")
	
	# populate the custom select box with the given options
	options_section = custom_drop.find('.options')
	$.each(options, ->
		options_section.append("<li data-val='#{this[1]}'>" + this[0] + "</li>")
	)

	# drop em down
	arrow_down = false
	custom_drop.find('.options').hide()
	custom_drop.click ->
		$(this).find('.options').slideToggle()
		if !arrow_down
			$(this).find('.arrow').css({ '-webkit-transform': 'rotate(-180deg)' })
			arrow_down = true
		else
			$(this).find('.arrow').css({ '-webkit-transform': 'rotate(0deg)' })
			arrow_down = false
		# $(this).find('.options').jScrollPane()

	# zebra stripe em
	custom_drop.find('.options li:nth-child(even)').addClass('stripe')

	# when you select a value, put it up top and reflect the change in the default select
	custom_drop.find('.options li').click ->
		txt = $(this).text()
		val = $(this).data(val).val
		$(this).parent().parent().find('.box').text(txt)
		$(this).parent().parent().find('select').val(val)
