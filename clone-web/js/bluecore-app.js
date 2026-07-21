window.BCApp = window.BCApp || {};
BCApp.Config = {
	listCart: []
};
BCApp.Tracking = {
	trackingAddItem: function(quantity,line_item){
		var cart_token = '';
		$.ajax({
			async:false,
			url:'/cart.js',
			success:function(cart){
				BCApp.Config.listCart = cart.items;
				cart_token = cart.token;
			}
		})
		var data_tracking ={
			token : cart_token,
			customer_id:window.CustomerShop.customerId,
			customer_phone:window.CustomerShop.customerPhone,
			customer_email:window.CustomerShop.customerEmail,
			product_id:line_item.product_id.toString(),
			variant_id:line_item.id.toString(),
			quantity:parseInt(quantity),
			info:JSON.stringify(line_item)
		};
		$.ajax({
			type:'POST', 
			url:'/apps/flashsale/tracking_add_cart.json',
			headers: {
				"Content-Type": "application/json"
			},
			data: JSON.stringify(data_tracking),
			success:function(data){

			}
		})
	},
	trackingRemoveItem: function(quantity,line_item){
		var cart_token = '';
		$.ajax({
			async:false,
			url:'/cart.js',
			success:function(cart){
				BCApp.Config.listCart = cart.items;
				cart_token = cart.token;
			}
		})
		var data_tracking ={
			token : cart_token,
			customer_id:window.CustomerShop.customerId,
			customer_phone:window.CustomerShop.customerPhone,
			customer_email:window.CustomerShop.customerEmail,
			product_id:line_item.product_id.toString(),
			variant_id:line_item.id.toString(),
			quantity:parseInt(quantity),
			info:JSON.stringify(line_item)
		};
		$.ajax({
			type:'POST', 
			url:'/apps/flashsale/tracking_remove_cart.json',
			headers: {
				"Content-Type": "application/json"
			},
			data: JSON.stringify(data_tracking),
			success:function(data){

			}
		})
	}
};
BCApp.Main = {

	init: function(){
		$.ajax({
			assync:false,
			url:'/cart.js',
			success:function(data){
				BCApp.Config.listCart = data.items;
			}
		})
	}
}
$(document).ready(function(e){
	BCApp.Main.init();
})