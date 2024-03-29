<!DOCTYPE html>

{block name="layout_vars"}{/block}

<!--[if lt IE 7]>
<html class="no-js ie6 oldie" lang="{Config::Get('i18n.lang')}" dir="{Config::Get('i18n.dir')}"> <![endif]-->
<!--[if IE 7]>
<html class="no-js ie7 oldie" lang="{Config::Get('i18n.lang')}" dir="{Config::Get('i18n.dir')}"> <![endif]-->
<!--[if IE 8]>
<html class="no-js ie8 oldie" lang="{Config::Get('i18n.lang')}" dir="{Config::Get('i18n.dir')}"> <![endif]-->
<!--[if gt IE 8]><!-->
<html class="no-js" lang="{Config::Get('i18n.lang')}" dir="{Config::Get('i18n.dir')}"> <!--<![endif]-->

<head>
    {hook run='html_head_begin'}

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>{$sHtmlTitle}</title>

    <meta name="description" content="{$sHtmlDescription}">
    <meta name="keywords" content="{$sHtmlKeywords}">

    {if $oTopic}
        <meta property="og:title" content="{$oTopic->getTitle()|escape:'html'}"/>
        <meta property="og:url" content="{$oTopic->getUrl()}"/>
        {if $oTopic->getPreviewImageUrl()}
            <meta property="og:image" content="{$oTopic->getPreviewImageUrl('700crop')}"/>
        {/if}
        <meta property="og:description" content="{$sHtmlDescription}"/>
        <meta property="og:site_name" content="{Config::Get('view.name')}"/>
        <meta property="og:type" content="article"/>
        <meta name="twitter:card" content="summary">
    {/if}

    {$aHtmlHeadFiles.css}

    <link href='http://fonts.googleapis.com/css?family=Open+Sans:400,300,600,700,800&subset=latin,cyrillic'
          rel='stylesheet' type='text/css'>

    <link href="{Config::Get('path.static.skin')}assets/images/favicon.ico?v1" rel="shortcut icon"/>
    <link rel="search" type="application/opensearchdescription+xml" href="{router page='search'}opensearch/"
          title="{Config::Get('view.name')}"/>

    {if $aHtmlRssAlternate}
        <link rel="alternate" type="application/rss+xml" href="{$aHtmlRssAlternate.url}"
              title="{$aHtmlRssAlternate.title}">
    {/if}

    {if $sHtmlCanonical}
        <link rel="canonical" href="{$sHtmlCanonical}"/>
    {/if}

    {if $bRefreshToHome}
        <meta HTTP-EQUIV="Refresh" CONTENT="3; URL={Config::Get('path.root.url')}/">
    {/if}

    <script type="text/javascript">
        var DIR_WEB_ROOT        = '{Config::Get('path.root.url')}';
        var DIR_STATIC_SKIN     = '{Config::Get('path.static.skin')}';
        var DIR_ROOT_ENGINE_LIB = '{Config::Get('path.root.engine_lib')}';
        var ALTO_SECURITY_KEY   = '{$ALTO_SECURITY_KEY}';
        var SESSION_ID          = '{$_sPhpSessionId}';


        var TINYMCE_LANG = {if Config::Get('lang.current') == 'ru'}'ru'{else}'en'{/if};

        var aRouter = [];
        {foreach from=$aRouter key=sPage item=sPath}
        aRouter['{$sPage}'] = '{$sPath}';
        {/foreach}

        var tinymce = false;
    </script>

    {$aHtmlHeadFiles.js}

    <script type="text/javascript">
        ls.cfg.wysiwyg = '{Config::Get('view.wysiwyg')}' ? true : false;
        ls.lang.load({json var = $aLangJs});
        ls.registry.set('comment_max_tree', {json var=Config::Get('module.comment.max_tree')});
        ls.registry.set('block_stream_show_tip', {json var=Config::Get('block.stream.show_tip')});
    </script>

    <!--[if lt IE 9]>
    <script src="{Config::Get('path.static.skin')}assets/js/html5shiv.js"></script>
    <script src="{Config::Get('path.static.skin')}assets/js/respond.min.js"></script>
    <![endif]-->

    <!--[if IE 7]>
    <link rel="stylesheet" href="{Config::Get('path.static.skin')}assets/icons/css/fontello-ie7.css">
    <![endif]-->
    <script>
        function toggleCodes(on) {
            var obj = document.getElementById('icons');
            if (on) {
                obj.className += ' codesOn';
            } else {
                obj.className = obj.className.replace(' codesOn', '');
            }
        }
    </script>

    {if Config::Get('view.header.top')=='fixed'}
        {$body_classes=$body_classes|cat:' i-fixed_navbar'}
    {/if}

    {if E::IsUser()}
        {$body_classes=$body_classes|cat:' ls-user-role-user'}

        {if E::IsAdmin()}
            {$body_classes=$body_classes|cat:' ls-user-role-admin'}
        {/if}
    {else}
        {$body_classes=$body_classes|cat:' ls-user-role-guest'}
    {/if}

    {if !E::IsAdmin()}
        {$body_classes=$body_classes|cat:' ls-user-role-not-admin'}
    {/if}

    {hook run='html_head_end'}
</head>
<body class="{$body_classes}">
{hook run='body_begin'}

{if E::IsUser()}
    {include file='modals/modal.write.tpl'}
    {include file='modals/modal.favourite_tags.tpl'}
{else}
    {include file='modals/modal.auth.tpl'}
{/if}
{include file='modals/modal.empty.tpl'}

{include file='header_top.tpl'}

	{* Banner *}
		{if Config::Get('view.header.banner')}
			{include file='header_banner.tpl'}
		{/if}

	{* Slider *}	
		{if Config::Get('view.header.slider')}
			{include file='header_slider.tpl'}
		{/if}

	{* Site name *}	
		{if Config::Get('view.header.site_name')}
			{include file='header_site_name.tpl'}
		{/if}

{include file='header_nav.tpl'}

<section id="container" class="{hook run='container_class'}">
    <div id="wrapper" class="container {hook run='wrapper_class'}">
        <div class="row">

            {if !$noSidebar AND $sidebarPosition == 'left'}
                {include file='sidebar.tpl'}
            {/if}

            <div id="content" role="main" class="{if $noSidebar}col-md-12 col-lg-12{else}col-md-8 col-lg-8{/if} content{if $sidebarPosition == 'left'} content-right{/if}"
                 {if $sMenuItemSelect=='profile'}itemscope itemtype="http://data-vocabulary.org/Person"{/if}>

                <div class="content-inner action-{$sAction}{if $sEvent} event-{$sEvent}{/if}{if $aParams[0]} params-{$aParams[0]}{/if}">
                    {include file='nav_content.tpl'}
                    {include file='system_message.tpl'}

                    {block name="layout_content"}
                    {hook run='content_begin'}

                    {hook run='content_end'}
                    {/block}
                </div>
                <!-- /content-inner -->
            </div>
            <!-- /content -->

            {if !$noSidebar AND $sidebarPosition != 'left'}
                {include file='sidebar.tpl'}
            {/if}

        </div>
        <!-- /row -->
    </div>
    <!-- /wrapper -->
</section>
<!-- /container -->

<footer id="footer">
    <div class="container">
        <div class="row">

            <div class="col-sm-4 col-md-4 col-lg-3">
                {if E::IsUser()}
                    <ul class="list-unstyled footer-list">
                        <li class="footer-list-header word-wrap">{E::User()->getDisplayName()}</li>
                        <li><a href="{E::User()->getProfileUrl()}">{$aLang.footer_menu_user_profile}</a></li>
                        <li><a href="{router page='settings'}profile/">{$aLang.user_settings}</a></li>
                        <li><a href="{router page='topic'}add/" class="js-write-window-show">{$aLang.block_create}</a>
                        </li>
                        {hook run='footer_menu_user_item' oUser=$oUserCurrent}
                        <li><a href="{router page='login'}exit/?security_key={$ALTO_SECURITY_KEY}">{$aLang.exit}</a>
                        </li>
                    </ul>
                {else}
                    <ul class="list-unstyled footer-list">
                        <li class="footer-list-header word-wrap">{$aLang.footer_menu_user_quest_title}</li>
                        <li><a class="js-modal-auth-registration" href="{router page='registration'}">{$aLang.registration_submit}</a></li>
                        <li><a class="js-modal-auth-login" href="{router page='login'}">{$aLang.user_login_submit}</a></li>
                        {hook run='footer_menu_user_item' isGuest=true}
                    </ul>
                {/if}
            </div>

            <div class="col-sm-4 col-md-4 col-lg-3">
                <ul class="list-unstyled footer-list">
                    <li class="footer-list-header">{$aLang.footer_menu_navigate_title}</li>
                    <li><a href="{Config::Get('path.root.url')}">{$aLang.topic_title}</a></li>
                    <li><a href="{router page='blogs'}">{$aLang.blogs}</a></li>
                    <li><a href="{router page='people'}">{$aLang.people}</a></li>
                    <li><a href="{router page='stream'}">{$aLang.stream_menu}</a></li>
                    {hook run='footer_menu_navigate_item'}
                </ul>
            </div>

            <div class="col-sm-4 col-md-4 col-lg-3">
                <ul class="list-unstyled footer-list">
                    <li class="footer-list-header">{$aLang.footer_menu_navigate_info}</li>
                    <li><a href="#">{$aLang.footer_menu_project_about}</a></li>
                    <li><a href="#">{$aLang.footer_menu_project_rules}</a></li>
                    <li><a href="#">{$aLang.footer_menu_project_advert}</a></li>
                    <li><a href="#">{$aLang.footer_menu_project_help}</a></li>
                    {hook run='footer_menu_project_item'}
                </ul>
            </div>          

        </div>
        {hook run='footer_end'}
    </div>

    <div class="footer-bottom">
        <div class="container">
            <div class="row">
                <div class="col-sm-6 col-md-6 col-lg-6">
                    {hook run='copyright'}
                </div>

                <div class="col-sm-6 col-md-6 col-lg-6 text-right social-icons">
                    <a href="#"><span class="icon-facebook"></span></a>
                    <a href="#"><span class="icon-gplus"></span></a>
                    <a href="#"><span class="icon-twitter"></span></a>
                    <a href="#"><span class="icon-vkontakte"></span></a>
                    <a href="#"><span class="icon-youtube-play"></span></a>
                    <a href="#"><span class="icon-yandex"></span></a>
                    <a href="#"><span class="icon-odnoklassniki"></span></a>
                </div>
            </div>
        </div>
    </div>
</footer>

{include file='toolbar.tpl'}

{hook run='body_end'}

</body>
</html>
