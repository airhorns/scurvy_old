$(function(){
		   $('tr:odd').addClass('odd');
		   $('.quick-links').hide();
		   $('.quicks').click(function(){
				$('.quick-links').slideToggle('fast');
		   });
		   $('#mytable').tablesorter({widgets: ['zebra']});
});