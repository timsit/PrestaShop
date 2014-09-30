{*
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
*}
<script type="text/javascript">
	var current_index = '{$current|escape:'html':'UTF-8'}&token={$token|escape:'html':'UTF-8'}';
	var token_admin_cart = '{getAdminToken tab='AdminCarts'}';
	var token_admin_cart_rules = '{getAdminToken tab='AdminCartRules'}';
	var cart_quantity = new Array();
	var currencies = new Array();
	var id_currency = '';
	var id_lang = '';
	//var txt_show_carts = '{l s='Show carts and orders for this customer.' js=1}';
	//var txt_hide_carts = '{l s='Hide carts and orders for this customer.' js=1}';
	var defaults_order_state = new Array();

	{foreach from=$defaults_order_state key='module' item='id_order_state'}
		defaults_order_state['{$module}'] = '{$id_order_state}';
	{/foreach}

</script>

<div class="leadin">{block name="leadin"}{/block}</div>
	<div class="panel form-horizontal" id="customer_part">
		<div class="panel-heading">
			<i class="icon-user"></i>
			{l s='Customer'}
		</div>
		<div id="search-customer-form-group" class="form-group">
			<label class="control-label col-lg-3">
				<span title="" data-toggle="tooltip" class="label-tooltip" data-original-title="{l s='Search for an existing customer by typing the first letters of his/her name.'}">
					{l s='Search for a customer'}
				</span>
			</label>
			<div class="col-lg-9">
				<div class="row">
					<div class="col-lg-6">
						<div class="input-group">
							<input type="text" id="customer" value="" />
							<span class="input-group-addon">
								<i class="icon-search"></i>
							</span>
						</div>
					</div>
					<div class="col-lg-6">
						<span class="form-control-static">{l s='Or'}&nbsp;</span>
						<a class="fancybox_customer btn btn-default" href="{$link->getAdminLink('AdminCustomers')|escape:'html':'UTF-8'}&amp;addcustomer&amp;liteDisplaying=1&amp;submitFormAjax=1#">
							<i class="icon-plus-sign-alt"></i>
							{l s='Add new customer'}
						</a>
					</div>
				</div>
			</div>
		</div>
		<div class="row">
			<div id="customers"></div>
		</div>
		<div id="carts">
			<button type="button" id="show_old_carts" class="btn btn-default pull-right" data-toggle="collapse" data-target="#old_carts_orders">
				<i class="icon-caret-down"></i>
			</button>

			<ul id="old_carts_orders_navtab" class="nav nav-tabs">
				<li class="active">
					<a href="#nonOrderedCarts" data-toggle="tab">
						<i class="icon-shopping-cart"></i>
						{l s='Carts'}
					</a>
				</li>
				<li>
					<a href="#lastOrders" data-toggle="tab">
						<i class="icon-credit-card"></i>
						{l s='Orders'}
					</a>
				</li>
			</ul>
			<div id="old_carts_orders" class="tab-content panel collapse in">
				<div id="nonOrderedCarts" class="tab-pane active">
					<table class="table">
						<thead>
							<tr>
								<th><span class="title_box">{l s='ID'}</span></th>
								<th><span class="title_box">{l s='Date'}</span></th>
								<th><span class="title_box">{l s='Total'}</span></th>
								<th></th>
							</tr>
						</thead>
						<tbody>
						</tbody>
					</table>
				</div>
				<div id="lastOrders" class="tab-pane">
					<table class="table">
						<thead>
							<tr>
								<th><span class="title_box">{l s='ID'}</span></th>
								<th><span class="title_box">{l s='Date'}</span></th>
								<th><span class="title_box">{l s='Products'}</span></th>
								<th><span class="title_box">{l s='Total paid'}</span></th>
								<th><span class="title_box">{l s='Payment'}</span></th>
								<th><span class="title_box">{l s='Status'}</span></th>
								<th></th>
							</tr>
						</thead>
						<tbody>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>


<form class="form-horizontal" action="{$link->getAdminLink('AdminOrders')|escape:'html':'UTF-8'}&amp;submitAdd{$table|escape:'html':'UTF-8'}=1" method="post" autocomplete="off">
	<div class="panel" id="products_part" style="display:none;">
		<div class="panel-heading">
			<i class="icon-shopping-cart"></i>
			{l s='Cart'}
		</div>
		<div class="form-group">
			<label class="control-label col-lg-3">
				<span title="" data-toggle="tooltip" class="label-tooltip" data-original-title="{l s='Search for an existing product by typing the first letters of its name.'}">
					{l s='Search for a product'}
				</span>
			</label>
			<div class="col-lg-9">
				<input type="hidden" value="" id="id_cart" name="id_cart" />
				<div class="input-group">
					<input type="text" id="product" value="" />
					<span class="input-group-addon">
						<i class="icon-search"></i>
					</span>
				</div>
			</div>
		</div>

		<div id="products_found">
			<hr/>
			<div id="product_list" class="form-group"></div>
			<div id="attributes_list" class="form-group"></div>
			<!-- @TODO: please be kind refacto -->
			<div class="form-group">
				<div class="col-lg-9 col-lg-offset-3">
					<iframe id="customization_list" seamless>
						<html>
						<head>
							{if isset($css_files_orders)}
								{foreach from=$css_files_orders key=css_uri item=media}
									<link href="{$css_uri}" rel="stylesheet" type="text/css" media="{$media}" />
								{/foreach}
							{/if}
						</head>
						<body>
						</body>
						</html>
					</iframe>
				</div>
			</div>
			<div class="form-group">
				<label class="control-label col-lg-3" for="qty">{l s='Quantity'}</label>
				<div class="col-lg-9">
					<input type="text" name="qty" id="qty" class="form-control fixed-width-sm" value="1" />
					<p class="help-block">{l s='In stock'} <span id="qty_in_stock"></span></p>
				</div>
			</div>

			<div class="form-group">
				<div class="col-lg-9 col-lg-offset-3">
					<button type="button" class="btn btn-default" id="submitAddProduct" />
					<i class="icon-ok text-success"></i>
					{l s='Add to cart'}
				</div>
			</div>
		</div>

		<div id="products_err" class="hide alert alert-danger"></div>

		<hr/>

		<div class="row">
			<div class="col-lg-12">
				<table class="table" id="customer_cart">
					<thead>
						<tr>
							<th><span class="title_box">{l s='Product'}</span></th>
							<th><span class="title_box">{l s='Description'}</span></th>
							<th><span class="title_box">{l s='Reference'}</span></th>
							<th><span class="title_box">{l s='Unit price'}</span></th>
							<th><span class="title_box">{l s='Quantity'}</span></th>
							<th><span class="title_box">{l s='Price'}</span></th>
						</tr>
					</thead>
					<tbody>
					</tbody>
				</table>
			</div>
		</div>

		<div class="form-group">
			<div class="col-lg-9 col-lg-offset-3">
				<div class="alert alert-warning">{l s='The prices are without taxes.'}</div>
			</div>
		</div>

		<div class="form-group">
			<label class="control-label col-lg-3" for="id_currency">
				{l s='Currency'}
			</label>
			<script type="text/javascript">
				{foreach from=$currencies item='currency'}
					currencies['{$currency.id_currency}'] = '{$currency.sign}';
				{/foreach}
			</script>
			<div class="col-lg-9">
				<select id="id_currency" name="id_currency">
					{foreach from=$currencies item='currency'}
						<option rel="{$currency.iso_code}" value="{$currency.id_currency}">{$currency.name}</option>
					{/foreach}
				</select>
			</div>
		</div>
		<div class="form-group">
			<label class="control-label col-lg-3" for="id_lang">
				{l s='Language'}
			</label>
			<div class="col-lg-9">
				<select id="id_lang" name="id_lang">
					{foreach from=$langs item='lang'}
						<option value="{$lang.id_lang}">{$lang.name}</option>
					{/foreach}
				</select>
			</div>
		</div>
	</div>

	<div class="panel" id="vouchers_part" style="display:none;">
		<div class="panel-heading">
			<i class="icon-ticket"></i>
			{l s='Vouchers'}
		</div>
		<div class="form-group">
			<label class="control-label col-lg-3">
				{l s='Search for a voucher'}
			</label>
			<div class="col-lg-9">
				<div class="row">
					<div class="col-lg-6">
						<div class="input-group">
							<input type="text" id="voucher" value="" />
							<div class="input-group-addon">
								<i class="icon-search"></i>
							</div>
						</div>
					</div>
					<div class="col-lg-6">
						<span class="form-control-static">{l s='Or'}&nbsp;</span>
						<a class="fancybox btn btn-default" href="{$link->getAdminLink('AdminCartRules')|escape:'html':'UTF-8'}&amp;addcart_rule&amp;liteDisplaying=1&amp;submitFormAjax=1#">
							<i class="icon-plus-sign-alt"></i>
							{l s='Add new voucher'}
						</a>
					</div>
				</div>
			</div>
		</div>
		<div class="row">
			<table class="table" id="voucher_list">
				<thead>
					<tr>
						<th><span class="title_box">{l s='Name'}</span></th>
						<th><span class="title_box">{l s='Description'}</span></th>
						<th><span class="title_box">{l s='Value'}</span></th>
						<th></th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
		</div>
		<div id="vouchers_err" class="alert alert-warning" style="display:none;"></div>
	</div>

	<div class="panel" id="address_part" style="display:none;">
		<div class="panel-heading">
			<i class="icon-envelope"></i>
			{l s='Addresses'}
		</div>
		<div id="addresses_err" class="alert alert-warning" style="display:none;"></div>

		<div class="row">
			<div id="address_delivery" class="col-lg-6">
				<h4>
					<i class="icon-truck"></i>
					{l s='Delivery'}
				</h4>
				<div class="row-margin-bottom">
					<select id="id_address_delivery" name="id_address_delivery"></select>
				</div>
				<div class="well">
					<a href="" id="edit_delivery_address" class="btn btn-default pull-right fancybox"><i class="icon-pencil"></i> {l s='Edit'}</a>
					<div id="address_delivery_detail"></div>
				</div>
			</div>
			<div id="address_invoice" class="col-lg-6">
				<h4>
					<i class="icon-file-text"></i>
					{l s='Invoice'}
				</h4>
				<div class="row-margin-bottom">
					<select id="id_address_invoice" name="id_address_invoice"></select>
				</div>
				<div class="well">
					<a href="" id="edit_invoice_address" class="btn btn-default pull-right fancybox"><i class="icon-pencil"></i> {l s='Edit'}</a>
					<div id="address_invoice_detail"></div>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-lg-12">
				<a class="fancybox btn btn-default" id="new_address" href="{$link->getAdminLink('AdminAddresses')|escape:'html':'UTF-8'}&amp;addaddress&amp;id_customer=42&amp;liteDisplaying=1&amp;submitFormAjax=1#">
					<i class="icon-plus-sign-alt"></i>
					{l s='Add a new address'}
				</a>
			</div>
		</div>
	</div>
	<div class="panel" id="carriers_part" style="display:none;">
		<div class="panel-heading">
			<i class="icon-truck"></i>
			{l s='Shipping'}
		</div>
		<div id="carriers_err" style="display:none;" class="alert alert-warning"></div>
		<div id="carrier_form">
			<div class="form-group">
				<label class="control-label col-lg-3">
					{l s='Delivery option'}
				</label>
				<div class="col-lg-9">
					<select name="delivery_option" id="delivery_option">
					</select>
				</div>
			</div>
			<div class="form-group">
				<label class="control-label col-lg-3" for="shipping_price">
					{l s='Shipping price'}
				</label>
				<div class="col-lg-9">
					<p id="shipping_price" class="form-control-static" name="shipping_price"></p>
				</div>
			</div>
			<div class="form-group">
				<label class="control-label col-lg-3" for="free_shipping">
					{l s='Free shipping'}
				</label>
				<div class="input-group col-lg-9 fixed-width-lg">
					<span class="switch prestashop-switch">
						<input type="radio" name="free_shipping" id="free_shipping" value="1">
						<label for="free_shipping" class="radioCheck">
							{l s='yes'}
						</label>
						<input type="radio" name="free_shipping" id="free_shipping_off" value="0" checked="checked">
						<label for="free_shipping_off" class="radioCheck">
							{l s='No'}
						</label>
						<a class="slide-button btn"></a>
					</span>
				</div>
			</div>

			{if $recyclable_pack}
			<div class="form-group">
				<div class="checkbox col-lg-9 col-offset-3">
					<label for="carrier_recycled_package">
						<input type="checkbox" name="carrier_recycled_package" value="1" id="carrier_recycled_package" />
						{l s='Recycled package'}
					</label>
				</div>
			</div>
			{/if}

			{if $gift_wrapping}
			<div class="form-group">
				<div class="checkbox col-lg-9 col-offset-3">
					<label for="order_gift">
						<input type="checkbox" name="order_gift" id="order_gift" value="1" />
						{l s='Gift'}
					</label>
				</div>
			</div>
			<div class="form-group">
				<label class="control-label col-lg-3" for="gift_message">{l s='Gift message'}</label>
				<div class="col-lg-9">
					<textarea id="gift_message" class="form-control" cols="40" rows="4"></textarea>
				</div>
			</div>
			{/if}
		</div>
	</div>
	<div class="panel" id="summary_part" style="display:none;">
		<div class="panel-heading">
			<i class="icon-align-justify"></i>
			{l s='Summary'}
		</div>

		<div id="send_email_feedback" class="hide alert"></div>

		<div id="cart_summary" class="panel row-margin-bottom text-center">
			<div class="row">
				<div class="col-lg-2">
					<div class="data-focus">
						<span>{l s='Total products'}</span><br/>
						<span id="total_products" class="size_l text-success"></span>
					</div>
				</div>
				<div class="col-lg-2">
					<div class="data-focus">
						<span>{l s='Total vouchers'}</span><br/>
						<span id="total_vouchers" class="size_l text-danger"></span>
					</div>
				</div>
				<div class="col-lg-2">
					<div class="data-focus">
						<span>{l s='Total shipping'}</span><br/>
						<span id="total_shipping" class="size_l"></span>
					</div>
				</div>
				<div class="col-lg-2">
					<div class="data-focus">
						<span>{l s='Total taxes'}</span><br/>
						<span id="total_taxes" class="size_l"></span>
					</div>
				</div>
				<div class="col-lg-2">
					<div class="data-focus">
						<span>{l s='Total without taxes'}</span><br/>
						<span id="total_without_taxes" class="size_l"></span>
					</div>
				</div>
				<div class="col-lg-2">
					<div class="data-focus data-focus-primary">
						<span>{l s='Total with taxes'}</span><br/>
						<span id="total_with_taxes" class="size_l"></span>
					</div>
				</div>
			</div>
		</div>

		<div class="row">
			<div class="order_message_right col-lg-12">
				<div class="form-group">
					<label class="control-label col-lg-3" for="order_message">{l s='Order message'}</label>
					<div class="col-lg-6">
						<textarea name="order_message" id="order_message" rows="3" cols="45"></textarea>
					</div>
				</div>
				<div class="form-group">
					{if !$PS_CATALOG_MODE}
					<div class="col-lg-9 col-lg-offset-3">
						<a href="javascript:void(0);" id="send_email_to_customer" class="btn btn-default">
							<i class="icon-credit-card"></i>
							{l s='Send an email to the customer with the link to process the payment.'}
						</a>
						<a target="_blank" id="go_order_process" href="" class="btn btn-link">
							{l s='Go on payment page to process the payment.'}
							<i class="icon-external-link"></i>
						</a>
					</div>
					{/if}
				</div>
				<div class="form-group">
					<label class="control-label col-lg-3">{l s='Payment'}</label>
					<div class="col-lg-9">
						<select name="payment_module_name" id="payment_module_name">
							{if !$PS_CATALOG_MODE}
							{foreach from=$payment_modules item='module'}
								<option value="{$module->name}" {if isset($smarty.post.payment_module_name) && $module->name == $smarty.post.payment_module_name}selected="selected"{/if}>{$module->displayName}</option>
							{/foreach}
							{else}
								<option value="boorder">{l s='Back-office order'}</option>
							{/if}
						</select>
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-lg-3">{l s='Order status'}</label>
					<div class="col-lg-9">
						<select name="id_order_state" id="id_order_state">
							{foreach from=$order_states item='order_state'}
								<option value="{$order_state.id_order_state}" {if isset($smarty.post.id_order_state) && $order_state.id_order_state == $smarty.post.id_order_state}selected="selected"{/if}>{$order_state.name}</option>
							{/foreach}
						</select>
					</div>
				</div>
				<div class="form-group">
					<div class="col-lg-9 col-lg-offset-3">
						<button type="submit" name="submitAddOrder" class="btn btn-default" />
							<i class="icon-check"></i>
							{l s='Create the order'}
						</button>
					</div>
				</div>
			</div>
		</div>
	</div>
</form>

<div id="loader_container">
	<div id="loader"></div>
</div>

{addJsDef id_cart = $cart->id|intval}
{addJsDef id_customer = 0}
{addJsDef id_currency = ''}
{addJsDef id_lang = ''}
{addJsDef customization_errors = false}
{addJsDef pic_dir = $pic_dir}
{addJsDef currency_format = 5}
{addJsDef currency_sign = ''}
{addJsDef currency_blank = false}
{addJsDef priceDisplayPrecision = $smarty.const._PS_PRICE_DISPLAY_PRECISION_|intval}
{addJsDef changed_shipping_price = false}
{addJsDef shipping_price_selected_carrier = ''}

{addJsDef admin_order_tab_link = $link->getAdminLink('AdminOrders')|addslashes}
{addJsDef admin_cart_link = $link->getAdminLink('AdminCarts')|addslashes}
{addJsDef admin_addresses_link = $link->getAdminLink('AdminAddresses')|addslashes}
{addJsDef admin_cart_rules_link = $link->getAdminLink('AdminCartRules')|addslashes}
{addJsDef token_admin_customers = $link->getAdminLink('AdminCustomers')}

{addJsDefL name=msg_add_one_address}{l s='You must add at least one address to process the order.' js=1}{/addJsDefL}
{addJsDefL name=msg_no_products_found}{l s='No products found' js=1}{/addJsDefL}
{addJsDefL name=msg_no_customers_found}{l s='No customers found' js=1}{/addJsDefL}
{addJsDefL name=msg_no_carrier_available}{l s='No carrier can be applied to this order' js=1}{/addJsDefL}
{addJsDefL name=msg_no_voucher_found}{l s='No voucher was found' js=1}{/addJsDefL}

{addJsDefL name=delete_txt}{l s='Delete' js=1}{/addJsDefL}
{addJsDefL name=gift_txt}{l s='Gift' js=1}{/addJsDefL}
{addJsDefL name=product_txt}{l s='Product' js=1}{/addJsDefL}
{addJsDefL name=combination_txt}{l s='Combination' js=1}{/addJsDefL}
{addJsDefL name=customization_txt}{l s='Customization' js=1}{/addJsDefL}
{addJsDefL name=view_cart_txt}{l s='View this cart' js=1}{/addJsDefL}
{addJsDefL name=use_txt}{l s="Use" js=1}{/addJsDefL}
{addJsDefL name=details_txt}{l s="Details" js=1}{/addJsDefL}
{addJsDefL name=duplicate_order_txt}{l s='Duplicate this order' js=1}{/addJsDefL}
{addJsDefL name=view_order_txt}{l s='View this order' js=1}{/addJsDefL}
{addJsDefL name=use_order_txt}{l s='Use this cart' js=1}{/addJsDefL}
{addJsDefL name=choose_txt}{l s='Choose' js=1}{/addJsDefL}
{addJsDefL name=change_txt}{l s='Change' js=1}{/addJsDefL}


