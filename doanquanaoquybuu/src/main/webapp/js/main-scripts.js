let checkrecaptcha = false, windowsize = $(window).width(),tokenNew ='', startTime = Date.now(),trackingId = '',uidNew='', tokenTrackingNew='';
const Wanda = {
	init: function(){
		windowsize <= 991 ? this.menumobile() : this.quickview();
    if(!tbag_varible.template.includes('product')){
      setTimeout(() => {
      Wanda.slidercallback();
      },50)
    }
		this.header();
    this.getToken();
		this.smartsearch();
    this.trackingNew();
		// this.modalcontact();
		this.wlgroup();
		this.firstcbwl();
    this.checkout();
    if(tbag_varible.template !== 'cart'){this.getCountCart();} 
    this.landing_page();
    // this.genMetaFile();
		if(tbag_varible.template == 'index'){this.hometabajax();} 
		if(tbag_radom.item.length > 0 && tbag_varible.sgnotify == 'true' && !tbag_varible.template.includes('product') && windowsize > 767){this.suggess_notify();}
		if(tbag_varible.template == 'index' || tbag_varible.template.includes('product')){this.collectionsale();}
		this.scrollcallback();
  // setTimeout(() => {
  //     this.createToken();
  //   },1000)
  //   setTimeout(() => {
  //     this.trackingView();
  //   },500)
	},
    landing_page: () =>{
    if (!localStorage.getItem("landing_page")) {
    var landingPage = window.location.pathname;
      localStorage.setItem("landing_page", landingPage);
      document.cookie = "landing_page=" + encodeURIComponent(landingPage) + "; path=/; max-age=86400";
    }},

  getToken:() =>{
  function parseJwt(token) {
    try {
        let base64Url = token.split(".")[1];
        let base64 = base64Url.replace(/-/g, "+").replace(/_/g, "/");
        let jsonPayload = decodeURIComponent(
            atob(base64)
                .split("")
                .map(function (c) {
                    return "%" + ("00" + c.charCodeAt(0).toString(16)).slice(-2);
                })
                .join("")
        );
        return JSON.parse(jsonPayload);
    } catch (e) {
        return null;
    }
}
function isJwtExpired(token) {
    let decoded = parseJwt(token);
    if (!decoded || !decoded.exp) return true;
    return decoded.exp * 1000 < Date.now();
}
let token = localStorage.getItem("jwtToken");
if (!token || isJwtExpired(token)) {
        $.ajax({
          url: 'https://462hk5f9cg.execute-api.ap-southeast-1.amazonaws.com/production/icondenim/token',
          type: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Basic UHIwZHVjVCEwbjpQcjBkdWNUITBuLVMzY3IzdA=='
          },
          success: response => {
            localStorage.setItem("jwtToken", response.token);
            tokenNew = response.token
          },
      error: function(xhr, status, error) {console.error("Error fetching token:", error);}
    });
}else{
  tokenNew = token
}
  },
  trackingNew: async () =>{
  var Guid = (function () {
    var EMPTY = '00000000-0000-0000-0000-000000000000';

    var _padLeft = function (paddingString, width, replacementChar) {
      return paddingString.length >= width
        ? paddingString
        : _padLeft(replacementChar + paddingString, width, replacementChar || ' ');
    };

    var _s4 = function (number) {
      var hexadecimalResult = number.toString(16);
      return _padLeft(hexadecimalResult, 4, '0');
    };

    var _cryptoGuid = function () {
      var crypto = window.crypto || window.msCrypto;
      var buffer = new Uint16Array(8);
      crypto.getRandomValues(buffer);
      return [
        _s4(buffer[0]) + _s4(buffer[1]),
        _s4(buffer[2]),
        _s4(buffer[3]),
        _s4(buffer[4]),
        _s4(buffer[5]) + _s4(buffer[6]) + _s4(buffer[7]),
      ].join('-');
    };

    var _guid = function () {
      var currentDateMilliseconds = new Date().getTime();
      return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (currentChar) {
        var randomChar = (currentDateMilliseconds + Math.random() * 16) % 16 | 0;
        currentDateMilliseconds = Math.floor(currentDateMilliseconds / 16);
        return (currentChar === 'x' ? randomChar : (randomChar & 0x7 | 0x8)).toString(16);
      });
    };

    var create = function () {
      var crypto = window.crypto || window.msCrypto || null;
      var hasCrypto = crypto !== null;
      var hasRandomValues = typeof crypto?.getRandomValues !== 'undefined';
      return (hasCrypto && hasRandomValues) ? _cryptoGuid() : _guid();
    };

    return {
      newGuid: create,
      empty: EMPTY
    };
  })();
  const key = 'product_selection';
  const keytracking = 'product_selection_tracking';
  let uid = localStorage.getItem(key);
  let uidTracking = localStorage.getItem(keytracking);
  let userAgent = navigator.userAgent;
  const response = await fetch('https://api.ipify.org?format=json');
  const dataSesponse = await response.json();
  const dataIp = dataSesponse.ip;
   if (!uid || uid.trim() === '') {
    uid = Guid.newGuid();
    let dataSend = {
      uid: uid,
      userAgent: userAgent,
      dataIp: dataIp,
    }
    var params = {
      type: 'POST',
      url: 'https://admin.icondenim.vn/tracking/create-uid',
      data: JSON.stringify(dataSend),
      headers: {
        'Content-Type': 'application/json'
      },
      success: tracking => {
        localStorage.setItem(key, tracking.data.uid);
        Wanda.createToken()
        .then(() => Wanda.trackingView());
      },
      error: (XMLHttpRequest, textStatus) =>{
      }
    };
        jQuery.ajax(params);
   }else{
     Wanda.createToken()
      .then(() => Wanda.trackingView());
   }
   
  },
  //     trackingNew: async () =>{
  // var Guid = (function () {
  //   var EMPTY = '00000000-0000-0000-0000-000000000000';

  //   var _padLeft = function (paddingString, width, replacementChar) {
  //     return paddingString.length >= width
  //       ? paddingString
  //       : _padLeft(replacementChar + paddingString, width, replacementChar || ' ');
  //   };

  //   var _s4 = function (number) {
  //     var hexadecimalResult = number.toString(16);
  //     return _padLeft(hexadecimalResult, 4, '0');
  //   };

  //   var _cryptoGuid = function () {
  //     var crypto = window.crypto || window.msCrypto;
  //     var buffer = new Uint16Array(8);
  //     crypto.getRandomValues(buffer);
  //     return [
  //       _s4(buffer[0]) + _s4(buffer[1]),
  //       _s4(buffer[2]),
  //       _s4(buffer[3]),
  //       _s4(buffer[4]),
  //       _s4(buffer[5]) + _s4(buffer[6]) + _s4(buffer[7]),
  //     ].join('-');
  //   };

  //   var _guid = function () {
  //     var currentDateMilliseconds = new Date().getTime();
  //     return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (currentChar) {
  //       var randomChar = (currentDateMilliseconds + Math.random() * 16) % 16 | 0;
  //       currentDateMilliseconds = Math.floor(currentDateMilliseconds / 16);
  //       return (currentChar === 'x' ? randomChar : (randomChar & 0x7 | 0x8)).toString(16);
  //     });
  //   };

  //   var create = function () {
  //     var crypto = window.crypto || window.msCrypto || null;
  //     var hasCrypto = crypto !== null;
  //     var hasRandomValues = typeof crypto?.getRandomValues !== 'undefined';
  //     return (hasCrypto && hasRandomValues) ? _cryptoGuid() : _guid();
  //   };

  //   return {
  //     newGuid: create,
  //     empty: EMPTY
  //   };
  // })();
  // const key = 'product_selection';
  // const keytracking = 'product_selection_tracking';
  // let uid = localStorage.getItem(key);
  // let uidTracking = localStorage.getItem(keytracking);
  // let userAgent = navigator.userAgent;
  // const response = await fetch('https://api.ipify.org?format=json');
  // const dataSesponse = await response.json();
  // const dataIp = dataSesponse.ip;
  //  if (!uidTracking || uidTracking.trim() === '') {
  //   uid = Guid.newGuid();
  //   let dataSend = {
  //     uid: uid,
  //     userAgent: userAgent,
  //     dataIp: dataIp,
  //   }
  //   var params = {
  //     type: 'POST',
  //     url: 'https://admin.icondenim.vn/tracking/create-uid',
  //     data: JSON.stringify(dataSend),
  //     headers: {
  //       'Content-Type': 'application/json'
  //     },
  //     success: tracking => {
  //       localStorage.setItem(key, tracking.data.uid);
  //     },
  //     error: (XMLHttpRequest, textStatus) =>{
  //     }
  //   };
  //       jQuery.ajax(params);
  //  }
  // },


  createToken: () => {
  const key = 'product_selection';
  const keytracking = 'product_selection_tracking';
  let uid = localStorage.getItem(key);
  let tokenTracking = localStorage.getItem(keytracking);
  let userAgent = navigator.userAgent;

  if (!tokenTracking) {
    return new Promise((resolve, reject) => {
      $.ajax({
        url: 'https://admin.icondenim.vn/tracking/create-token',
        type: 'POST',
        data: JSON.stringify({ uid, userAgent }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic UHIwZHVjVCEwbjE2MDpQcjBkdWNUITBuLVMzY3IzdDE2MA=='
        },
        success: response => {
          localStorage.setItem(keytracking, response.data.token);
          resolve(response.data.token);
        },
        error: (xhr, status, error) => {
          console.error("Error fetching token:", error);
          reject(error);
        }
      });
    });
  } else {
    return Promise.resolve(tokenTracking);
  }
},
//     createToken: () =>{
//   const key = 'product_selection';
//   const keytracking = 'product_selection_tracking'
//   let uid = localStorage.getItem(key);
//   console.log("uid", uid)
//   let tokenTrackingValue = localStorage.getItem(keytracking);
//   let userAgent = navigator.userAgent;
//   let tokenTracking = localStorage.getItem('product_selection_tracking');
//   let dataSend = {
//     uid: uid,
//     userAgent: userAgent,
//   }
//     if (!tokenTracking) {
//         $.ajax({
//           url: 'https://admin.icondenim.vn/tracking/create-token',
//           type: 'POST',
//            data: JSON.stringify(dataSend),
//           headers: {
//             'Content-Type': 'application/json',
//             'Authorization': 'Basic UHIwZHVjVCEwbjpQcjBkdWNUITBuLVMzY3IzdA=='
//           },
//           success: response => {
//             localStorage.setItem("product_selection_tracking", response.data.token);
//             // tokenTrackingNew = response.token
//           },
//       error: function(xhr, status, error) {console.error("Error fetching token:", error);}
//     });
// }else{
//   tokenTrackingNew = tokenTrackingValue
// }
//   },
    trackingView: async () =>{
    localStorage.removeItem("tracking_uid");
    const keytracking = 'product_selection_tracking'
    const key = 'product_selection';
    let uid = localStorage.getItem(key);
    let tokenTracking = localStorage.getItem(keytracking);
    let dataSend = '';
    const url = window.location.pathname;
    const referrer = document.referrer || "direct";
    if($("#wandave-theme").hasClass('product')){
      const title = $(".pro-content-head h1").data("title")
      const sku = $(".pro-content-head .sku-number").attr("value");
      let resultSku = sku.replace(/-\d+$/, "");
      const price = $('.special-price .price.product-price').text().trim();
      dataSend = {
        url: url,
        uid: uid,
        title: title,
        referrer: referrer,
        product_type: resultSku,
        product_price: price,
        view_type: 'view-product'
      }
    }else if($("#wandave-theme").hasClass('cart')){
      dataSend = {
        url: url,
        uid: uid,
        title: '',
        referrer: referrer,
        product_type: '',
        view_type: 'view-cart'
      }
    }else if($("#wandave-theme").hasClass('index')){
      dataSend = {
        url: url,
        uid: uid,
        title: '',
        referrer: referrer,
        product_type: '',
        view_type: 'view-home'
      }
    }else if($("#wandave-theme").hasClass('page.mystore')){
      dataSend = {
        url: url,
        uid: uid,
        title: '',
        referrer: referrer,
        product_type: '',
        view_type: 'view-store'
      }
    }else if($("#wandave-theme").hasClass('collection') || $("#wandave-theme").hasClass('collection.procool-collection') || $("#wandave-theme").hasClass('collection.smart-jean-collection') || $("#wandave-theme").hasClass('collection.lightwight-collection') || $("#wandave-theme").hasClass('collection.quan-jean-collection')){
      dataSend = {
        url: url,
        uid: uid,
        title: url,
        referrer: referrer,
        product_type: '',
        view_type: 'view-collection'
      }
    }else{
      dataSend = {
        url: url,
        uid: uid,
        title: url,
        referrer: referrer,
        product_type: '',
        view_type: 'view-page'
      }
    }
    
     $.ajax({
      url: 'https://admin.icondenim.vn/tracking/tracking-view-product-start',
      method: 'POST',
      headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${tokenTracking}`
      },
      data: JSON.stringify(dataSend),
      xhrFields: {
        withCredentials: true
      },
      success: function (data) {
        trackingId = data.data
      }
    });
function endProductView() {
  var endTime = Date.now();
  var duration = Math.floor((endTime - startTime) / 1000);
  fetch('https://admin.icondenim.vn/tracking/tracking-view-product-end', {
    method: 'POST',
       headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${tokenTracking}`
      },
     xhrFields: {
        withCredentials: true
      },
    body: JSON.stringify({ duration: duration, trackingId: trackingId }),
    keepalive: true // ⚠️ dùng để gửi request khi người dùng rời trang
  });
}

  document.addEventListener('visibilitychange', function () {
    if (document.visibilityState === 'hidden') {
      endProductView();
    }
  });

  window.addEventListener('beforeunload', endProductView);
  window.addEventListener('pagehide', endProductView);
  },
	quickview: () => {
		$("body").on("click",".product-block .btn_quickview",function(){
			let url_qv = $(this).data('url')+'?view=quickview-nochoose', data_result = $("#pro-qv-wanda");
      getdatasite(url_qv,data_result,'false');
			data_result.modal({
				fadeDuration: 100
			});
		})
    	$("body").on("click",".btn-nhanqua",function(){
			let url_qv = $(this).data('url')+'?view=quickview-nochoose', data_result = $("#pro-qv-wanda");
      getdatasite(url_qv,data_result,'false');
			data_result.modal({
				fadeDuration: 100
			});
		})
   $("body").on("click",".open-quickview,.close-modal-quickview-mob",function(){
        $("body").css('overflow-y','');
        $("#pro-qv-wanda").css('opacity','1');
        $("#pro-qv-wanda").css('display','none');
        $(".jquery-modal").removeClass('blocker');
  });
//       $("body").on("click",".wanda-cart-url,.wanda-checkout-url",function(){
//     const key = 'product_selection';
//     function getCookie(name) {
//   const value = `; ${document.cookie}`;
//   const parts = value.split(`; ${name}=`);
//   if (parts.length === 2) return parts.pop().split(';').shift();
// }
//     const trackingId = getCookie('session_id');
//     const token = localStorage.getItem('token_cart_new');
//   let uid = localStorage.getItem(key);
//    if (uid || uid.trim() !== '') {
//     let dataSend = {
//       uid: uid,
//       type:"checkout",
//       token: token
//     }
//      console.log("dataSend", dataSend)
//     var params = {
//       type: 'POST',
//       url: 'https://462hk5f9cg.execute-api.ap-southeast-1.amazonaws.com/production/icondenim/checkout/tracking/update-event_type',
//       data: JSON.stringify(dataSend),
//       headers: {
//         'Authorization': `Bearer ${tokenNew}`,
//     'Content-Type': 'application/json'
//   },
//       success: order => {
//           window.location.href = `https://icondenim.com/cart`
//       },
//       error: (XMLHttpRequest, textStatus) =>{
//       }
//     };
//       jQuery.ajax(params);
//    }

//   });
  $("body").on("click","#buy-now",function(){
		var id = $('#product-select').val(),quantity = $('#content-add-to-cart .quantity-area').find('#quantity').val(),url = '/cart';
		Wanda.addtocartcheckout(id,quantity);
	});
	$("body").on('click','#add-to-cart-qv',function(){
		let id = $(this).parents('#add-item-form-qv').find('#product-select-qv').val(),quantity = $(this).parents('#add-item-form-qv').find('#quantity').val();
		Wanda.addtocartmodal(id,quantity);
	})
  $("body").on('click','#btn-buynow',function(){
			let id = $(this).parents('#add-item-form-qv').find('#product-select-qv').val(),quantity = $(this).parents('#content-add-to-cart .quantity-area').find('#quantity').val();
			Wanda.addtocartcheckout(id,quantity);
	})
    $("body").on("click","#close-cart-mini",function(){
      $("#cart-popup").removeClass("model-add-cart-success")
    })
    $("body").on("click",".hailoc-content-combo", function() {
      $("#modal-subscribe").modal("show");
      		$("#modal-subscribe").modal({
					fadeDuration: 200
				});
    })
	},
	plusQuantity: $this => {
		if($this.siblings('input[name="quantity"]').val() != undefined ) {
			let currentVal = parseInt($this.siblings('input[name="quantity"]').val());
			if(!isNaN(currentVal)) {
				$this.siblings('input[name="quantity"]').val(currentVal + 1);
			}else {
				$this.siblings('input[name="quantity"]').val(1);
			}
		}
	},
	minusQuantity: $this => {
		if($this.siblings('input[name="quantity"]').val() != undefined ) {
			let currentVal = parseInt($this.siblings('input[name="quantity"]').val());
			if(!isNaN(currentVal) && currentVal > 1) {
				$this.siblings('input[name="quantity"]').val(currentVal - 1);
			}
		}
	},
	header: () =>{
     var $popup = $('#header-search');
    var thresholdHeight = 200;
    var wDW = $(window).width();
    $(document).on("click", ".toggle_form_search", function(e) {
      e.preventDefault();
      $("#header-search").addClass("active");
    });
		if(wDW > 767){
			$('.toggle-mn').show();
		}else {
			$('.footer-click > .clicked').click(function(){
				$(this).toggleClass('open_');
				$(this).next('ul').slideToggle("fast");
				$(this).next('div').slideToggle("fast");
			});
		}
     $(window).on('scroll', function() {
        $popup.removeClass("active");
     });
         // $(document).on('click', function(event) {

       //  if (!$(event.target).closest('#sticky_header').length && !$(event.target).closest('#menu-mobile').length) {
       //  $popup.removeClass("active");
       // }
//            const safe = '#header, #menu-mobile, #header-search';
// $(document).on('click', function (e) {
//   if (!$(e.target).closest(safe).length) $popup.removeClass('active');
// });

     // })
    $(document).on('click', '#header-search .ega-header-layer', function () {
  $popup.removeClass('active');
});

		$("body").on('click','.btn-support',function(){
			$(this).toggleClass('active-show');
			$(this).prev().toggleClass('active');
			$(".social-fixed ul").hasClass('active') ? setTimeout(() =>{$(this).prev().addClass('overflow-active')},250) : $(".social-fixed ul").removeClass('overflow-active');
		})
		$(document).on('click','.modal-backdrop.in.search-tog',function(event){
			$('.list-inline-item').removeClass('show-search');
			$(this).removeClass('in search-tog')
		});
		$(".js-search-desktop").click(function(e){
			e.preventDefault();
			$(this).parent().toggleClass('show-search');
			$(".modal-backdrop").toggleClass('in search-tog');
		})
		$("body").on("click",".js-call-minicart",function(e){
			e.preventDefault();
			$.when(Wanda.cartmini()).done(() =>{
				$("#cart-mini-wanda").modal({
					fadeDuration: 300
				});
			});
		})
		$("body").on("click",".back-to-top",() =>{$('html,body').animate({scrollTop: 0}, 500);});
		$("body").on("click",".list-variants-img li",function(){
			let data_src = $(this).find('span').data('img');
			$(this).siblings('li').removeClass('active');
			$(this).addClass('active');
			$(this).parents('.product-block').find('.img-first').attr('src',data_src)
		})
		$('body').on('click','#wanda-close-mb-sw,#site-overlay-sw',function(){
			$('#wandave-theme').removeClass('show-add-cart-mb unless-product');
		});
		$('body').on('click','#add-to-cart-sw',function(){
			let id = $('#product-select-sw').val(),quantity = $('#add-item-form-mb').find('#quantity-sw').val();
			Wanda.addtocartmodal(id,quantity);
			$('#wandave-theme').removeClass('show-add-cart-mb buy-now-ss add-now-ss');
		});
    $('body').on('click','.btn-nhanqua',function(){
      	const params = {
				type: 'GET',
				url: "/cart.js",
				success: function(cart) {
           var cartData = cart.items;
           var filteredArray = [];
           var filterArrayQuanty = [];
           cartData.forEach(function (data_new) {
          if(data_new.product_id === 1055966593){
             filteredArray.push(data_new);  
          }
          });                                          
         if(filteredArray.length >= 1 ){
           $("#error-size h5").text("Sản phẩm tặng đã được thêm vào giỏ hàng!");
          $("#error-size").addClass("model-add-size-error");
          setTimeout(function() {
              $("#error-size").removeClass("model-add-size-error")
          },3000);
       }else{
          Wanda.addtocartmodal(1126490539,1)
       }
				},
				error: function(XMLHttpRequest, textStatus) {
					Haravan.onError(XMLHttpRequest, textStatus);
				}
			};
			jQuery.ajax(params);

    })
	},
	scrollcallback: () =>{
		$(window).scroll(function(){
			let scrolltop = $(window).scrollTop();
			Wanda.scrolltopcallback(scrolltop);
			Wanda.recaptcha(scrolltop);
		})
	},
	addtocartmodal: (id,quantity,url) =>{
		let params = {
			type: 'POST',
			url: '/cart/add.js',
			async: true,
			data: 'quantity=' + quantity + '&id=' + id,
			dataType: 'json',
      success:function(line_item){
        // add_to_cart_tracking(line_item, quantity);
        $("#pro-qv-wanda .close-modal").trigger('click');
        $("body").css('overflow-y','');
        $("#pro-qv-wanda").css('opacity','1');
        $("#pro-qv-wanda").css('display','none');
        $(".jquery-modal").removeClass('blocker');
  			$(".model-add-cart").addClass("model-add-cart-success")
        $(".model-add-cart").html(`
  <div class="notify__content">
      <div class="note-cart">
      <img src="https://file.hstatic.net/1000360022/file/_pngtree_check_mark_icon_design_template_4085369_cceb0413ee034bab875a0af11ac90adb.png" style="height: 30px;width: 30px;">
      <p>Thêm vào giỏ hàng thành công</p>
      <button id="close-cart-mini">X</button>
    </div>
      <div class="notify-product">
    <div class="notify-product__thumbnail">
       <img src="${line_item.image}" alt="${line_item.title}"/>
    </div>
    <div class="notify-product__content">
            <span class="notify-product__title">    
                ${line_item.title}
            </span>
            <span class="notify-product__option">
               ${line_item.variant_title}
            </span>
            <div class="notify-product__prices">
              <span>${Haravan.formatMoney(line_item.price,tbag_varible.formatmoney)}</span>
            </div>
        </div>
  </div>
      <a href="/cart" class="btn btn--outline btn--small">Xem giỏ hàng</a>
  </div>
  `)
      $.ajax({
			type: 'GET',
			url: '/cart.js',
			async: false,
			cache: false,
			dataType: 'json',
			success: function (cart){
      localStorage.setItem("number_list", cart.token);
      var copyText = $(".producty-click-1056005900").attr('data-value');
			$('#popupCartModal').modal('hide');
			var variantid = $(`#product-select-${copyText}`).val();
      const key = 'product_selection';
      let uid = localStorage.getItem(key);
      const datacart = {
        token: cart.token,
        total_price: cart.total_price,
        line_item: line_item,
        variant_id: variantid,
        quantity: parseInt(quantity),
        uid: null
      }
       $.ajax({
          type: 'POST',
        	url: 'https://462hk5f9cg.execute-api.ap-southeast-1.amazonaws.com/production/icondenim/checkout/cart/create-cart',
          data: JSON.stringify(datacart),
          dataType: 'json',
          headers: {
             'Authorization': `Bearer ${tokenNew}`,
              'Content-Type': 'application/json'
          },
          withCredentials: true,
        	success: order => {
            if(localStorage.getItem('token_cart_new') !== "" || localStorage.getItem('token_cart_new') !== null){
              localStorage.setItem("token_cart_new", order.data.token);
            }
            Wanda.cartmini()
            setTimeout(() =>{
              tracking_add_to_cart(line_item, quantity);
            },500)
    			},
      			error: (XMLHttpRequest, textStatus) =>{
    			}
    		});
    }
	});
    setTimeout(function() {
      $(".model-add-cart").removeClass("model-add-cart-success")
    },3000);   
      $("#success-cart-wanda .close-modal").trigger('click');

      },
			error: function(XMLHttpRequest, textStatus) {
				Wanda.errormodal('Sản phẩm bạn vừa mua đã vượt quá tồn kho'); 
			}
		};
		jQuery.ajax(params);
	},
	addtocartcheckout: (id,quantity) =>{
		let params = {
			type: 'POST',
			url: '/cart/add.js',
			async: false,
			data: 'quantity=' + quantity + '&id=' + id,
			dataType: 'json',
			success: function (cart){
        // add_to_cart_tracking(quantity, cart);
        BCApp.Tracking.trackingAddItem(quantity, cart);
      $.ajax({
			type: 'GET',
			url: '/cart.js',
			async: false,
			cache: false,
			dataType: 'json',
			success: function (item_cart){
      const key = 'product_selection';
      let uid = localStorage.getItem(key);
      const datacart = {
        token: item_cart.token,
        total_price: item_cart.total_price,
        line_item: cart,
        quantity: parseInt(quantity),
        uid: uid
      }
      var params = {
          type: 'POST',
        	url: 'https://462hk5f9cg.execute-api.ap-southeast-1.amazonaws.com/production/icondenim/checkout/cart/create-cart',
          data: JSON.stringify(datacart),
          dataType: 'json',
          headers: {
             'Authorization': `Bearer ${tokenNew}`,
              'Content-Type': 'application/json'
          },
        	success: order => {
            if(localStorage.getItem('token_cart_new') !== "" || localStorage.getItem('token_cart_new') !== null){
              localStorage.setItem("token_cart_new", order.data.token);
            }
            Wanda.cartmini();
            window.location.href = '/cart';
    			},
      			error: (XMLHttpRequest, textStatus) =>{
    			}
    		};
        jQuery.ajax(params);
    }
	});
				
			},
			error: function(XMLHttpRequest, textStatus) {
				Wanda.errormodal('Sản phẩm bạn vừa mua đã vượt quá tồn kho');
			}
		};
		jQuery.ajax(params);
	},
	successadtocart: (jqXHR, textStatus, errorThrown) =>{
     // add_to_cart_tracking(jqXHR, jqXHR.quantity);
    // BCApp.Tracking.trackingAddItem(jqXHR.quantity,jqXHR);
     Wanda.cartmini()
		$.ajax({
			type: 'GET',
			url: '/cart.js',
			async: false,
			cache: false,
			dataType: 'json',
			success: function (cart){
      const datacart = {
        token: cart.token,
        total_price: cart.total_price,
        line_item: jqXHR,
      }
      var params = {
          type: 'POST',
        	url: 'https://462hk5f9cg.execute-api.ap-southeast-1.amazonaws.com/production/icondenim/checkout/cart/create-cart',
          data: JSON.stringify(datacart),
          dataType: 'json',
          headers: {
             'Authorization': `Bearer ${tokenNew}`,
              'Content-Type': 'application/json'
          },
        	success: order => {
            Wanda.cartmini()
    			},
      			error: (XMLHttpRequest, textStatus) =>{
    			}
    		};
        jQuery.ajax(params);
    }
	});
},
	menumobile: () =>{
		getdatasite("/?view=menu-mobile",$("#menu-mobile .mb-menu"),'false');
		$(document).on('click','.menu-active #site-overlay,#wanda-close-handle',function(event){
			$("#wandave-theme").removeClass('menu-active');
		});
		$("body").on("click",".btn-menu-mb",function(){
			$("body").toggleClass('menu-active');
		})
		// $('body').on('click','.cl-open-mobile',function(event){
		// 	$(this).next().slideToggle('fast')
		// });
    $('body').on('click', '.cl-open-mobile', function (e) {
  e.preventDefault(); // tránh anchor nhảy trang
  const $li = $(this).closest('li');
  const $submenu = $li.children('ul.menu-childrent');

  $submenu.stop(true, true).slideToggle('fast');
  // option: toggle class cho icon mũi tên
  $(this).toggleClass('is-open');
  // option: aria
  $(this).attr('aria-expanded', $(this).hasClass('is-open'));
});
       $("body").on("click","#close-cart-mini",function(){
      $("#cart-popup").removeClass("model-add-cart-success")
    })
    $("body").on("click",".hailoc-content-combo", function() {
      $("#modal-subscribe").modal("show");
      		$("#modal-subscribe").modal({
					fadeDuration: 200
				});
    })
	},
	cartmini: () =>{
    const token = localStorage.getItem('token_cart_new');
    const datatoken = {token: token}
    if(localStorage.getItem('token_cart_new') !== "" || localStorage.getItem('token_cart_new') !== null){
      $.ajax({
		    type: 'POST',
        	url: 'https://462hk5f9cg.execute-api.ap-southeast-1.amazonaws.com/production/icondenim/checkout/cart/get-all-cart-mini',
          data: JSON.stringify(datatoken),
          dataType: 'json',
          headers: {
             'Authorization': `Bearer ${tokenNew}`,
              'Content-Type': 'application/json'
          },
			success: function(data){
				let item = '',index = 1,total_price = 0,total_sale = 0,htmlMini='',quantity=0,htmlDelete='',htmlQuantity='',htmlGift;
				if(data && Object.keys(data).length > 0){
					$.each(data.data.items, function(i, v){
              if(parseInt(v.price_original) > parseInt(v.line_price)){
              var price_re = (parseInt(v.price_original)*parseInt(v.quantity)) - (parseInt(v.line_price)*parseInt(v.quantity));
              total_sale += price_re;
            }
            var price_new = (parseInt(v.price_original)*parseInt(v.quantity));
            total_price += price_new;
            var quantity_new = parseInt(v.quantity);
            
            quantity += quantity_new;
             if(v.product_id === 1070362836 || v.product_id === 1062167385 || v.product_id === 1062392639 || v.product_id === 1055530425){
            htmlQuantity=`<div class="quantity-area-cartmini"> <strong>x${v.quantity}</strong> <input style="display: none;" type="text" id="quantity_minicart" data-variant="${v.variant_id}" data-cart ="${v.cart_id}" name="quantity_minicart" value="${v.quantity}" min="1" class="quantity-mini"></div>`
            htmlDelete=``
            htmlGift=`<div>
                      <div class="cart-gift">
                      <img style="width: 20px;height: 15px;margin-right:5px;" src="https://mcdn.coolmate.me/image/April2023/mceclip0_94.png" style="width: 20px;height: 15px;">Quà tặng
                        </div>
                      <div class="cart_des"><a class="pro-title-view" href="${v.url}" title="${v.title}">${v.title}</a></div>
            </div>`
            }else{
                htmlQuantity = ` 
              <div class="quantity-area-cartmini"> 
               <input style="border:none" type="text" id="quantity_minicart" data-variant="${v.variant_id}" data-cart ="${v.cart_id}" name="quantity_minicart" value="x${v.quantity}" min="1" class="quantity-mini">
              </div>`
              htmlDelete=`    <span class="remove_link remove-cart">
        <a href="javascript:void(0);" onclick="Wanda.deletecart(${index},0,${v.variant_id},${v.cart_id},'remove')"><i class="fa fa-times"></i></a>
       </span> `
               // htmlDelete=``
              htmlGift=`<a class="pro-title-view" href="${v.url}" title="${v.title}">${v.title}</a> `
            }
							item += `
       <tr class="list-item" data-line="${index}"><td class="img">
       <a href="${v.url}" title="${v.title}"><img src="${v.image}" alt="${v.title}"></a>
       </td>
       <td class="item"> 
       ${htmlGift}
       <span class="variant">${v.variant_title}</span>
       ${htmlQuantity}
        <span class="pro-price-view"> ${Haravan.formatMoney(v.price * 100,tbag_varible.formatmoney)}</span> 
        ${htmlDelete}
       </td>
       </tr>`;
						index++;
					});
      var totalPrice = data.data.total_price;
      let totalNew = (399000 - totalPrice) * 100;
      let totalNew_2 = (699000 - totalPrice) * 100;
      let totalNew_3 = (999000 - totalPrice) * 100;
      let totalNew_4 = (1499000 - totalPrice) * 100;
      var dataItem = data.data.items;
    if (totalPrice >= 10000 && totalPrice < 200000){
      $(".flashsale___percent-cart").css('width', `10%`)
      $("#cart-mini-wanda .content_title").html(`Mua thêm ${Haravan.formatMoney(totalNew,tbag_varible.formatmoney)} để giảm ngay 20K! (Only online)`)
    }else if(totalPrice >= 200000 && totalPrice < 299000){
      $(".flashsale___percent-cart").css('width', `20%`)
      $("#cart-mini-wanda .content_title").html(`Mua thêm ${Haravan.formatMoney(totalNew,tbag_varible.formatmoney)} để giảm ngay 20K! (Only online)`)
    }else if(totalPrice >= 299000 && totalPrice < 400000){
      $(".flashsale___percent-cart").css('width', `30%`)
      $("#cart-mini-wanda .content_title").html(`Bạn được <strong>giảm 20K</strong> đơn từ 399K, mua thêm ${Haravan.formatMoney(totalNew_2,tbag_varible.formatmoney)} để giảm ngay 50K! (Only online)`)
    }else if(totalPrice >= 400000 && totalPrice <= 698000){
      $(".flashsale___percent-cart").css('width', `40%`)
      $("#cart-mini-wanda .content_title").html(`Bạn được <strong>giảm 20K</strong> đơn từ 399K, mua thêm ${Haravan.formatMoney(totalNew_2,tbag_varible.formatmoney)} để giảm ngay 50K! (Only online)`)
    }else if (totalPrice >= 699000 && totalPrice < 700000){
      $(".flashsale___percent-cart").css('width', `50%`)
      $("#cart-mini-wanda .content_title").html(`Bạn được <strong>giảm 50K</strong>, mua thêm ${Haravan.formatMoney(totalNew_3,tbag_varible.formatmoney)} để giảm ngay 80K! (Only online)`)
    }else if (totalPrice >= 700000 && totalPrice <= 898000){
      $(".flashsale___percent-cart").css('width', `60%`)
      $("#cart-mini-wanda .content_title").html(`Bạn được <strong>giảm 50K</strong>, mua thêm ${Haravan.formatMoney(totalNew_3,tbag_varible.formatmoney)} để giảm ngay 80K! (Only online)`)
    }else if (totalPrice >= 899000 && totalPrice < 999000){
      $(".flashsale___percent-cart").css('width', `70%`)
      $("#cart-mini-wanda .content_title").html(`Bạn được <strong>giảm 50K</strong>, mua thêm ${Haravan.formatMoney(totalNew_3,tbag_varible.formatmoney)} để giảm ngay 80K! (Only online)`)
    }else if (totalPrice >= 999000 && totalPrice < 1499000){
      $(".flashsale___percent-cart").css('width', `85%`)
      $("#cart-mini-wanda .content_title").html(`Bạn được <strong>giảm 80K</strong>, mua thêm ${Haravan.formatMoney(totalNew_4,tbag_varible.formatmoney)} để giảm ngay 150K! (Only online)`)
    }else if (totalPrice >= 1499000){
      $(".flashsale___percent-cart").css('width', `100%`)
      $("#cart-mini-wanda .content_title").html(`Đơn hàng của bạn đã đủ điều kiện giảm 150K, nhớ nhập mã nhé!🎉 (Only online)`)
    }else if (totalPrice <= 0) {
      $(".flashsale___percent-cart").css('width', `0%`)
      $("#cart-mini-wanda .content_title").html(`GIẢM NGAY 20K khi bạn mua thêm 399,000₫ nữa! (Only online)`)
    }   
// if (totalPrice >= 10000 && totalPrice < 200000){
//     $(".flashsale___percent-cart-cart").css('width', `10%`)
//     $("#cart-mini-wanda .content_title").html(`Mua thêm ${Haravan.formatMoney(totalNew,tbag_varible.formatmoney)} để giảm ngay 15K!`)
//   }else if(totalPrice >= 200000 && totalPrice < 299000){
//         $(".flashsale___percent-cart-cart").css('width', `20%`)
//     $("#cart-mini-wanda .content_title").html(`Mua thêm ${Haravan.formatMoney(totalNew,tbag_varible.formatmoney)} để giảm ngay 15K!`)
//   }else if(totalPrice >= 299000 && totalPrice < 400000){
//     $(".flashsale___percent-cart-cart").css('width', `30%`)
//     $("#cart-mini-wanda .content_title").html(`Bạn được <strong>giảm 15K</strong> đơn từ 299K, mua thêm ${Haravan.formatMoney(totalNew_2,tbag_varible.formatmoney)} để giảm ngay 40K!`)
//   }else if(totalPrice >= 400000 && totalPrice <= 598000){
//       $(".flashsale___percent-cart-cart").css('width', `40%`)
//       $("#cart-mini-wanda .content_title").html(`Bạn được <strong>giảm 15K</strong> đơn từ 299K, mua thêm ${Haravan.formatMoney(totalNew_2,tbag_varible.formatmoney)} để giảm ngay 40K!`)
//   }else if (totalPrice >= 599000 && totalPrice < 700000){
//    $(".flashsale___percent-cart-cart").css('width', `50%`)
//     $("#cart-mini-wanda .content_title").html(`Bạn được <strong>giảm 40K</strong>, mua thêm ${Haravan.formatMoney(totalNew_3,tbag_varible.formatmoney)} để giảm ngay 70K!`)
//   }else if (totalPrice >= 700000 && totalPrice <= 898000){
//    $(".flashsale___percent-cart-cart").css('width', `60%`)
//      $("#cart-mini-wanda .content_title").html(`Bạn được <strong>giảm 40K</strong>, mua thêm ${Haravan.formatMoney(totalNew_3,tbag_varible.formatmoney)} để giảm ngay 70K!`)
//   }else if (totalPrice >= 899000 && totalPrice < 999000){
//    $(".flashsale___percent-cart-cart").css('width', `70%`)
//     $("#cart-mini-wanda .content_title").html(`Bạn được <strong>giảm 40K</strong>, mua thêm ${Haravan.formatMoney(totalNew_3,tbag_varible.formatmoney)} để giảm ngay 70K!`)
//   }else if (totalPrice >= 999000){
//    $(".flashsale___percent-cart-cart").css('width', `100%`)
//      $("#cart-mini-wanda .content_title").html(`Đơn hàng của bạn đã đủ điều kiện giảm 70K, nhớ nhập nha 🎉`)
//   }else if (totalPrice <= 0) {
//         $(".flashsale___percent-cart-cart").css('width', `0%`)
//     $("#cart-mini-wanda .content_title").html(`GIẢM NGAY 20K khi bạn mua thêm 299,000₫ nữa!`)
//   }     
    


					$("#cart-mini-wanda #cart-view tbody").html(item);
          $("#cart-mini-wanda .table-total #final-view-cart").html(Haravan.formatMoney(data.data.total_price *100,formatMoney));
          $("#cart-mini-wanda .table-total #sale-view-cart").html(Haravan.formatMoney(total_sale,formatMoney));
					$("#cart-mini-wanda .table-total #total-view-cart").html(Haravan.formatMoney(data.data.total_price * 100,formatMoney));
					$(".js-number-cart-new").html(quantity);
				}
				else{
					$("#cart-mini-wanda #cart-view tbody").html(`<tr><td class="mini_cart_header text-center" style="padding-right:0;"><svg width="60" height="60" viewBox="0 0 81 70"><g transform="translate(0 2)" stroke-width="4" stroke="#000" fill="none" fill-rule="evenodd"><circle stroke-linecap="square" cx="34" cy="60" r="6"></circle><circle stroke-linecap="square" cx="67" cy="60" r="6"></circle><path d="M22.9360352 15h54.8070373l-4.3391876 30H30.3387146L19.6676025 0H.99560547"></path></g></svg><p>Hiện chưa có sản phẩm</p></td></tr>`);
					$("#cart-mini-wanda .table-total #total-view-cart").html('0₫');
          $("#cart-mini-wanda .table-total #final-view-cart").html('0₫');
          $("#cart-mini-wanda .table-total #sale-view-cart").html('0₫');
					$(".js-number-cart-new").html('0');
				}
			}
		})
    }
	},
	deletecart: (line,qty,variantId,cart_id,action) =>{
		let params = {
			type: 'POST',
			url: '/cart/change.js',
			data: 'quantity='+qty+'&line=' + line,
			dataType: 'json',
			success: function(cart) {
      Wanda.cartmini();
      var dataVariant = {
        variant_id: variantId,
        cart_id: cart_id,
        quantity: qty,
        total_price: cart.total_price,
        action: action,
      }
      var paramsUpdate = {
          type: 'POST',
        	url: 'https://462hk5f9cg.execute-api.ap-southeast-1.amazonaws.com/production/icondenim/checkout/cart/remove-mini',
          data: JSON.stringify(dataVariant),
          dataType: 'json',
          headers: {
                 'Authorization': `Bearer ${tokenNew}`,
            'Content-Type': 'application/json'
          },
        	success: order => {
              Wanda.cartmini();
          },
      		error: (XMLHttpRequest, textStatus) =>{
    			}
    		};
        jQuery.ajax(paramsUpdate);
			},
			error: (XMLHttpRequest, textStatus) => {
				Wanda.errormodal(textStatus);
			}
		};
		jQuery.ajax(params);
	},
  deletecartsale: line =>{
		let params = {
			type: 'POST',
			url: '/cart/change.js',
			data: 'quantity=0&line=' + line,
			dataType: 'json',
			success: function(cart) {
        localStorage.setItem("combo_icon", "");
        Wanda.cartmini();
			},
			error: (XMLHttpRequest, textStatus) => {
				Wanda.errormodal(textStatus);
			}
		};
		jQuery.ajax(params);
	},
	plusqt_minicart: $this => {
		if ( $this.siblings('input[name="quantity_minicart"]').val() != undefined ) {
			let currentVal = parseInt($this.siblings('input[name="quantity_minicart"]').val());
			if (!isNaN(currentVal)) {$this.siblings('input[name="quantity_minicart"]').val(currentVal + 1);} else {$this.siblings('input[name="quantity_minicart"]').val(1);}}
		let line_plus = $this.parents('.list-item').attr('data-line'), qty_plus = parseInt($this.siblings('input[name="quantity_minicart"]').val()),action = 'plus',variantId = parseInt($this.siblings('input[name="quantity_minicart"]').data('variant')),cartId = parseInt($this.siblings('input[name="quantity_minicart"]').data('cart'));
		Wanda.update_cart_mini(line_plus,qty_plus,variantId,cartId,action)
	},
	minusqt_minicart: $this => {
		if ($this.siblings('input[name="quantity_minicart"]').val() != undefined ) {
			let currentVal = parseInt($this.siblings('input[name="quantity_minicart"]').val());if (!isNaN(currentVal) && currentVal > 1) {	$this.siblings('input[name="quantity_minicart"]').val(currentVal - 1);}
			let line_mn = $this.parents('.list-item').attr('data-line'),qty_mn = parseInt($this.siblings('input[name="quantity_minicart"]').val()),action = 'minus',variantId = parseInt($this.siblings('input[name="quantity_minicart"]').data('variant')),cartId = parseInt($this.siblings('input[name="quantity_minicart"]').data('cart'));
			Wanda.update_cart_mini(line_mn,qty_mn,variantId,cartId,action);
		}
	},
	update_cart_mini: (line,qty,variantId,cart_id,action) =>{
		let params = {
			type: 'POST',
			url: '/cart/change.js',
			data: 'quantity='+qty+'&line=' + line,
			dataType: 'json',
      headers: {
        'Content-Type': 'application/json'
      },
			success: function(cart) {
      var dataVariant = {
        variant_id: variantId,
        cart_id: cart_id,
        quantity: qty,
        total_price: cart.total_price,
        action: action,
      }
      var paramsUpdate = {
          type: 'POST',
        	url: 'https://462hk5f9cg.execute-api.ap-southeast-1.amazonaws.com/production/icondenim/checkout/cart/remove-mini',
          data: JSON.stringify(dataVariant),
          dataType: 'json',
          headers: {
            'Authorization': `Bearer ${tokenNew}`,
        		"Content-Type": "application/json"
          },
        	success: order => {
            Wanda.cartmini();
    			},
      		error: (XMLHttpRequest, textStatus) =>{
    			}
    		};
        jQuery.ajax(paramsUpdate);
			},
			error: (XMLHttpRequest, textStatus) =>{
				Haravan.onError(XMLHttpRequest, textStatus);
			}
		};
		jQuery.ajax(params);
	},
	smartsearch: () =>{
		let $input = $('.wanda-mxm-search .search-input');
		$input.keyup(function(){
			let key = $(this).val(),$results = $(this).parents('.site_search').find('#wanda-smart-search .results-seach');
			if(key.indexOf('script') > -1 || key.indexOf('>') > -1){
				alert('Từ khóa của bạn có chứa mã độc hại ! Vui lòng nhập lại key word khác');
				$(this).val('');
				$input.val('');
			}
			else{
				if(key.length > 0 ){
					$input.val(key);
					$(this).attr('data-history', key);
					let str = '';
					setTimeout(() =>{
						str = '/search?q=filter='+encodeURIComponent('((title:product ** ' + key + ')||(product_type:product ** ' + key + ') ||(sku:product ** ' + key + '))')+'&view=smart-json';
						let locationhref = '/search?q=filter='+encodeURIComponent('((title:product ** ' + key + ')||(product_type:product ** ' + key + ') ||(sku:product ** ' + key + '))');
						$.ajax({
							url: str,
							type: 'GET',
							dataType: "json",
							async: true,
							success: function(data){
								let item = '',index = 0;
								if(data.length > 2){
									$.each(data, function(i, v){
										if(i < data.length - 2){
											item += `<div class="item-ult"><div class="thumbs"><a href="${v.url}"><img alt="${v.title}" src="${v.thumbnail}" /></a></div><div class="title"><a href="${v.url}" class="title-pro" title="${v.title}">${v.title}</a><p class="f-initial">${v.price}<del data-price="${v.compare_at_price}">${v.compare_at_price}</del></p></div></div>`;}
										index = i;
									});
									$results.html(item);
									if(parseInt(data[index -1].viewmore) > 0){
										$results.append('<a class="view-more-search" href="'+locationhref+'">Xem thêm ' + data[index-1].viewmore + ' kết quả tìm kiếm</a>')
									}else{
										$results.append('<a class="view-more-search" href="'+locationhref+'">Có <span>' +data[index].total_search+ '</span> kết quả tìm kiếm</a>')
									}
								}else{
									$results.html('Không có sản phẩm phù hợp!');
								}
							}
						});
					},300)								 
					setTimeout(() =>{$results.fadeIn();},450)
				}
				else{
					$input.val(key);
					$results.fadeOut();
				}
			}
		});
		$("form[action='/search']").submit(function(e){
			e.preventDefault();
			let key = encodeURIComponent($(this).find('input[name="q"]').val()),locationhref = '/search?q=' + key + '&type=product';
			window.location.href = locationhref;
		})
	},
	hometabajax: () =>{
		$("#home-tab-col li a").click(function(e){
			e.preventDefault();
			let $this = $(this),dataid = $this.attr('href'),url= $this.attr('data-url'),selector_tab = $(dataid);
			$(".tab-result .tab-pane").hide();
			$("#home-tab-col li a").removeClass('active');
			$this.addClass('active');
			if(!$this.hasClass('success-ajax')){
				$.when(getdatasite(url,selector_tab,'false')).then(setTimeout(()=>{Wanda.firstcbwl()},100));
				$this.addClass('success-ajax');
			}
			$(dataid).show();
		})
	},
	scrolltopcallback: scrolltop =>{
		if(scrolltop > 100){$(".back-to-top,.social-fixed").addClass('show')}else{$(".back-to-top,.social-fixed").removeClass('show')};
	},
	recaptcha: scrolltop =>{
		if(checkrecaptcha == false && scrolltop > 500){
			setTimeout(() =>{
				grecaptcha.ready(function() {grecaptcha.execute('6LdD18MUAAAAAHqKl3Avv8W-tREL6LangePxQLM-', {action: 'submit'}).then(function(token) {$('.form-ft-wanda input[name="g-recaptcha-response"]').val(token);});});
			},1000);
			checkrecaptcha = true;
		}
	},
	errormodal: data =>{
		$("#modal-error p").html(data);
		$("#modal-error").modal({
			fadeDuration: 200
		});
	},
	modalcontact: () =>{
		if(sessionStorage.modal_sub == null ){
			sessionStorage.modal_sub = 'show' ;			
			setTimeout(() =>{
				$("#modal-subscribe").modal({
					fadeDuration: 200
				});
			},3000);
		}
		let checkrecappopup = false;
		if(checkrecappopup == false){
			setTimeout(() =>{
				grecaptcha.ready(function() {grecaptcha.execute('6LdD18MUAAAAAHqKl3Avv8W-tREL6LangePxQLM-', {action: 'submit'}).then(function(token) {$('#modal-subscribe form input[name="g-recaptcha-response"]').val(token);});});
			},3000);
			checkrecappopup = true;
		}
		$('#modal-subscribe form,.form-ft-wanda form').submit(function(e){
			e.preventDefault();
			let self = $(this);
			let emaill = self.find('input[name="contact[email]"]').val(),tag = self.find('input[name="contact[tags]"]').val(),recapcha = self.find('input[name="g-recaptcha-response"]').val();
			$.ajax({
				type: 'POST',
				url:'/account/contact',
				dataType:'json',
				data: "form_type=customer&utf8=✓&contact[email]="+emaill+"&contact[tags]="+tag+"&g-recaptcha-response="+recapcha,
				complete: function(responseText){
					Wanda.modalsubsucess();
					self.trigger('reset');
				}
			})
		});
	},
	modalsubsucess: () =>{
		$("#success-subcribe-wanda").modal({
			fadeDuration: 200
		});
		setTimeout(() =>{
			$("#success-subcribe-wanda .close-modal").trigger('click');
		},3000)
	},
	wlgroup: () =>{
		let lcwishlist = '';
		if(localStorage.getItem('wishlist_tbag') == null){
			localStorage.setItem('wishlist_tbag', '[]');
			localStorage.setItem('wishlist_tbag_arr', '[]');
		}
		const localpro = JSON.parse(localStorage.getItem('wishlist_tbag')),jsonpro = JSON.parse(localStorage.getItem('wishlist_tbag_arr'));
		$(".js-number-like").html(localpro.length)
		$("body").on("click",".wishlist-loop",function(){
			let handle = $(this).data('handle');
			$(`.wishlist-loop[data-handle="${handle}"]`).toggleClass('active');
			if($(this).hasClass('active')){
				$(`.wishlist-loop[data-handle="${handle}"]`).attr('data-original-title','Bỏ yêu thích');
				$(`.wishlist-loop[data-handle="${handle}"]`).find('img').attr('src',tbag_varible.heartactive);
				localpro.push(handle)
				localStorage.setItem('wishlist_tbag', JSON.stringify(localpro));
				fetch('/products/'+handle+'.js')
					.then(function(response) {
					return response.json();
				})
					.then(product =>{
					jsonpro.push(product)
					localStorage.setItem('wishlist_tbag_arr', JSON.stringify(jsonpro));
				})
					.catch(function(error){
					console.log(error);
				});
			}
			else{
				$(`.wishlist-loop[data-handle="${handle}"]`).attr('data-original-title','Yêu thích');
				$(`.wishlist-loop[data-handle="${handle}"]`).find('img').attr('src',tbag_varible.heart);
				for( let i = 0; i < localpro.length; i++){ 
					if(localpro[i] == handle){
						localpro.splice(i, 1); 
						localStorage.setItem('wishlist_tbag', JSON.stringify(localpro));
					}
				}
				for( let i = 0; i < jsonpro.length; i++){ 
					if(jsonpro[i].handle == handle){
						jsonpro.splice(i, 1); 
						localStorage.setItem('wishlist_tbag_arr', JSON.stringify(jsonpro));
					}
				}
			} 
			$(".js-number-like").html(localpro.length)
		});
	},
	firstcbwl: () =>{
		let firstcb = JSON.parse(localStorage.getItem('wishlist_tbag'));
		for( let i = 0; i < firstcb.length; i++){ 
			$(`.wishlist-loop[data-handle="${firstcb[i]}"]`).addClass('active').find('img').attr('src',tbag_varible.heartactive);
			$(`.wishlist-loop[data-handle="${firstcb[i]}"]`).attr('data-original-title','Bỏ yêu thích');
		}
	},
	suggess_notify: () =>{
		const ivtsg = setInterval(function() {
			let item = "/products/"+ tbag_radom.item[Math.floor(Math.random() * tbag_radom.item.length)] + ".js",
					name = tbag_radom.name[Math.floor(Math.random() * tbag_radom.name.length)],
					time = tbag_radom.time[Math.floor(Math.random() * tbag_radom.time.length)];
			fetch(item)
				.then(function(response) {
				return response.json();
			})
				.then(product =>{
				let tpsg = 
						`<div class="item">
<div class="d-flex d-flex-center">
<div class="image">
<img src="${Haravan.resizeImage(product.featured_image, 'medium')}" width="100" height="70" alt="${product.title}">
</div>
<div class="content">
<p class="custom-notification-content">
${name}<br>vừa mua <a href="${product.url}"><b>${product.title}</b></a>
<small>${time}</small>
</p>
</div>
</div>
<div class="close-notify"></div>
</div>`;
				$(".suggest-notify").html(tpsg).removeClass('anislideOutDown').addClass('anislideInUp');
				setTimeout(() =>{
					$(".suggest-notify").removeClass('anislideInUp').addClass('anislideInDown');
				},5000)
			}) 
				.catch(function(error) {
				console.log(error);
			});
		},10000);
		$("body").on("click",".close-notify",function(){
			clearInterval(ivtsg);
			$(".suggest-notify").removeClass('anislideInUp').addClass('anislideInDown');
		})
	},
	collectionsale: () =>{
		const second = 1000,minute = second * 60,hour = minute * 60,day = hour * 24,countDown = new Date($(".countdown-deal").data('countdown')).getTime();
		let x = setInterval(function() {
			let now = new Date().getTime(),
					distance = countDown - now,
					countday = Math.floor(distance / (day)),
					counthour = Math.floor((distance % (day)) / (hour)),
					countminute = Math.floor((distance % (hour)) / (minute)),
					countsecond = Math.floor((distance % (minute)) / second);
			countday > 9 ? $('.countdown-deal .days').text(countday) : $('.countdown-deal .days').text('0'+countday);
			counthour > 9 ? $('.countdown-deal .hours').text(counthour) : $('.countdown-deal .hours').text('0'+counthour);
			countminute > 9 ? $('.countdown-deal .minutes').text(countminute) : $('.countdown-deal .minutes').text('0'+countminute);
			countsecond > 9 ? $('.countdown-deal .seconds').text(countsecond) : $('.countdown-deal .seconds').text('0'+countsecond);
			if (distance < 0) {
				$('.countdown-deal .days,.countdown-deal .hours,.countdown-deal .minutes,.countdown-deal .seconds').text("00"),
					clearInterval(x);
			} 
		}, second)
		},
	showquickmb: handle =>{
		let url_sw = handle +'?view=swatch-mobile', data_result_sw = $(".result-swatch-mb");
		getdatasite(url_sw,data_result_sw,'false');
		$("#wandave-theme").addClass('show-add-cart-mb unless-product');
	},
	slidercallback: () =>{
		if($(".slick-callback").not('.slick-initialized,#slider-thumb').length > 0){
			$(".slick-callback").not('.slick-initialized,#slider-thumb').each(function(){
				let self = $(this),
						obslick = {
							autoplay: self.data('autoplay'),
							infinite: self.data('infinite') || false,
							dots: self.data('dots') || false,
							slidesToShow: self.data('slides-md'),
							slidesToScroll: self.data('slides-md-scroll'),
							autoplaySpeed: 4000,
							vertical: self.data('vertical') || false,
              fade: self.data('fade') || false,
							responsive: [
								{
									breakpoint: 1200,
									settings: {
										slidesToShow: self.data('slides-tablet'),
										slidesToScroll: self.data('slides-sm-scroll'),
									},
								},
								{
									breakpoint: 1024,
									settings: {
										slidesToShow: self.data('slides-tablet'),
										slidesToScroll: self.data('slides-sm-scroll'),
									},
								},
								{
									breakpoint: 767,
									settings: {
										slidesToShow: self.data('slides-xs'),
										slidesToScroll: self.data('slides-xs-scroll'),
										vertical: self.data('vertical-mb') || false,
									},
								},
							],
							prevArrow: tbag_varible.navLeftText,
							nextArrow: tbag_varible.navRightText,
							adaptiveHeight: true
						}
				self.slick(obslick);
             self.on('setPosition', function () {
        self.find('img').each(function () {
          const src = $(this).attr('src');
          $(this).attr('src', src); // ép trình duyệt load lại ảnh
        });
      });
			});
		}
	},
  handleScroll: function(){
			this.arrows.find('i').removeClass('disabled')
			if(this.totalStep - 1 <= this.scrollStep ){
				this.arrows.find('.next').addClass('disabled')
				this.scrollStep = this.totalStep - 1
			}
			if(this.scrollStep <= 0){
				this.arrows.find('.prev').addClass('disabled')
				this.scrollStep = 0
			}
			this.item.find('.menu-item__link').css('transform', this.transform())
		},
  checkout: () =>{
		$("body").on("click",".wanda-checkout-url",function(e){
			e.preventDefault();
			const params = {
				type: 'GET',
				url: "/cart.js",
				success: function(cart) {
         window.location = "/cart";
				},
				error: function(XMLHttpRequest, textStatus) {
					Haravan.onError(XMLHttpRequest, textStatus);
				}
			};
			jQuery.ajax(params);
		})
	},


  getCountCart: () =>{
    const token = localStorage.getItem('token_cart_new');
    const key = 'product_selection';
    let voucherValue = "";
    let uid = localStorage.getItem(key);
    const datatoken = {
      token: token,
      customer_id: null,
      profile: null,
      uid: uid,
    }
    if (token) {
      var params = {
      type: 'POST',
      url: 'https://462hk5f9cg.execute-api.ap-southeast-1.amazonaws.com/production/icondenim/checkout/cart/get-all-cart-mini',
      data: JSON.stringify(datatoken),
      dataType: 'json',
        headers: {
        'Authorization': `Bearer ${tokenNew}`,
        'Content-Type': 'application/json'
      },
        	success: order => {
            if(order.data.items?.length > 0){
            const dataItems = order.data.items
            const productIds = dataItems.map(item => item.product_id)
            const totalQuantity = dataItems.reduce((sum, item) => sum + item.quantity, 0);
            $(".js-number-cart-new").html(totalQuantity);
            // if(order.data.abandoned_cart_vouchers.length > 0){
            //   localStorage.setItem('isView', true);
            //   $('#coupon-img').attr('data-ega-coupon', `${order.data.abandoned_cart_vouchers[0].code}`);
            //   voucherValue = order.data.abandoned_cart_vouchers[0].code;
            //   $(".code-content").text(`${order.data.abandoned_cart_vouchers[0].code}`)
            //   $(".hailoc-content-combo").addClass("promotion-show")
            //   $(".camp-jeans").addClass("promotion-show")
            //   $(".coupon-jeans").addClass("promotion-show")
            // }
  //             	if(sessionStorage.modal_sub == null ){
		// 	sessionStorage.modal_sub = 'show' ;			
		// 	setTimeout(() =>{
		// 		$("#modal-subscribe").modal({
		// 			fadeDuration: 200
		// 		});
		// 	},3000);
		// }
		// let checkrecappopup = false;
		// if(checkrecappopup == false){
		// 	setTimeout(() =>{
		// 		grecaptcha.ready(function() {grecaptcha.execute('6LdD18MUAAAAAHqKl3Avv8W-tREL6LangePxQLM-', {action: 'submit'}).then(function(token) {$('#modal-subscribe form input[name="g-recaptcha-response"]').val(token);});});
		// 	},3000);
		// 	checkrecappopup = true;
		// }
		// $('#modal-subscribe form,.form-ft-wanda form').submit(function(e){
		// 	e.preventDefault();
		// 	let self = $(this);
		// 	let emaill = self.find('input[name="contact[email]"]').val(),tag = self.find('input[name="contact[tags]"]').val(),recapcha = self.find('input[name="g-recaptcha-response"]').val();
		// 	$.ajax({
		// 		type: 'POST',
		// 		url:'/account/contact',
		// 		dataType:'json',
		// 		data: "form_type=customer&utf8=✓&contact[email]="+emaill+"&contact[tags]="+tag+"&g-recaptcha-response="+recapcha,
		// 		complete: function(responseText){
		// 			Wanda.modalsubsucess();
		// 			self.trigger('reset');
		// 		}
		// 	})
		// });
            }
            // }else{
            //   localStorage.removeItem('isView');
            //   $(".hailoc-content-combo").removeClass("promotion-show")
            //   $(".camp-jeans").removeClass("promotion-show")
            //   $(".coupon-jeans").removeClass("promotion-show")
            // }
          },
        error: (XMLHttpRequest, textStatus) =>{
    			}
        };
      jQuery.ajax(params);
//   $("body").on("click",".btn-saochep",function(e){
// e.preventDefault();
// var copyTextarea = document.createElement("textarea");
// copyTextarea.textContent = voucherValue;
// copyTextarea.style.position = "fixed";
// $('body').append(copyTextarea);
// copyTextarea.select();
// document.execCommand("copy");
// document.body.removeChild(copyTextarea);
// var cur_text = $(this).text(); 
// var $cur_btn = $(this);
// $(".btn-saochep").removeClass('iscopied')
// $(this).addClass("iscopied");
// $('.btn-saochep.iscopied').css('background-image', 'url("https://file.hstatic.net/1000360022/file/banner_web_qu_n_jean_t6_coppied_button.png")');
// });
    }


  },
  
} 
// $(function(){
// 	Wanda.heightheader();
// 	$(window).resize(function() {
// 		Wanda.heightheader();
// 	});
// })

$(window).load(() =>{
	if(navigator[_0x2c0xa[2]][_0x2c0xa[1]](_0x2c0xa[0])==  -1){
		setTimeout(() =>{!function(e,t,n){var o,c=e.getElementsByTagName(t)[0];e.getElementById(n)||((o=e.createElement(t)).id=n,o.src="//connect.facebook.net/vi_VN/sdk.js#xfbml=1&version=v2.0",c.parentNode.insertBefore(o,c))}(document,"script","facebook-jssdk");},3000)
		Wanda.init();
	}
})
