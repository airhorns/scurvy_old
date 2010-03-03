// document.observe("dom:loaded", function() {
//   // the element in which we will observe all clicks and capture
//   // ones originating from pagination links
// 	$$('a.synopsis').each(function(link){
// 		Event.observe(link, 'click', function(event){
// 			console.log(this.next());
// 			this.next().toggle();
// 		})
// 	});
// 	var container = $(document.body)
//
//   if (container) {
//     var img = new Image
//     img.src = '/images/spinner.gif'
//
//     function createSpinner() {
//       return new Element('img', { src: img.src, 'class': 'spinner' })
//     }
//
//     container.observe('click', function(e) {
//       var el = e.element()
//       if (el.match('.pagination a')) {
//         el.up('.pagination').insert(createSpinner())
//         new Ajax.Request(el.href, { method: 'get' })
//         e.stop()
//       }
//     })
//   }
// })
jQuery(function($) {
    //on document ready
    //Live link update
    $('a[update],form[update]').live('ajax:success', function (e, data, status, xhr) {
        $('#'+$(e.target).attr('update')).html(data);
		$('span.xhrstatus').fadeOut(1000);
    });

    //autocomplete
    $('input.autocomplete').each(function() {
        var input = $(this);
        input.data('orginial_value', input.val());
        var mustMatch = 1;
        if (input.hasClass("quicksearch")) {
            input.blur(function(e) {
                $(e.target).removeClass('focused').val(input.data('orginial_value'));
            })
            input.focus(function(e) {
                $(e.target).addClass('focused').val("");
            })
            input.result(function(event, data, formatted) {
                window.location = $(event.target).attr('basepath') + "/" + formatted.split(" --- ")[1];
            });
            mustMatch = 0;
        }
        if (typeof input.attr('update') == 'string') {
            input.result(function(event, data, formatted) {
                console.log(data);
                $(input.attr('update')).val(data[0].split(" --- ")[1]);
            });
        }

        input.autocomplete(input.attr('autocomplete_url'), {
            matchContains: 1,
            //also match inside of strings when caching
            mustMatch: mustMatch,
            //allow only values from the list
            selectFirst: 1,
            //select the first item on tab/enter
            removeInitialValue: 0,
            //when first applying $.autocomplete
            formatItem: function(data, i, n, value) {
                return value.split(" --- ")[0];
            },
            formatMatch: function(data, i, n, value) {
                return value.split(" --- ")[0];
            },
            formatResult: function(data, value) {
                return value.split(" --- ")[0];
            }
        })
    });

	//IMDB doo dad on movie edit
	$('#imdbedit').live('click', function(e) {
		//Show container for IMDB ID entry form
		imdb = $('#imdb');
	    if (imdb) {
	        $("#imdbchange").html('<img src="/images/loader.gif">');
	        imdb.show();
	    }
	})
	$('#imdbfetchform').live('submit', function(e) {
		//Show container for IMDB details to come up
		imdb = $('#imdbresults');
	    if (imdb) {
	        $("#imdbresults").html('<img src="/images/loader.gif">');
	        imdb.show();
	    }
	})
	function copyIMDBFromLinkAttributes(link) {
		input = $('#'+link.attr('movie_attr'));
		console.log(input);
		input.val(link.attr('movie_value'));
		input.effect("highlight", {}, 2000);
	}
	$('.imdbcopy').live('click', function(e) {
		copyIMDBFromLinkAttributes($(e.target));
		return false;
	});
	$('.imdbcopyall').live('click', function(e) {
		$('.imdbcopy').each(function(i, link){
			copyIMDBFromLinkAttributes($(link));
		});
		return false;
	});
	
	$('.approvalbutton').live('ajax:success', function(e, data, status, xhr) {
		console.log(e.target);
		$(e.target).parents('.download').slideUp();
	});
});