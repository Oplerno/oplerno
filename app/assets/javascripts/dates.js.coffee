$ ->
	$("input#course_start_date").each (i) ->
		$(this).datepicker
			altFormat: "yy-mm-dd"
			dateFormat: "dd/mm/yy"
			altField: $(this).next()
