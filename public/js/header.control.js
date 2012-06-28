// hover functionality
$('.header-cat').hover(function () {
	$(this).addClass('header-cat-hover');
}, function () {
	$(this).removeClass('header-cat-hover');
})

// click functionality
$('#header .home').click(function () {window.location = '/'});
$('#header .general').click(function () {window.location = '/general'})
$('#header .classes').click(function () {window.location = '/classes'})
$('#header .simulator').click(function () {window.location = '/simulator'})
$('#header .my-chars').click(function () {window.location = '/my-chars'})