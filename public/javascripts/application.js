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
