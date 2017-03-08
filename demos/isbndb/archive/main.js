var API_KEY = 'your_key_here';
var elResults = document.getElementById('results');
document.addEventListener('DOMContentLoaded',function(){
	document.getElementById('search').addEventListener('submit',function(event){
		event.preventDefault();
		$.ajax({
			url: 'http://isbndb.com/api/v2/json/'+API_KEY+'/books',
			method: 'GET',
			dataType: 'json',
			data: {
				q: document.getElementById('book').value
			},
			complete: function(data){
				console.log(data);
			}
		});
	});
});