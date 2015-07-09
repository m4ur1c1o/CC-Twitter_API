$(document).ready(function() {
	$('#tweet_form').submit(function(event){
		event.preventDefault();
		$('textarea').prop('disabled', true);
		$('#submit').prop('disabled', true);
		$('#alert h4').text("se esta procesando su petición.");
		var value = $('textarea').val();
		$.post("/tweet_ajax", { textarea: value }, function(data){
			 $('#alert h4').text(data);
		});

	});

});

