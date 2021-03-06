{*<!--
/*********************************************************************************
  ** The contents of this file are subject to the vtiger CRM Public License Version 1.0
   * ("License"); You may not use this file except in compliance with the License
   * The Original Code is:  vtiger CRM Open Source
   * The Initial Developer of the Original Code is vtiger.
   * Portions created by vtiger are Copyright (C) vtiger.
   * All Rights Reserved.
  *
 ********************************************************************************/
-->*}



<style>
ul.nav.modulesList > li > ul {
  display:none;
}

ul.nav.modulesList > li:hover > ul {
  display:block;
}
.navbar .nav > li > a.OSSMenuBlock, .dropdown-menu li a:hover{
color: #ffffff !important;
}
.navbar .nav > li > a.OSSMenuBlock{
font-weight: 800;
}
</style>

{strip}
	{assign var="topMenus" value=$MENU_STRUCTURE['structure']}
	{assign var="icons" value=$MENU_STRUCTURE['icons']}
{*{var_dump($topMenus)} {exit;}*}
    <div class="navbar" id="topMenus">
		<div class="navbar-inner" id="nav-inner">
			<div class="menuBar row-fluid">
				<div class="span8">
					<ul class="nav modulesList">
						<li class="tabs">
							<a class="alignMiddle {if $MODULE eq 'Home'} selected {/if}" href="{$HOME_MODULE_MODEL->getDefaultUrl()}"><img src="{vimage_path('home.png')}" alt="{vtranslate('LBL_HOME',$moduleName)}" title="{vtranslate('LBL_HOME',$moduleName)}" /></a>
						</li>
							{foreach key=moduleName item=moduleModel from=$topMenus}
							
							<li class="dropdown" id="{$moduleName}">
								<a class="dropdown-toggle OSSMenuBlock" data-toggle="dropdown" href="{$moduleName}"> 
	
                                {if !empty($icons[$moduleName]['picon'])}
                                <img style="max-width:{$icons[$moduleName]['iconf']}px; vertical-align: middle; max-height:{$icons[$moduleName]['icons']}px" src="{$icons[$moduleName]['picon']}" alt=""/>&nbsp;
                                {/if}
							{vtranslate($moduleName, 'OSSMenuManager')}
							</a>
                            {if count($moduleModel) gt 0}
							<ul class="dropdown-menu userName" style="max-height:700px; margin-top:0px;" >
							{foreach from=$moduleModel item=module}
                                {if $module.link|strpos:'*etykieta*' === 0}
                                    {$module.link=$module.link|replace:'*etykieta*':''}
                                    <li>
                                        {if strlen($module.link) gt 0}
                                            {if $module.link|strpos:'*_blank*' === 0}
				                                <a class="menuLinkClass etykietaUrl moduleColor_{$module.mod}" {if $module.color}style="color: #{$module.color}!important;"{/if} href="{$module.link}" target="_blank">
                                                {if !empty($module.locationiconname)}
                                                <img style="max-width: {$module.sizeicon_first}px; max-height:{$module.sizeicon_second}px; vertical-align: middle" src="{$module.locationiconname}" alt="{$module.locationiconname}"/>&nbsp;									
												{/if}
                                                {vtranslate($module.name, $module.name)}</a>
                                            {else}
		                                        <a class="menuLinkClass etykietaUrl moduleColor_{$module.mod}" {if $module.color}style="color: #{$module.color}!important;"{/if} href="{$module.link}">
                                                {if !empty($module.locationiconname)}
                                                <img style="max-width: {$module.sizeicon_first}px; max-height:{$module.sizeicon_second}px; vertical-align: middle" src="{$module.locationiconname}" alt="{$module.locationiconname}"/>&nbsp;											
												{/if}
                                                {vtranslate($module.name, $module.name)}</a>
                                            {/if}
                                        {else}
	                                            <a class="menuLinkClass etykietaUrl moduleColor_{$module.mod}" {if $module.color}style="color: #{$module.color}!important;"{/if}>
                                                {if !empty($module.locationiconname)}
                                                <img style="max-width: {$module.sizeicon_first}px; max-height:{$module.sizeicon_second}px; vertical-align: middle" src="{$module.locationiconname}" alt="{$module.locationiconname}"/>&nbsp;											
												{/if}
                                                {vtranslate($module.name, $module.name)}</a>
                                        {/if}
                                    </li>
                                {else if $module.link eq '*separator*'}
									<li class="divider"></li>
                                {else if $module.link|strpos:"javascript:" === 0 || $module.link|strpos:"jQuery" === 0}
                                <li>
								<a class="menuLinkClass moduleColor_{$module.mod}" {if $module.color}style="color: #{$module.color}!important;"{/if} href="#" onclick="{$module.link} return false;">
									{if !empty($module.locationiconname)}
                                        <img style="max-width: {$module.sizeicon_first}px; max-height:{$module.sizeicon_second}px; vertical-align: middle" src="{$module.locationiconname}" alt="{$module.locationiconname}"/>&nbsp;							
                                    {/if}
                                {vtranslate($module.name, $module.name)}</a></li>
                                {else}
                                    {if $module.link|strpos:"*_blank*" === 0}
                                        {$module.link=$module.link|replace:'*_blank*':''}	
								<li><a class="menuLinkClass moduleColor_{$module.mod}" {if $module.color}style="color: #{$module.color}!important;"{/if} href="{$module.link}" target="_blank">
									{if !empty($module.locationiconname)}
                                        <img style="max-width: {$module.sizeicon_first}px; max-height:{$module.sizeicon_second}px; vertical-align: middle" src="{$module.locationiconname}" alt="{$module.locationiconname}"/>&nbsp;							
                                    {/if}
                                {vtranslate($module.name, $module.name)}</a></li>
                                    {else if $module.link|strpos:"index" === 0 || $module.link|strpos:"http://" === 0 || $module.link|strpos:"https://" === 0 || $module.link|strpos:"www" === 0}
								
								<li><a class="menuLinkClass moduleColor_{$module.mod}" {if $module.color}style="color: #{$module.color}!important;"{/if} href="{$module.link}">
                                    {if !empty($module.locationiconname)}
                                        <img style="max-width: {$module.sizeicon_first}px; max-height:{$module.sizeicon_second}px; vertical-align: middle" src="{$module.locationiconname}" alt="{$module.locationiconname}"/>
                                  	{/if}
                                    &nbsp;{vtranslate($module.name, $module.name)}</a></li>
								   {/if}
                                {/if}
							{/foreach}
							</ul>
                            {/if}
							</li>
						{/foreach}
					</ul>
				</div>
				<div class="span4 row-fluid" id="headerLinks">
					<span id="headerLinksBig" class="pull-right headerLinksContainer">
						{if $PAINTEDICON eq 1}
							<span class="dropdown span settingIcons">
								<a class="dropdown-toggle" data-toggle="dropdown" href="#">
									<img src="{vimage_path('theme_brush.png')}" alt="theme roller" title="Theme Roller" />
								</a>
								<ul class="dropdown-menu themeMenuContainer">
									<div id="themeContainer">
										{assign var=COUNTER value=0}
										{assign var=THEMES_LIST value=Vtiger_Theme::getAllSkins()}
										<div class="row-fluid themeMenu">
										{foreach key=SKIN_NAME item=SKIN_COLOR from=$THEMES_LIST}
											{if $COUNTER eq 3}
												</div>
												<div class="row-fluid themeMenu">
												{assign var=COUNTER value=1}
											{else}
												{assign var=COUNTER value=$COUNTER+1}
											{/if}
											<div class="span4 themeElement {if $USER_MODEL->get('theme') eq $SKIN_NAME}themeSelected{/if}" data-skin-name="{$SKIN_NAME}" title="{ucfirst($SKIN_NAME)}" style="background-color:{$SKIN_COLOR};"></div>
										{/foreach}
										</div>
									</div>
									<div id="progressDiv"></div>
								</ul>
							</span>
						{/if}
						{foreach key=index item=obj from=$HEADER_LINKS}
							{assign var="src" value=$obj->getIconPath()}
							{assign var="icon" value=$obj->getIcon()}
							{assign var="title" value=$obj->getLabel()}
							{assign var="childLinks" value=$obj->getChildLinks()}
							<span class="dropdown span{if !empty($src)} settingIcons {/if}">
								{if !empty($src)}
									<a id="menubar_item_right_{$title}" class="dropdown-toggle" data-toggle="dropdown" href="#"><img src="{$src}" alt="{vtranslate($title,$MODULE)}" title="{vtranslate($title,$MODULE)}" /></a>
									{else}
										{assign var=title value=$USER_MODEL->get('first_name')}
										{if empty($title)}
											{assign var=title value=$USER_MODEL->get('last_name')}
										{/if}
									<span class="dropdown-toggle" data-toggle="dropdown" href="#">
                                        <a id="menubar_item_right_{$title}"  class="userName textOverflowEllipsis" title="{$title}"><strong>{$title}</strong>&nbsp;<i class="caret"></i> </a> </span>
									{/if}
									{if !empty($childLinks)}
									<ul class="dropdown-menu pull-right">
										{foreach key=index item=obj from=$childLinks}
											{if $obj->getLabel() eq NULL}
												<li class="divider">&nbsp;</li>
												{else}
													{assign var="id" value=$obj->getId()}
													{assign var="href" value=$obj->getUrl()}
													{assign var="label" value=$obj->getLabel()}
													{assign var="onclick" value=""}
													{if stripos($obj->getUrl(), 'javascript:') === 0}
														{assign var="onclick" value="onclick="|cat:$href}
														{assign var="href" value="javascript:;"}
													{/if}
												<li>
														<a target="{$obj->target}" id="menubar_item_right_{Vtiger_Util_Helper::replaceSpaceWithUnderScores($label)}" {if $label=='Switch to old look'}switchLook{/if} href="{$href}" {$onclick}>{vtranslate($label,$MODULE)}</a>
												</li>
											{/if}
										{/foreach}
									</ul>
								{/if}
							</span>
						{/foreach}
					</span>
					{if $CHAT_ACTIVE eq true}
						<span class="pull-right headerLinksContainer headerLinksAJAXChat">
							<span class="span">
								<a class="ChatIcon" href="#"><img src="layouts/vlayout/skins/images/chat.png" alt="chat_icon"/></a>
							</span>
						</span>
					{/if}
					<span class="pull-right headerLinksContainer" style="color: #ffffff;">
						<span class="span">
							{$WORKTIME}
						</span>
					</span>
					<span class="pull-right headerLinksContainer headerLinksMails" id="OSSMailBoxInfo">
						<span class="span">
							<a href="index.php?module=OSSMail&view=index"><span class="InfoBox"><img src="layouts/vlayout/skins/images/mailNotification.png"/></span></a>
						</span>
					</span>
					<div id="headerLinksCompact">
						<span class="btn-group dropdown qCreate cursorPointer">
							<img src="{vimage_path('btnAdd_white.png')}" class="" alt="{vtranslate('LBL_QUICK_CREATE',$MODULE)}" title="{vtranslate('LBL_QUICK_CREATE',$MODULE)}" data-toggle="dropdown"/>
							<ul class="dropdown-menu dropdownStyles pull-right commonActionsButtonDropDown">
								<li class="title"><strong>{vtranslate('Quick Create',$MODULE)}</strong></li><hr/>
								<li id="compactquickCreate">
									<div class="CompactQC">
										{foreach key=moduleName item=moduleModel from=$MENUS}
											{if $moduleModel->isPermitted('EditView')}
												{assign var='quickCreateModule' value=$moduleModel->isQuickCreateSupported()}
												{assign var='singularLabel' value=$moduleModel->getSingularLabelKey()}
												{if $quickCreateModule == '1'}
													<a class="quickCreateModule" data-name="{$moduleModel->getName()}"
													   data-url="{$moduleModel->getQuickCreateUrl()}" href="javascript:void(0)">{vtranslate($singularLabel,$moduleName)}</a>
												{/if}
											{/if}
										{/foreach}
									</div>
								</li>
							</ul>
						</span>
						<span  class="dropdown">
							<a class="dropdown-toggle btn-navbar" data-toggle="dropdown" href="#">
								<span class="icon-bar"></span>
								<span class="icon-bar"></span>
								<span class="icon-bar"></span>
							</a>
							<ul class="dropdown-menu pull-right">
								{foreach key=index item=obj from=$HEADER_LINKS name="compactIndex"}
									{assign var="src" value=$obj->getIconPath()}
									{assign var="icon" value=$obj->getIcon()}
									{assign var="title" value=$obj->getLabel()}
									{assign var="childLinks" value=$obj->getChildLinks()}
									{if $smarty.foreach.compactIndex.index neq 0}
										<li class="divider">&nbsp;</li>
										{/if}
										{foreach key=index item=obj from=$childLinks}
											{assign var="id" value=$obj->getId()}
											{assign var="href" value=$obj->getUrl()}
											{assign var="label" value=$obj->getLabel()}
											{assign var="onclick" value=""}
											{if stripos($obj->getUrl(), 'javascript:') === 0}
												{assign var="onclick" value="onclick="|cat:$href}
												{assign var="href" value="javascript:;"}
											{/if}
										<li>
											<a target="{$obj->target}" id="menubar_item_right_{Vtiger_Util_Helper::replaceSpaceWithUnderScores($label)}" {if $label=='Switch to old look'}switchLook{/if} href="{$href}" {$onclick}>{vtranslate($label,$MODULE)}</a>
										</li>

									{/foreach}

								{/foreach}
							</ul>
						</span>
					</div>
				</div>
			</div>
			<div class="clearfix"></div>
		</div>
	</div>
	{assign var="announcement" value=$ANNOUNCEMENT->get('announcement')}
	<div class="announcement" id="announcement">
		<marquee direction="left" scrolldelay="10" scrollamount="3" behavior="scroll" class="marStyle" onmouseover="javascript:stop();" onmouseout="javascript:start();">{if isset($announcement)}{$announcement}{else}{vtranslate('LBL_NO_ANNOUNCEMENTS',$MODULE)}{/if}</marquee>
	</div>
	<input type='hidden' value="{$MODULE}" id='module' name='module'/>
	<input type="hidden" value="{$PARENT_MODULE}" id="parent" name='parent' />
        <input type='hidden' value="{$VIEW}" id='view' name='view'/>
    {literal}
    <script>
        jQuery( function() {
			jQuery( ".OSSMenuBlock" ).hover(
				function() {
					jQuery(this).dropdown('toggle');
				}, function() {
					jQuery(this).dropdown('toggle');
				}
			);
        });
    </script>
    {/literal}
{/strip}