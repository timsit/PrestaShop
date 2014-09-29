/*
* 2007-2014 PrestaShop
*
* NOTICE OF LICENSE
*
* This source file is subject to the Academic Free License (AFL 3.0)
* that is bundled with this package in the file LICENSE.txt.
* It is also available through the world-wide-web at this URL:
* http://opensource.org/licenses/afl-3.0.php
* If you did not receive a copy of the license and are unable to
* obtain it through the world-wide-web, please send an email
* to license@prestashop.com so we can send you a copy immediately.
*
* DISCLAIMER
*
* Do not edit or add to this file if you wish to upgrade PrestaShop to newer
* versions in the future. If you wish to customize PrestaShop for your
* needs please refer to http://www.prestashop.com for more information.
*
*  @author PrestaShop SA <contact@prestashop.com>
*  @copyright  2007-2014 PrestaShop SA
*  @license    http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*  International Registered Trademark & Property of PrestaShop SA
*/

function updateCartVouchers(vouchers)
{
	var vouchers_html = '';
	if (typeof(vouchers) == 'object')
		$.each(vouchers, function(){
			vouchers_html += '<tr><td>'+this.name+'</td><td>'+this.description+'</td><td>'+this.value_real+'</td><td class="text-right"><a href="#" class="btn btn-default delete_discount" rel="'+this.id_discount+'"><i class="icon-remove text-danger"></i>&nbsp;'+msg_delete_btn_label+'</a></td></tr>';
		});
	$('#voucher_list tbody').html($.trim(vouchers_html));
	if ($('#voucher_list tbody').html().length == 0)
		$('#voucher_list').hide();
	else
		$('#voucher_list').show();
}

function updateCartPaymentList(payment_list)
{
	$('#payment_list').html(payment_list);
}

function fixPriceFormat(price)
{
	if(price.indexOf(',') > 0 && price.indexOf('.') > 0) // if contains , and .
		if(price.indexOf(',') < price.indexOf('.')) // if , is before .
			price = price.replace(',','');  // remove ,
	price = price.replace(' ',''); // remove any spaces
	price = price.replace(',','.'); // remove , if price did not cotain both , and .
	return price;
}

function displaySummary(jsonSummary)
{
	currency_format = jsonSummary.currency.format;
	currency_sign = jsonSummary.currency.sign;
	currency_blank = jsonSummary.currency.blank;
	priceDisplayPrecision = jsonSummary.currency.decimals ? 2 : 0;

	updateCartProducts(jsonSummary.summary.products, jsonSummary.summary.gift_products, jsonSummary.cart.id_address_delivery);
	updateCartVouchers(jsonSummary.summary.discounts);
	updateAddressesList(jsonSummary.addresses, jsonSummary.cart.id_address_delivery, jsonSummary.cart.id_address_invoice);

	if (!jsonSummary.summary.products.length || !jsonSummary.addresses.length || !jsonSummary.delivery_option_list)
		$('#carriers_part,#summary_part').hide();
	else
		$('#carriers_part,#summary_part').show();

	updateDeliveryOptionList(jsonSummary.delivery_option_list);

	if (jsonSummary.cart.gift == 1)
		$('#order_gift').attr('checked', true);
	else
		$('#carrier_gift').removeAttr('checked');
	if (jsonSummary.cart.recyclable == 1)
		$('#carrier_recycled_package').attr('checked', true);
	else
		$('#carrier_recycled_package').removeAttr('checked');
	if (jsonSummary.free_shipping == 1)
		$('#free_shipping').attr('checked', true);
	else
		$('#free_shipping_off').attr('checked', true);

	$('#gift_message').html(jsonSummary.cart.gift_message);
	if (!changed_shipping_price)
		$('#shipping_price').html('<b>' + formatCurrency(parseFloat(jsonSummary.summary.total_shipping), currency_format, currency_sign, currency_blank) + '</b>');
	shipping_price_selected_carrier = jsonSummary.summary.total_shipping;

	$('#total_vouchers').html(formatCurrency(parseFloat(jsonSummary.summary.total_discounts_tax_exc), currency_format, currency_sign, currency_blank));
	$('#total_shipping').html(formatCurrency(parseFloat(jsonSummary.summary.total_shipping_tax_exc), currency_format, currency_sign, currency_blank));
	$('#total_taxes').html(formatCurrency(parseFloat(jsonSummary.summary.total_tax), currency_format, currency_sign, currency_blank));
	$('#total_without_taxes').html(formatCurrency(parseFloat(jsonSummary.summary.total_price_without_tax), currency_format, currency_sign, currency_blank));
	$('#total_with_taxes').html(formatCurrency(parseFloat(jsonSummary.summary.total_price), currency_format, currency_sign, currency_blank));
	$('#total_products').html(formatCurrency(parseFloat(jsonSummary.summary.total_products), currency_format, currency_sign, currency_blank));
	id_currency = jsonSummary.cart.id_currency;
	$('#id_currency option').removeAttr('selected');
	$('#id_currency option[value="'+id_currency+'"]').attr('selected', true);
	id_lang = jsonSummary.cart.id_lang;
	$('#id_lang option').removeAttr('selected');
	$('#id_lang option[value="'+id_lang+'"]').attr('selected', true);
	$('#send_email_to_customer').attr('rel', jsonSummary.link_order);
	$('#go_order_process').attr('href', jsonSummary.link_order);
	$('#order_message').val(jsonSummary.order_message);
	resetBind();
}

function updateQty(id_product, id_product_attribute, id_customization, qty)
{
	$.ajax({
		type:"POST",
		url: admin_cart_link,
		async: true,
		dataType: "json",
		data : {
			ajax: "1",
			token: token_admin_cart,
			tab: "AdminCarts",
			action: "updateQty",
			id_product: id_product,
			id_product_attribute: id_product_attribute,
			id_customization: id_customization,
			qty: qty,
			id_customer: id_customer,
			id_cart: id_cart,
		},
		success : function(res)
		{
			displaySummary(res);
			var errors = '';
			if (res.errors.length)
			{
				$.each(res.errors, function() {
					errors += this + '<br />';
				});
				$('#products_err').removeClass('hide');
			}
			else
				$('#products_err').addClass('hide');
			$('#products_err').html(errors);
		}
	});
}

function resetShippingPrice()
{
	$('#shipping_price').val(shipping_price_selected_carrier);
	changed_shipping_price = false;
}

function addProduct()
{
	var id_product = $('#id_product option:selected').val();
	$('#products_found #customization_list').contents().find('#customization_'+id_product).submit();
	if (customization_errors)
		$('#products_err').removeClass('hide');
	else
	{
		$('#products_err').addClass('hide');
		updateQty(id_product, $('#ipa_'+id_product+' option:selected').val(), 0, $('#qty').val());
	}
}

function updateCurrency()
{
	$.ajax({
		type:"POST",
		url: admin_cart_link,
		async: true,
		dataType: "json",
		data : {
			ajax: "1",
			token: token_admin_cart,
			tab: "AdminCarts",
			action: "updateCurrency",
			id_currency: $('#id_currency option:selected').val(),
			id_customer: id_customer,
			id_cart: id_cart
			},
		success : function(res)
		{
				displaySummary(res);
		}
	});
}

function updateLang()
{
	$.ajax({
		type:"POST",
		url: admin_cart_link,
		async: true,
		dataType: "json",
		data : {
			ajax: "1",
			token: token_admin_cart,
			tab: "admincarts",
			action: "updateLang",
			id_lang: $('#id_lang option:selected').val(),
			id_customer: id_customer,
			id_cart: id_cart
			},
		success : function(res)
		{
				displaySummary(res);
		}
	});
}

function updateDeliveryOption()
{
	$.ajax({
		type:"POST",
		url: admin_cart_link,
		async: true,
		dataType: "json",
		data : {
			ajax: "1",
			token: token_admin_cart,
			tab: "AdminCarts",
			action: "updateDeliveryOption",
			delivery_option: $('#delivery_option option:selected').val(),
			gift: $('#order_gift').is(':checked')?1:0,
			gift_message: $('#gift_message').val(),
			recyclable: $('#carrier_recycled_package').is(':checked')?1:0,
			id_customer: id_customer,
			id_cart: id_cart
			},
		success : function(res)
		{
			displaySummary(res);
		}
	});
}

function sendMailToCustomer()
{
	$.ajax({
		type:"POST",
		url: admin_orders_link,
		async: true,
		dataType: "json",
		data : {
			ajax: "1",
			token: "{getAdminToken tab='AdminOrders'}",
			tab: "AdminOrders",
			action: "sendMailValidateOrder",
			id_customer: id_customer,
			id_cart: id_cart
			},
		success : function(res)
		{
			if (res.errors)
				$('#send_email_feedback').removeClass('hide').removeClass('alert-success').addClass('alert-danger');
			else
				$('#send_email_feedback').removeClass('hide').removeClass('alert-danger').addClass('alert-success');
			$('#send_email_feedback').html(res.result);
		}
	});
}

function updateAddressesList(addresses, id_address_delivery, id_address_invoice)
{
	var addresses_delivery_options = '';
	var addresses_invoice_options = '';
	var address_invoice_detail = '';
	var address_delivery_detail = '';
	var delivery_address_edit_link = '';
	var invoice_address_edit_link = '';

	$.each(addresses, function() {
		if (this.id_address == id_address_invoice)
		{
			address_invoice_detail = this.formated_address;
			invoice_address_edit_link = admin_addresses_link+"&id_address="+this.id_address+"&updateaddress&realedit=1&liteDisplaying=1&submitFormAjax=1#";
		}

		if(this.id_address == id_address_delivery)
		{
			address_delivery_detail = this.formated_address;
			delivery_address_edit_link = admin_addresses_link+"&id_address="+this.id_address+"&updateaddress&realedit=1&liteDisplaying=1&submitFormAjax=1#";
		}

		addresses_delivery_options += '<option value="'+this.id_address+'" '+(this.id_address == id_address_delivery ? 'selected="selected"' : '')+'>'+this.alias+'</option>';
		addresses_invoice_options += '<option value="'+this.id_address+'" '+(this.id_address == id_address_invoice ? 'selected="selected"' : '')+'>'+this.alias+'</option>';
	});

	if (addresses.length == 0)
	{
		$('#addresses_err').show().html(msg_add_one_address);
		$('#address_delivery, #address_invoice').hide();
	}
	else
	{
		$('#addresses_err').hide();
		$('#address_delivery, #address_invoice').show();
	}

	$('#id_address_delivery').html(addresses_delivery_options);
	$('#id_address_invoice').html(addresses_invoice_options);
	$('#address_delivery_detail').html(address_delivery_detail);
	$('#address_invoice_detail').html(address_invoice_detail);
	$('#edit_delivery_address').attr('href', delivery_address_edit_link);
	$('#edit_invoice_address').attr('href', invoice_address_edit_link);
}

function updateAddresses()
{
	$.ajax({
		type:"POST",
		url: admin_cart_link,
		async: true,
		dataType: "json",
		data : {
			ajax: "1",
			token: token_admin_cart,
			tab: "AdminCarts",
			action: "updateAddresses",
			id_customer: id_customer,
			id_cart: id_cart,
			id_address_delivery: $('#id_address_delivery option:selected').val(),
			id_address_invoice: $('#id_address_invoice option:selected').val()
			},
		success : function(res)
		{
			updateDeliveryOption();
		}
	});
}
