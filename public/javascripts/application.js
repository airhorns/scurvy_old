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

jQuery(function($){//on document ready
  //autocomplete
  $('input.autocomplete').each(function(){
    var input = $(this);
	input.data('orginial_value', input.val());
	
	input.autocomplete(input.attr('autocomplete_url'),{
		matchContains:1,//also match inside of strings when caching
		mustMatch:1,//allow only values from the list
		selectFirst:1, //select the first item on tab/enter
		removeInitialValue:0,//when first applying $.autocomplete
		formatItem: function(data, i, n, value) {
			return value.split(" --- ")[0];
		},
		formatMatch: function(data, i, n , value) {
			return value.split(" --- ")[0];
		},
		formatResult: function(data, value) {
			return value.split(" --- ")[0];
		}
    })
	if (input.hasClass("quicksearch")) {
		input.blur(function(e) {
			$(e.target).removeClass('focused').val(input.data('orginial_value'));
		})
		input.focus(function(e) {
			$(e.target).addClass('focused').val("");
		})
		input.result(function (event, data, formatted) {
			window.location = $(event.target).attr('basepath')+"/"+formatted.split(" --- ")[1];
		});
	}
	if (typeof input.attr('update') == 'string') {
		input.result(function (event, data, formatted) {
			console.log(data);
			$(input.attr('update')).val(data[0].split(" --- ")[1]);
		});
	}
  }); 
});
