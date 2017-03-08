var elResults;
document.addEventListener('DOMContentLoaded',function(){
	elResults = document.getElementById('results');
	
	document.getElementById('search').addEventListener('submit',function(event){
		event.preventDefault();
		$.ajax({
			url: '/',
			method: 'POST',
			dataType: 'json',
			data: {
				q: document.getElementById('book').value
			},
			success: function(response){
				//reset the results
				elResults.innerHTML = "";
				// loop over the response data and update the page
				response.data.forEach(function(c){
					elResults.innerHTML += '<li>' + c.title + '</li>';
				});
			}
		});
	});
});