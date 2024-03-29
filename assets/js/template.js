jQuery(document).ready(function ($) {
    // Хук начала инициализации javascript-составляющих шаблона
    ls.hook.run('ls_template_init_start', [], window);

    $('html').removeClass('no-js');

    // Определение браузера
    if ($.browser.opera) {
        $('body').addClass('opera opera' + parseInt($.browser.version));
    }
    if ($.browser.mozilla) {
        $('body').addClass('mozilla mozilla' + parseInt($.browser.version));
    }
    if ($.browser.webkit) {
        $('body').addClass('webkit webkit' + parseInt($.browser.version));
    }
    if ($.browser.msie) {
        $('body').addClass('ie');
        if (parseInt($.browser.version) > 8) {
            $('body').addClass('ie' + parseInt($.browser.version));
        }
    }

    // Всплывающие окна
    /*
    $('#window_login_form').jqm();
    $('#blog_delete_form').jqm({trigger: '#blog_delete_show'});
    $('#add_friend_form').jqm({trigger: '#add_friend_show'});
    $('#window_upload_img').jqm();
    $('#userfield_form').jqm();
    $('#favourite-form-tags').jqm();
    $('#modal_write').jqm({trigger: '#modal_write_show'});
    $('#foto-resize').jqm({modal: true});
    $('#avatar-resize').jqm({modal: true});
    $('#userfield_form').jqm({toTop: true});
    $('#photoset-upload-form').jqm({trigger: '#photoset-start-upload'});
    */
	
    $('.js-modal-auth-login').click(function () {
        $('#modal-auth').modal();
        var tab = $('#modal-auth .js-tab-login').tab('show');
        return false;
    });

    $('.js-modal-auth-registration').click(function () {
        $('#modal-auth').modal();
        $('#modal-auth .js-tab-registration').tab('show');
        $('.captcha-image').prop('src', ls.routerUrl('captcha') + '?n=' + Math.random());
        return false;
    });

    $('.js-modal-blog_delete').click(function () {
        $('#modal-blog_delete').modal();
        return false;
    });

    // Datepicker
    /**
     * TODO: навесить языки на datepicker
     */
    $('.date-picker').datepicker({
        dateFormat: 'dd.mm.yy',
        dayNamesMin: ['Вс', 'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб'],
        monthNames: ['Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь', 'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'],
        firstDay: 1
    });


    // Поиск по тегам
    $('.js-tag-search-form').submit(function () {
        window.location = ls.routerUrl('tag') + encodeURIComponent($(this).find('.js-tag-search').val()) + '/';
        return false;
    });


    // Автокомплит
    ls.autocomplete.add($(".autocomplete-tags-sep"), ls.routerUrl('ajax') + 'autocompleter/tag/', true);
    ls.autocomplete.add($(".autocomplete-tags"), ls.routerUrl('ajax') + 'autocompleter/tag/', false);
    ls.autocomplete.add($(".autocomplete-users-sep"), ls.routerUrl('ajax') + 'autocompleter/user/', true);
    ls.autocomplete.add($(".autocomplete-users"), ls.routerUrl('ajax') + 'autocompleter/user/', false);


    // Скролл
    $(window)._scrollable();


    // Тул-бар топиков
    ls.toolbar.topic.init();
    // Кнопка "UP"
    ls.toolbar.up.init();

    $('.js-title-comment, .js-title-topic').tooltip({
        placement: 'left'
    });

    $('.js-tip-help').tooltip({
        placement: 'right'
    });

    /*
    // Всплывающие сообщения
    if (ls.registry.get('block_stream_show_tip')) {
        $('.js-title-comment, .js-title-topic').poshytip({
            className: 'infobox-yellow',
            alignTo: 'target',
            alignX: 'left',
            alignY: 'center',
            offsetX: 10,
            liveEvents: true,
            showTimeout: 1000
        });
    }

    $('.js-title-talk').poshytip({
        className: 'infobox-yellow',
        alignTo: 'target',
        alignX: 'left',
        alignY: 'center',
        offsetX: 10,
        liveEvents: true,
        showTimeout: 500
    });

    $('.js-infobox-vote-topic').poshytip({
        content: function () {
            var id = $(this).attr('id').replace('vote_total_topic_', 'vote-info-topic-');
            return $('#' + id).html();
        },
        className: 'infobox-standart',
        alignTo: 'target',
        alignX: 'center',
        alignY: 'top',
        offsetX: 2,
        liveEvents: true,
        showTimeout: 100
    });

    $('.js-tip-help').poshytip({
        className: 'infobox-standart',
        alignTo: 'target',
        alignX: 'right',
        alignY: 'center',
        offsetX: 5,
        liveEvents: true,
        showTimeout: 500
    });

    $('.js-infobox').poshytip({
        className: 'infobox-standart',
        liveEvents: true,
        showTimeout: 300
    });
    */

    // подсветка кода
    prettyPrint();

    var inputs = $('input.input-text, textarea');
    // эмуляция border-sizing в IE 7-
    // ls.ie.bordersizing(inputs);
    // эмуляция placeholder'ов в IE
    inputs.placeholder();

    // инизиализация блоков
    /*
    ls.blocks.init('stream', {group_items: true, group_min: 3});
    ls.blocks.init('blogs');
    ls.blocks.initSwitch('tags');
    ls.blocks.initSwitch('upload-img');
    ls.blocks.initSwitch('favourite-topic-tags');
    ls.blocks.initSwitch('popup-login');
    */

    // комментарии
    //ls.comments.options.folding = false;
    ls.comments.init();

    // избранное
    ls.hook.add('ls_favourite_toggle_after', function (idTarget, objFavourite, type, params, result) {
        $('#fav_count_' + type + '_' + idTarget).text((result.iCount > 0) ? result.iCount : '');
    });

    // лента активности
    ls.hook.add('ls_stream_append_user_after', function (length, data) {
        if (length == 0) {
            $('#strm_u_' + data.uid).parent().find('a').before('<a href="' + data.user_web_path + '"><img src="' + data.user_avatar_48 + '" alt="avatar" class="avatar" /></a> ');
        }
    });

    // опрос
    ls.hook.add('ls_pool_add_answer_after', function (removeAnchor) {
        var removeAnchor = $('<a href="#" class="glyphicon glyphicon-trash icon-remove" />').attr('title', ls.lang.get('delete')).click(function (e) {
            e.preventDefault();
            return this.removeAnswer(e.target);
        }.bind(ls.poll));
        $(this).find('a').remove();
        $(this).append(removeAnchor);
    });

    /****************
     * TALK
     */

        // Добавляем или удаляем друга из списка получателей
    $('#friends input:checkbox').change(function () {
        ls.talk.toggleRecipient($('#' + $(this).attr('id') + '_label').text(), $(this).attr('checked'));
    });

    // Добавляем всех друзей в список получателей
    $('#friend_check_all').click(function () {
        $('#friends input:checkbox').each(function (index, item) {
            ls.talk.toggleRecipient($('#' + $(item).attr('id') + '_label').text(), true);
            $(item).attr('checked', true);
        });
        return false;
    });

    // Удаляем всех друзей из списка получателей
    $('#friend_uncheck_all').click(function () {
        $('#friends input:checkbox').each(function (index, item) {
            ls.talk.toggleRecipient($('#' + $(item).attr('id') + '_label').text(), false);
            $(item).attr('checked', false);
        });
        return false;
    });

    // Удаляем пользователя из черного списка
    $("#black_list_block").delegate("a.delete", "click", function () {
        ls.talk.removeFromBlackList(this);
        return false;
    });

    // Удаляем пользователя из переписки
    $("#speaker_list_block").delegate("a.delete", "click", function () {
        ls.talk.removeFromTalk(this, $('#talk_id').val());
        return false;
    });


    // Help-tags link
    $('.js-tags-help-link').click(function () {
        var target = ls.registry.get('tags-help-target-id'),
            text='';
        if (!target || !$('#' + target).length) {
            return false;
        }
        target = $('#' + target);
        if ($(this).data('insert')) {
            text = $(this).data('insert');
        } else {
            text = $(this).text();
        }
        $.markItUp({target: target, replaceWith: text});
        return false;
    });


    // Фикс бага с z-index у встроенных видео
    $("iframe").each(function () {
        var ifr_source = $(this).attr('src');

        if (ifr_source) {
            var wmode = "wmode=opaque";

            if (ifr_source.indexOf('?') != -1)
                $(this).attr('src', ifr_source + '&' + wmode);
            else
                $(this).attr('src', ifr_source + '?' + wmode);
        }
    });


    if (navigator.userAgent.match(/IEMobile\/10\.0/)) {
        var msViewportStyle = document.createElement("style");
        msViewportStyle.appendChild(
            document.createTextNode(
                "@-ms-viewport{width:auto!important}"
            )
        );
        document.getElementsByTagName("head")[0].appendChild(msViewportStyle)
    }


    // Хук конца инициализации javascript-составляющих шаблона
    ls.hook.run('ls_template_init_end', [], window);
});
