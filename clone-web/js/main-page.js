var itemsPerPage = 20;
var currentPage = 1;
var mystorearr_page  =[];
var mystorearr_page_160  =[];
const Wandabpage = {
	init: function() {
		this.menusidebar();
		if(tbag_varible.template == 'page.mystore' || tbag_varible.template.includes('article')){
			this.mystore();
      this.mystore160();
		}
		this.subscribeform();
	},
	menusidebar: () =>{
		$("body").on('click','.cl-open-sb',function(e){
			e.preventDefault();
			let $menu = $(this);
			$menu.next().slideToggle('fast');$menu.toggleClass('minus-menu');
		});
		$(".content-entry img").addClass('dt-width-auto').attr('height','600').attr('width','600');
	},

	mystore: ()=>{
		$.getJSON(tbag_varible.jsonmap,function(data){
			let datamap = '',datatinh = '<option value="all" selected="">Chọn tỉnh/thành phố</option>',checkdup = [];
      let html = '';
      let sosanh = "AEON Mall - Hà Đông";
      let svh = "Hồ Chí Minh - SƯ VẠN HẠNH"
      let cmt8 = "Hồ Chí Minh - CÁCH MẠNG THÁNG 8";
      let nt = "Hồ Chí Minh - NGUYỄN TRÃI";
      let lvs = "Hồ Chí Minh - LÊ VĂN SỸ";
      let qt = "Hồ Chí Minh - QUANG TRUNG";
      let ntt = "Hồ Chí Minh - NGUYỄN THỊ THẬP";
      let pvt = "Đồng Nai - PHẠM VĂN THUẬN";
      let tsn = "Hồ Chí Minh - TÂN SƠN NHÌ";
      let nat = "Hồ Chí Minh - NGUYỄN ẢNH THỦ";
      let vvn = "Hồ Chí Minh - Võ Văn Ngân";
      let ys = "Bình Dương - Yersin";
      let cb = "Hà Nội - Chùa Bộc";
      let ngt = "Hồ Chí Minh -  Nguyễn Gia Trí";
      let aeonbt = "AEON Mall - Bình Tân";
      let eaohd = "AEON Mall - Hà Đông"
      let storeHTML = '';
			$.each(data.hethongcuahang,function(i,v) {
        console.log("v.quanhuyen", sosanh.trim())
        console.log("v.tencuahang.trim()", v.tencuahang.trim())
      if(v.tencuahang.includes(sosanh)){
        html += `<span class="store-new"><span class="store-anomation">New<span></span>`;
      }else{
        html = "";
      }
        // store-off
      if(v.tencuahang.includes(html)){
        htmlOff = `<span id="store-status-new">Tạm đóng cửa</span>`
        htmlFrame = `<div class="item item-owl ">
        <img class="" src="${v.img[0].img_1}" alt="Hình ảnh store"/>
        </div>`
        }else{
           htmlOff = `<span id="store-status"></span>`
           htmlFrame = `<div class="item item-owl">
        <img class="" src="${v.img[0].img_1}" alt="Hình ảnh store"/>
      </div>`
        }
         if(v.tencuahang.includes(cmt8)){
            storeHTML = `<div class="store-quyen"><img width="20px" style="margin-right:8px;" src="https://file.hstatic.net/1000360022/file/right-arrow.png"/> <a href="https://icondenim.com/pages/icondenim-cach-mang-thang-8" class="">Xem Chi Tiết</a></div>`
         }else if(v.tencuahang.includes(svh)){
           storeHTML = `<div class="store-quyen"><img width="20px" style="margin-right:8px;" src="https://file.hstatic.net/1000360022/file/right-arrow.png"/><a href ="https://icondenim.com/pages/icondenim-su-van-hanh" class="">Xem Chi Tiết</a></div>`
         }else if(v.tencuahang.includes(nt)){
           storeHTML = `<div class="store-quyen"><img width="20px" style="margin-right:8px;" src="https://file.hstatic.net/1000360022/file/right-arrow.png"/><a href ="https://icondenim.com/pages/icondenim-nguyen-trai" class="">Xem Chi Tiết</a></div>`
         }else if(v.tencuahang.includes(qt)){
           storeHTML = `<div class="store-quyen"><img width="20px" style="margin-right:8px;" src="https://file.hstatic.net/1000360022/file/right-arrow.png"/><a href ="https://icondenim.com/pages/icondenim-quang-trung" class="">Xem Chi Tiết</a></div>`
         }else if(v.tencuahang.includes(ntt)){
           storeHTML = `<div class="store-quyen"><img width="20px" style="margin-right:8px;" src="https://file.hstatic.net/1000360022/file/right-arrow.png"/><a href ="https://icondenim.com/pages/icondenim-nguyen-thi-thap" class="">Xem Chi Tiết</a></div>`
         }else if(v.tencuahang.includes(pvt)){
           storeHTML = `<div class="store-quyen"><img width="20px" style="margin-right:8px;" src="https://file.hstatic.net/1000360022/file/right-arrow.png"/><a href ="https://icondenim.com/pages/icondenim-pham-van-thuan" class="">Xem Chi Tiết</a></div>`
         }else if(v.tencuahang.includes(tsn)){
           storeHTML = `<div class="store-quyen"><img width="20px" style="margin-right:8px;" src="https://file.hstatic.net/1000360022/file/right-arrow.png"/><a href ="https://icondenim.com/pages/icondenim-tan-son-nhi" class="">Xem Chi Tiết</a></div>`
         }else if(v.tencuahang.includes(lvs)){
           storeHTML = `<div class="store-quyen"><img width="20px" style="margin-right:8px;" src="https://file.hstatic.net/1000360022/file/right-arrow.png"/><a href ="https://icondenim.com/pages/icondenim-le-van-sy" class="">Xem Chi Tiết</a></div>`
         }else if(v.tencuahang.includes(nat)){
           storeHTML = `<div class="store-quyen"><img width="20px" style="margin-right:8px;" src="https://file.hstatic.net/1000360022/file/right-arrow.png"/><a href ="https://icondenim.com/pages/icondenim-nguyen-anh-thu" class="">Xem Chi Tiết</a></div>`
         }else if(v.tencuahang.includes(vvn)){
           storeHTML = `<div class="store-quyen"><img width="20px" style="margin-right:8px;" src="https://file.hstatic.net/1000360022/file/right-arrow.png"/><a href ="https://icondenim.com/pages/icondenim-vo-van-ngan" class="">Xem Chi Tiết</a></div>`
         }else if(v.tencuahang.includes(ys)){
           storeHTML = `<div class="store-quyen"><img width="20px" style="margin-right:8px;" src="https://file.hstatic.net/1000360022/file/right-arrow.png"/><a href ="https://icondenim.com/pages/icondenim-yersin" class="">Xem Chi Tiết</a></div>`
         }else if(v.tencuahang.includes(cb)){
           storeHTML = `<div class="store-quyen"><img width="20px" style="margin-right:8px;" src="https://file.hstatic.net/1000360022/file/right-arrow.png"/><a href ="https://icondenim.com/pages/icondenim-chua-boc" class="">Xem Chi Tiết</a></div>`
         }else if(v.tencuahang.includes(ngt)){
           storeHTML = `<div class="store-quyen"><img width="20px" style="margin-right:8px;" src="https://file.hstatic.net/1000360022/file/right-arrow.png"/><a href ="https://icondenim.com/pages/icondenim-nguyen-gia-tri" class="">Xem Chi Tiết</a></div>`
         }else if(v.tencuahang.includes(aeonbt)){
           storeHTML = `<div class="store-quyen"><img width="20px" style="margin-right:8px;" src="https://file.hstatic.net/1000360022/file/right-arrow.png"/><a href ="https://icondenim.com/pages/icondenim-aeon-mall-binh-tan" class="">Xem Chi Tiết</a></div>`
         }else if(v.tencuahang.includes(eaohd)){
           storeHTML = `<div class="store-quyen"><img width="20px" style="margin-right:8px;" src="https://file.hstatic.net/1000360022/file/right-arrow.png"/><a href ="https://icondenim.com/pages/icondenim-aeon-mall-ha-dong" class="">Xem Chi Tiết</a></div>`
         }else{
            storeHTML = "";
         }
				datamap += `
<div class="col-xs-12 col-sm-12 col-md-4 store-container" data-tinh="${urlfriendly(v.tinhthanh)}" data-quan="${urlfriendly(v.quanhuyen)}">
  <div class="store-content">
   	<div class="product-gallery-address d-flex-slick" data-allin="1" data-widthgallery="false">
     ${htmlFrame}
       
  
</div>
<a class="location-href" href="${v.urlmap}" rel="nofollow">
<h1 class="title-store-page px">${v.tencuahang}  ${html}</h1>
<p class="title-info px"><i class="fa-solid fa-location-dot"></i><span>${v.address}</span></p>
<p class="title-info space-between mx-10 px">
<span><i class="fa-regular fa-clock"></i><span>${v.giohoatdong}</span></span>
<span id="store-status"></span>
</p>
</a>
<div class="store-location px">
<a href="tel:${v.dienthoai}" class="title-info"><i class="fa-solid fa-phone-volume"></i> <span>${v.dienthoai}</span></a>
<a class="infoLocation" target="_blank" href="${v.urlmap}" rel="nofollow">
<i class="fa fa-location-arrow"></i>
<span class="guideWay">Xem bản đồ</span>
</a>
</div>
${storeHTML}
</div>
</div>`;
				if(!checkdup.includes(v.tinhthanh)){
          checkdup.push(v.tinhthanh);
				}
})
      $.each(checkdup,function(i,v){
        datatinh += `<option value="${urlfriendly(v)}" data-tinh="${v}">${v}</option>`;
      })
			$("#mystore-template #tabaddress1 #address-link").html(datamap);
			$("#mystore-template #tabaddress1 .change-tinh").html(datatinh);
			mystorearr_page.push(data.hethongcuahang);
      Wandabpage.updateTime();
      Wandabpage.carousel();
      var $items = $('#tabaddress1 #address-link .store-container');
    var totalItems = $items.length;
    var totalPages = Math.ceil(totalItems / itemsPerPage);
    // Hiển thị trang đầu tiên khi trang được tải
    showPage(1);
    // Tạo nút trang
    var $pagination = $('#pagination');
    for (var i = 1; i <= totalPages; i++) {
        var $button = $('<button class="page-btn">' + i + '</button>');
        $button.data('page', i);
        $pagination.append($button);
    }
    $('#pagination .page-btn:first').addClass('active')
    $pagination.on('click', '.page-btn', function(){
        var page = $(this).data('page');
        showPage(page);
        $('.page-btn').removeClass('active');
        $(this).addClass('active');
        $('.product-gallery-address').slick('unslick')
        $(".product-gallery-address").slick({
        		slidesToShow: 1,
      			slidesToScroll: 1,
      			arrows: false,
      			fade: false,
            loop: true,
      			infinite: false,
            vertical: false,
            dots: true,
          });
             $("html, body").animate({
            scrollTop: $(".police-container").offset().top
        }, 1000);
    });
    function showPage(page) {
        var startIndex = (page - 1) * itemsPerPage;
        var endIndex = startIndex + itemsPerPage;
        $items.hide().slice(startIndex, endIndex).show();
    }
		});

		$("body").on('click','#mystore-template #tabaddress1 #address-link .iframe-map',function(e){
			e.preventDefault(); 
			$('#mystore-template #tabaddress1 #address-link .store-container').removeClass('active');
			$(this).parent().addClass('active')
			let iframe_map = $(this).attr('data-iframe');
			$("#map").html(iframe_map)
		});
		$('body').on('change','#mystore-template #tabaddress1 .change-tinh',function(){
			const valhandle = $(this).val();
			Wandabpage.changetinh(valhandle);
			Wandabpage.checkshowhide();
      $('#tabaddress1 .product-gallery-address').slick('unslick')
      $("#tabaddress1 .product-gallery-address").slick({
        		slidesToShow: 1,
      			slidesToScroll: 1,
      			arrows: false,
      			fade: false,
            loop: true,
      			infinite: false,
            vertical: false,
            dots: true,
          });
      $("#pagination").addClass("map-hide");
		})
		$('body').on('change','#mystore-template #tabaddress1 .select-quan',function(){
			const valdistrict = $(this).val(),valprovice = $("#mystore-template #tabaddress1 .change-tinh").val();
			Wandabpage.changequan(valdistrict,valprovice);
			Wandabpage.checkshowhide();
      $('#tabaddress1 .product-gallery-address').slick('unslick')
        $("#tabaddress1 .product-gallery-address").slick({
        		slidesToShow: 1,
      			slidesToScroll: 1,
      			arrows: false,
      			fade: false,
            loop: true,
      			infinite: false,
            vertical: false,
            dots: true,
          });
      $("#pagination").addClass("map-hide");
		});
     
	},
	changetinh: (provice) =>{
		var datamap = '<option value="all">Chọn Quận/huyện</option>',checkduplicate = [] ;
		$.each(mystorearr_page[0],function(i,v){
			if(urlfriendly(v.tinhthanh) == provice){
        if(!checkduplicate.includes(v.quanhuyen)){
          checkduplicate.push(v.quanhuyen);
				}
			}
		});
     $.each(checkduplicate,function(i,v){
				datamap += `<option value="${urlfriendly(v)}">${v}</option>`;
     })
		$('#mystore-template #tabaddress1 .select-quan').html(datamap)
		$("#mystore-template #tabaddress1 #address-link .store-container").hide();
		provice == 'all' ? $("#tabaddress1 #address-link .store-container").show() : $("#mystore-template #tabaddress1 #address-link .store-container[data-tinh='"+provice+"']").show();
		Wandabpage.checkshowhide();
	},
	changequan: (district,provice) =>{
		$("#mystore-template #tabaddress1 #address-link .store-container").hide();
		district == 'all' ? $("#mystore-template #tabaddress1 #address-link .store-container[data-tinh='"+provice+"']").show() : $("#mystore-template #tabaddress1 #address-link .store-container[data-quan='"+district+"']").show();
		Wandabpage.checkshowhide();
	},
	checkshowhide: () =>{
		var counter_item = 0;
		$("#mystore-template #tabaddress1 #address-link .store-container").each(function(){
			var thisstyle = $(this).attr('style');
			if(thisstyle != 'display: none;'){counter_item += 1;}
		})
		if(counter_item == 0){
			$("#mystore-template #tabaddress1 .address-detail .no-store").addClass('hidden');
			$("#mystore-template #tabaddress1 .address-detail .no-store").removeClass('hidden');
		}else{
			$("#mystore-template #tabaddress1 .address-detail .no-store").addClass('hidden');
		}
	},
  mystore160: ()=>{
		$.getJSON('https://file.hstatic.net/1000360022/file/data_c52158bac6aa4c4b922fe91aa83f699d.json',function(data){
			let datamap = '',datatinh = '<option value="all" selected="">Chọn tỉnh/thành phố</option>',checkdup = [];
			$.each(data.hethongcuahang,function(i,v) {
       
				datamap += `
<div class="col-xs-12 col-sm-12 col-md-4 store-container" data-tinh="${urlfriendly(v.tinhthanh)}" data-quan="${urlfriendly(v.quanhuyen)}">
  <div class="store-content">
   	<div class="product-gallery-address d-flex-slick" data-allin="1" data-widthgallery="false">
      <div class="item item-owl">
      <a class="location-href" href="${v.urlmap}" rel="nofollow">
        <img class="" src="${v.img[0].img_1}" alt="Hình ảnh store"/>
        </a>
  </div>
  
</div>
<a class="location-href" href="${v.urlmap}" rel="nofollow">
<h1 class="title-store-page px">${v.tencuahang}</h1>
<p class="title-info px"><i class="fa-solid fa-location-dot"></i><span>${v.address}</span></p>
<p class="title-info space-between mx-10 px">
<span><i class="fa-regular fa-clock"></i><span>${v.giohoatdong}</span></span>
<span id="store-status"></span>
</p>
</a>
<div class="store-location px">
<a href="tel:${v.dienthoai}" class="title-info"><i class="fa-solid fa-phone-volume"></i> <span>${v.dienthoai}</span></a>
<a class="infoLocation" target="_blank" href="${v.urlmap}" rel="nofollow">
<i class="fa fa-location-arrow"></i>
<span class="guideWay">Xem bản đồ</span>
</a>
</div>
</div>
</div>`;
				if(!checkdup.includes(v.tinhthanh)){
          checkdup.push(v.tinhthanh);
				}
})
      $.each(checkdup,function(i,v){
        datatinh += `<option value="${urlfriendly(v)}" data-tinh="${v}">${v}</option>`;
      })
			$("#mystore-template #tabaddress2 #address-link").html(datamap);
			$("#mystore-template #tabaddress2 .change-tinh").html(datatinh);
			mystorearr_page_160.push(data.hethongcuahang);
      Wandabpage.updateTime();
      Wandabpage.carousel();
      var $items = $('#tabaddress2 #address-link .store-container');
    var totalItems = $items.length;
    var totalPages = Math.ceil(totalItems / itemsPerPage);
    // Hiển thị trang đầu tiên khi trang được tải
    showPage(1);
    // Tạo nút trang
    var $pagination = $('#pagination');
    for (var i = 1; i <= totalPages; i++) {
        var $button = $('<button class="page-btn">' + i + '</button>');
        $button.data('page', i);
        $pagination.append($button);
    }
    $('#pagination .page-btn:first').addClass('active')
    $pagination.on('click', '.page-btn', function(){
        var page = $(this).data('page');
        showPage(page);
        $('.page-btn').removeClass('active');
        $(this).addClass('active');
        $('#tabaddress2 .product-gallery-address').slick('unslick')
        $("#tabaddress2 .product-gallery-address").slick({
        		slidesToShow: 1,
      			slidesToScroll: 1,
      			arrows: false,
      			fade: false,
            loop: true,
      			infinite: false,
            vertical: false,
            dots: true,
          });
             $("html, body").animate({
            scrollTop: $(".police-container").offset().top
        }, 1000);
    });
    function showPage(page) {
        var startIndex = (page - 1) * itemsPerPage;
        var endIndex = startIndex + itemsPerPage;
        $items.hide().slice(startIndex, endIndex).show();
    }
		});

		$("body").on('click','#mystore-template #tabaddress2 #address-link .iframe-map',function(e){
			e.preventDefault(); 
			$('#mystore-template #tabaddress2 #address-link .store-container').removeClass('active');
			$(this).parent().addClass('active')
			let iframe_map = $(this).attr('data-iframe');
			$("#map").html(iframe_map)
		});
		$('body').on('change','#mystore-template #tabaddress2 .change-tinh',function(){
			const valhandle = $(this).val();
			Wandabpage.changetinh160(valhandle);
			Wandabpage.checkshowhide160();
      $('#tabaddress2 .product-gallery-address').slick('unslick')
      $("#tabaddress2 .product-gallery-address").slick({
        		slidesToShow: 1,
      			slidesToScroll: 1,
      			arrows: false,
      			fade: false,
            loop: true,
      			infinite: false,
            vertical: false,
            dots: true,
          });
      $("#pagination").addClass("map-hide");
		})
		$('body').on('change','#mystore-template #tabaddress2 .select-quan',function(){
			const valdistrict = $(this).val(),valprovice = $("#mystore-template #tabaddress2 .change-tinh").val();
			Wandabpage.changequan160(valdistrict,valprovice);
			Wandabpage.checkshowhide160();
      $('#tabaddress2 .product-gallery-address').slick('unslick')
        $("#tabaddress2 .product-gallery-address").slick({
        		slidesToShow: 1,
      			slidesToScroll: 1,
      			arrows: false,
      			fade: false,
            loop: true,
      			infinite: false,
            vertical: false,
            dots: true,
          });
      $("#tabaddress2 #pagination").addClass("map-hide");
		});
     
	},
	changetinh160: (provice) =>{
		var datamap = '<option value="all">Chọn Quận/huyện</option>',checkduplicate = [] ;
		$.each(mystorearr_page_160[0],function(i,v){
			if(urlfriendly(v.tinhthanh) == provice){
        if(!checkduplicate.includes(v.quanhuyen)){
          checkduplicate.push(v.quanhuyen);
				}
			}
		});
     $.each(checkduplicate,function(i,v){
				datamap += `<option value="${urlfriendly(v)}">${v}</option>`;
     })
		$('#mystore-template #tabaddress2 .select-quan').html(datamap)
		$("#mystore-template #tabaddress2 #address-link .store-container").hide();
		provice == 'all' ? $("#tabaddress2 #address-link .store-container").show() : $("#mystore-template #tabaddress2 #address-link .store-container[data-tinh='"+provice+"']").show();
		Wandabpage.checkshowhide160();
	},
	changequan160: (district,provice) =>{
		$("#mystore-template #tabaddress2 #address-link .store-container").hide();
		district == 'all' ? $("#mystore-template #tabaddress2 #address-link .store-container[data-tinh='"+provice+"']").show() : $("#mystore-template #tabaddress2 #address-link .store-container[data-quan='"+district+"']").show();
		Wandabpage.checkshowhide160();
	},
	checkshowhide160: () =>{
		var counter_item = 0;
		$("#mystore-template #tabaddress2 #address-link .store-container").each(function(){
			var thisstyle = $(this).attr('style');
			if(thisstyle != 'display: none;'){counter_item += 1;}
		})
		if(counter_item == 0){
			$("#mystore-template #tabaddress2 .address-detail .no-store").addClass('hidden');
			$("#mystore-template #tabaddress2 .address-detail .no-store").removeClass('hidden');
		}else{
			$("#mystore-template #tabaddress2 .address-detail .no-store").addClass('hidden');
		}
	},
	subscribeform: () =>{
		$('.contact-form-warp form button').click(function(e){
			e.preventDefault();
			Wandabpage.validateform();
		});
		$(".contact-form-warp form").submit(function(e){
			e.preventDefault();
			var self = $(this);
			let name_ct = $('#contactFormName').val(),email_ct = $('#contactFormEmail').val(),phone_ct = $('#contactFormPhone').val(),mess_ct = $("#contactFormMessage").val(),recapcha_ct = self.find("input[name='g-recaptcha-response']").val();
			$.ajax({
				type: 'POST',
				url:'/contact',
				dataType:'json',
				data: "form_type=contact&utf8=✓&contact[name]="+name_ct+"&contact[phone]="+phone_ct+"&contact[email]="+email_ct+"&contact[body]="+mess_ct+"&g-recaptcha-response="+recapcha_ct,
				complete: function(responseText){
					window.wd.scofield.modalsubsucess();self.trigger('reset');
				}
			})
		})
	},
	validateform: () =>{
		var checkname = false,checkemail = false,checktelephone = false,checkmess = false;
		var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/, numberReg =  /^[0-9]+$/;
		var names = $('#contactFormName').val(),phone = $('#contactFormPhone').val(),email = $('#contactFormEmail').val(),mess = $('#contactFormMessage').val();
		if(names == ""){
			$('.contact-form-warp li #contactFormName').siblings('.errors').remove();
			$('.contact-form-warp li #contactFormName').after(`<div class="errors"><ul><li>Vui lòng nhập tên của bạn</li></ul></div>`);
		}
		else{
			$('.contact-form-warp li #contactFormName').siblings('.errors').remove();
			checkname = true;
		}
		if(email == ""){
			$('.contact-form-warp li #contactFormEmail').siblings('.errors').remove();
			$('.contact-form-warp li #contactFormEmail').after(`<div class="errors"><ul><li>Vui lòng nhập email của bạn</li></ul></div>`);
		} 
		else if(!emailReg.test(email)){
			$('.contact-form-warp li #contactFormEmail').siblings('.errors').remove();
			$('.contact-form-warp li #contactFormEmail').after(`<div class="errors"><ul><li>Email không đúng định dạng</li></ul></div>`);
		}
		else{
			$('.contact-form-warp li #contactFormEmail').siblings('.errors').remove();
			checkemail = true;
		}
		if(phone == ""){
			$('.contact-form-warp li #contactFormPhone').siblings('.errors').remove();
			$('.contact-form-warp #contactFormPhone').after(`<div class="errors"><ul><li>Vui lòng nhập số điện thoại của bạn</li></ul></div>`);
		}
		else if(!numberReg.test(phone)){
			$('.contact-form-warp li #contactFormPhone').siblings('.errors').remove();
			$('.contact-form-warp li #contactFormPhone').after(`<div class="errors"><ul><li>Số điện thoại không đúng định dạng</li></ul></div>`);
		}
		else{
			$('.contact-form-warp li #contactFormPhone').siblings('.errors').remove();
			checktelephone = true;
		}
		if(mess == ""){
			$('.contact-form-warp li #contactFormMessage').siblings('.errors').remove();
			$('.contact-form-warp li #contactFormMessage').after(`<div class="errors"><ul><li>Vui lòng nhập nội dung</li></ul></div>`);
		}
		else{
			$('.contact-form-warp li #contactFormMessage').siblings('.errors').remove();
			checkmess = true;
		}
		if(checkname == true && checkemail == true && checktelephone == true && checkmess == true){$(".contact-form-warp form").trigger('submit')}
	},
  updateTime: ()=>{
    function updateStoreStatus() {
        var currentTime = new Date();
        var currentHour = currentTime.getHours();
        var isOpen = (currentHour >= 8 && currentHour < 22); // Cửa hàng mở cửa từ 8h đến 22h
        if (isOpen) {
            $('.store-container #store-status').text('Đang mở');
        } else {
            $('.store-container #store-status').text('Đang đóng');
        }
    }
    setInterval(updateStoreStatus, 60000); 
    updateStoreStatus();
  },
  carousel: () =>{
    $(document).ready(() =>{
    $(".product-gallery-address").slick({
  		slidesToShow: 1,
      			slidesToScroll: 1,
      			arrows: false,
      			fade: false,
            loop: true,
      			infinite: false,
            vertical: false,
            dots: true,
});
    })
  },
}
$(function(){
	Wandabpage.init();
})
window.addEventListener('load', (event) => {
	if(tbag_varible.template == 'page.mystore'){
	const height_map = $(".address-map").innerHeight();
	$("body").attr('style','--height-map:'+height_map+'px');
	}
})
$(document).ready(() =>{
	$("#map").html($('#map').attr('data-iframe'))

})