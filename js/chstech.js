
function load_github_profile(data) {
	console.log(data);
	var div_id = 'person-'+data.login;
	$('#'+div_id+' .person-img').attr('src',data.avatar_url);
	$('#'+div_id+' .person-name').html(data.name);
}

$( document ).ready(
        function() {
                // lazy loading of images that are hosted offsite
                $('img.lazy').each(function(){
                	$(this).attr('src', $(this).attr('data-src')).removeClass('lazy');
        	});

		$('.person-github').each(function(){
			var api_url = '//api.github.com/users/' + $(this).attr('data-github');
			$.getJSON(api_url, {}, load_github_profile);
		});

	}
);
