$(document).ready(function() {
	$('#tweet_form').submit(function(event){
		event.preventDefault();
		$('textarea').prop('disabled', true);
		$('#submit').prop('disabled', true);
		$('#alert h4').text("se esta procesando su petición.");
		var value = $('textarea').val();
		$.post("/tweet_ajax", { textarea: value }, function(jid){
			// $('#alert h4').text(jid);
			console.log(jid);
			tweetStatus(jid);







			// $.get("/status/" + data, function(status){
			//  	if (status == "true"){
			//  		$('#alert h4').text("Tu tweet fue enviado");
			//  	} else {
			//  		// $('#alert h4').text("Tu tweet NO fue enviado");
			//  		setTimeout(function(){

			//  		}, 2000);
			//  	}
			// });
		});

	});

});








var count = 0;


function tweetStatus(jid) {
	$.get("/status/" + jid, function(status){
		console.log(status);
	 	if (status == "true"){
	 		$('#alert h4').text("Tu tweet fue enviado");
	 	} else {
	 		count = count + 1;
	 		console.log("jid" + count);
	 		// $('#alert h4').text("Tu tweet NO fue enviado");
	 		setTimeout(function(){
	 			tweetStatus(jid);
	 		}, 2000);
	 	}
	});
}







