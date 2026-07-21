window.awe = window.awe || {};
var is_load = 0;
function productsCallback (){
		$(document).find(".starbaprv-preview-badge").each(function (a) {
				$(this).find(".starbap-prev-badge").length == 0 &&
				$(this).append('<div class="starbap-prev-badge" data-average-rating="0" data-number-of-reviews="0"><a class="starbap-star starbap--off"><i class="fa fa-star fa-fw"></i></a><a class="starbap-star starbap--off"><i class="fa fa-star fa-fw"></i></a><a class="starbap-star starbap--off"><i class="fa fa-star fa-fw"></i></a><a class="starbap-star starbap--off"><i class="fa fa-star fa-fw"></i></a><a class="starbap-star starbap--off"><i class="fa fa-star fa-fw"></i></a><span class="starbap-prev-badgetext">0 đánh giá</span></div>');
		});
		if(typeof ProductReviews !== 'undefined' && ProductReviews){
			ProductReviews.init()
		}
}
    $( document ).ready(function() {
       setTimeout(function() {
      	$(".list-variants-img").each( function(){
          var $carouselItemsNextNew = $(this).find("li");
          var totalItemsNextNew = $carouselItemsNextNew.length;
          if(totalItemsNextNew >= 6 ){
            $(this).addClass("style-color")
            $(this).parents(".select-color").addClass("color-block")
          }
  
        })
       },500)
      $("body").on("click",".carousel-control-next",function(){
        var $carouselInnerNext = $(this).siblings("ul");
        var $carouselItemsNext = $carouselInnerNext.children("li");
        var totalItemsNext = $carouselItemsNext.length;
        var itemWidth = $carouselItemsNext.outerWidth();
        var totalWidth = itemWidth * totalItemsNext;
        var currentIndexNext = 0;
        $carouselInnerNext.css('width', totalWidth );
        function showCarouselItemNext(index) {
             if(totalItemsNext >= 8 ){
               var newTransformValue = -index * (itemWidth + 102) + 'px';
             }else if(totalItemsNext == 7){
               var newTransformValue = -index * (itemWidth + 65) + 'px';
             }else if(totalItemsNext == 6){
               var newTransformValue = -index * (itemWidth * 2) + 'px';
             }
        $carouselInnerNext.css('transform', 'translateX(' + newTransformValue + ')');
        currentIndexNext = index;
        }
         var nextIndexNext = (currentIndexNext + 1) % totalItemsNext;
           showCarouselItemNext(nextIndexNext);
        $carouselInnerNext.css("overflow", "initial")
        $(this).parents(".select-color").removeClass("color-block")
        $(this).parents(".select-color").addClass("color-prev")
    });
        $("body").on("click",".carousel-control-prev",function(){
        var $carouselInnerPrev = $(this).siblings("ul");
        var $carouselItemsPrev = $carouselInnerPrev.children("li");
        var totalItemsPrev =  $carouselItemsPrev.length;
          if ($(window).width() <= 768 && $(window).width() > 480 ) {
             $carouselInnerPrev.css('width', 168 ); 
          }else if ($(window).width() <= 480 && $(window).width() > 390 ) {
             $carouselInnerPrev.css('width', 155 ); 
          }else if( $(window).width() <= 390  && $(window).width() > 375 ){
             $carouselInnerPrev.css('width', 124 );
          }else if( $(window).width() <= 375 &&  $(window).width() > 360 ){
            $carouselInnerPrev.css('width', 120 );
          }else if( $(window).width() <= 360 && $(window).width() > 320 ){
             $carouselInnerPrev.css('width', 120 );
          }else if( $(window).width() <= 320){
             $carouselInnerPrev.css('width', 98 );
          }
        $carouselInnerPrev.css('transform', 'translateX(0%)');
        $carouselInnerPrev.css("overflow", "hidden")
        $(this).parents(".select-color").addClass("color-block")
        $(this).parents(".select-color").removeClass("color-prev")
    });

    })
function awe_tab() {
	$(".e-tabs:not(.not-dqtab)").each( function(){
		$(this).find('.tabs-title li:first-child').addClass('current');
		$(this).find('.tab-content').first().addClass('current');
		$(this).find('.tabs-title:not(.tab-ajax) li').click(function(e){
			var tab_id = $(this).attr('data-tab');
			var url = $(this).attr('data-url');
			var tab_content = $(this).parents('.e-tabs').siblings('.e-tabs')
			$(this).closest('.e-tabs').find('.tab-viewall').attr('href',url);
			$(this).closest('.e-tabs').find('.tabs-title li').removeClass('current');
			tab_content.find('.tab-content').removeClass('current');
			$(this).addClass('current');

			tab_content.find("#"+tab_id).addClass('current');
		});    
	});
	$('#section_product_default .tabs-title.tab-ajax li').click(function(e){
		var tab_id = $(this).attr('data-tab');
		var url = $(this).attr('data-url');
		var tab_content = $(this).parents('.e-tabs').siblings('.e-tabs');
		if($(this).parents('.tabs-title').hasClass('tab-title-mb')){
			tab_content =  $(this).parents('.e-tabs');
		}
		$(this).closest('.e-tabs').find('.tabs-title li').removeClass('current');
		tab_content.find('.tab-content').removeClass('current');
		$(this).addClass('current');
		tab_content.find('.tab-content[data-id="'+tab_id+'"]').addClass('current');
		if($(this).parents('.tabs-title').hasClass('tab-ajax')){
			tab_content.find('.tab-content[data-id="'+tab_id+'"]').find('.tab-product-owl').slick('unslick');
			tab_content.find('.tab-content[data-id="'+tab_id+'"]').find('.tab-product-owl').slick({
				dots: false,
				arrows: true,
				infinite: false,
				slidesToShow: 4,
				slidesToScroll: 2,
        rows: 1,
        autoHeight: true,
        lazyLoad:true,
        responsive: [
					{
						breakpoint: 1200,
						settings: {
							slidesToShow: 4,
							slidesToScroll: 2,
              lazyLoad:true,
						}
					},
					{
						breakpoint: 991,
						settings: {
							slidesToShow: 4,
							slidesToScroll: 2,
              lazyLoad:true,
						}
					},
					{
						breakpoint: 767,
						settings: {
							slidesToShow: 2,
							slidesToScroll: 2,
              lazyLoad:true,
						}
					}
				],
         	prevArrow: tbag_varible.navLeftText,
				nextArrow: tbag_varible.navRightText,
				adaptiveHeight: true
			})
		}
	});
  $('#section_product_jeans .tabs-title.tab-ajax li').click(function(e){
    function updateTabImages (activeTab) {
    $('.tab-link').each(function () {
      var imgElement = $(this).find('.tab-image'); // Tìm hình ảnh trong mỗi tab
      if ($(this).is(activeTab)) {
        imgElement.attr('src', $(this).data('tab-active'));
      } else {
        imgElement.attr('src', $(this).data('tab-inactive'));
      }
    });
  };
		var tab_id = $(this).attr('data-tab');
		var url = $(this).attr('data-url');
		var tab_content = $(this).parents('.e-tabs').siblings('.e-tabs');
		if($(this).parents('.tabs-title').hasClass('tab-title-mb')){
			tab_content =  $(this).parents('.e-tabs');
		}
		$(this).closest('.e-tabs').find('.tabs-title li').removeClass('current');
		tab_content.find('.tab-content').removeClass('current');
		$(this).addClass('current');
    updateTabImages($(this));
		tab_content.find('.tab-content[data-id="'+tab_id+'"]').addClass('current');
		if($(this).parents('.tabs-title').hasClass('tab-ajax')){
			tab_content.find('.tab-content[data-id="'+tab_id+'"]').find('.tab-product-owl').slick('unslick');
			tab_content.find('.tab-content[data-id="'+tab_id+'"]').find('.tab-product-owl').slick({
				dots: false,
				arrows: true,
				infinite: false,
				slidesToShow: 5,
				slidesToScroll: 2,
        rows: 1,
        autoHeight: true,
        lazyLoad:true,
        responsive: [
					{
						breakpoint: 1200,
						settings: {
							slidesToShow: 5,
							slidesToScroll: 2,
              lazyLoad:true,
						}
					},
					{
						breakpoint: 991,
						settings: {
							slidesToShow: 5,
							slidesToScroll: 2,
              lazyLoad:true,
						}
					},
					{
						breakpoint: 767,
						settings: {
							slidesToShow: 2,
							slidesToScroll: 2,
              lazyLoad:true,
						}
					}
				],
         	prevArrow: tbag_varible.navLeftText,
				nextArrow: tbag_varible.navRightText,
				adaptiveHeight: true
			})
		}
	});
} window.awe_tab=awe_tab;
function load_after_scroll(){
if(is_load) return 
	is_load = 1
    $('[data-coll]').one('touchstart mouseover scroll',function(){
		if($(this).hasClass('js-loaded')) return
		let id = $(this).attr('data-tab')
		let tabContent = $(`#${id}`).find('.row')
		let collHandle = $(this).data('coll')
		let limit = +$(this).data('limit')
		tabContent.find('.item_skeleton').parent().remove()
		$.ajax({
			url: `/collections/${collHandle}?view=home_tab`,
			success: function(data){
				tabContent.html(data)
				productsCallback()
			}
		})
	})
	$('[data-coll]').mouseover()
	$('[data-section]').each(function(){
		let sectionName =	$(this).data('section')
		$(this).find('.item_skeleton').parent().remove()
		let content = $(this).find('[data-template]')
		$(this).append(content.html())
		content.remove();
		productsCallback()
	})
  }
function renderLayout(){
$(document).ready(function ($) {
		awe_tab();
    $('#section_product_default .tab-product-owl').slick({
			dots: false,
			arrows: true,
			infinite: false,
			speed: 300,
			slidesToShow: 4,
			slidesToScroll: 2,
      rows: 1,
      autoHeight: true,
      lazyLoad:true,
      responsive: [
					{
						breakpoint: 1200,
						settings: {
							slidesToShow: 4,
							slidesToScroll: 2,
              lazyLoad:true,
						}
					},
					{
						breakpoint: 991,
						settings: {
							slidesToShow: 4,
							slidesToScroll: 2,
              lazyLoad:true,
						}
					},
					{
						breakpoint: 767,
						settings: {
							slidesToShow: 2,
							slidesToScroll: 2,
              lazyLoad:true,
						}
					}
				],
      	prevArrow: tbag_varible.navLeftText,
				nextArrow: tbag_varible.navRightText,
				adaptiveHeight: true
		})
   $('#section_product_jeans .tab-product-owl').slick({
			dots: false,
			arrows: true,
			infinite: false,
			speed: 300,
			slidesToShow: 5,
			slidesToScroll: 2,
      rows: 1,
      autoHeight: true,
      lazyLoad:true,
      responsive: [
					{
						breakpoint: 1200,
						settings: {
							slidesToShow: 4,
							slidesToScroll: 2,
              lazyLoad:true,
						}
					},
					{
						breakpoint: 991,
						settings: {
							slidesToShow: 4,
							slidesToScroll: 2,
              lazyLoad:true,
						}
					},
					{
						breakpoint: 767,
						settings: {
							slidesToShow: 2,
							slidesToScroll: 2,
              lazyLoad:true,
						}
					}
				],
      	prevArrow: tbag_varible.navLeftText,
				nextArrow: tbag_varible.navRightText,
				adaptiveHeight: true
		})
    })
  
}
$(document).ready(function ($) {
		renderLayout();
    load_after_scroll();
})