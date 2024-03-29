{$oBlog=$oTopic->getBlog()}
{$oUser=$oTopic->getUser()}
{$oVote=$oTopic->getVote()}

<div class="edit-topic">
<article class="topic topic-type-{$oTopic->getType()} js-topic">
    {block name="topic_header"}
        <header class="topic-header">
            <h2 class="topic-title">
			{* ������� *} 
			<a class="ht-part" href="{$oUser->getUserWebPath()}">
				<img style="border: 1px solid #ddd; border-radius: 50%; padding: 2px;" src="{$oUser->getProfileAvatarPath(48)}" alt="avatar" class="avatar" />
			</a>
                <a href="{$oTopic->getUrl()}">{$oTopic->getTitle()|escape:'html'}</a>

                {if $oTopic->getPublish() == 0}
                    <span class="glyphicon glyphicon-file text-muted" title="{$aLang.topic_unpublish}"></span>
                {/if}

                {if $oTopic->getType() == 'link'}
                    <span class="glyphicon glyphicon-globe text-muted" title="{$aLang.topic_link}"></span>
                {/if}
            </h2>

            <div class="topic-info">
                <a href="{$oBlog->getUrlFull()}" class="topic-blog">{$oBlog->getTitle()|escape:'html'}</a>

                <time datetime="{date_format date=$oTopic->getDateAdd() format='c'}"
                      title="{date_format date=$oTopic->getDateAdd() format='j F Y, H:i'}" class="text-muted">
                    {date_format date=$oTopic->getDateAdd() hours_back="12" minutes_back="60" now="60" day="day H:i" format="j F Y, H:i"}
                </time>
            </div>
			
			{* ������ �������������� � �������� *}
			<div class="edit-topic-icon">
				{if E::IsUser() AND (E::IsAdmin() OR E::UserId()==$oTopic->getUserId() OR E::UserId()==$oBlog->getOwnerId() OR $oBlog->getUserIsAdministrator() OR $oBlog->getUserIsModerator())}        
					<ul class="list-unstyled list-inline actions">								   
						<li><a href="{$oTopic->getUrlEdit()}" 
						title="{$aLang.topic_edit}" class="actions-edit">
						<span class="glyphicon glyphicon-pencil"></span></a></li>
				
						
						{if E::IsAdmin() OR $oBlog->getUserIsAdministrator() OR $oBlog->getOwnerId()==E::UserId()}
							<li><a href="{router page='content'}delete/{$oTopic->getId()}/?security_key={$ALTO_SECURITY_KEY}" 
							title="{$aLang.topic_delete}" 
							onclick="return confirm('{$aLang.topic_delete_confirm}');" 
							class="actions-delete">
							<span class="glyphicon glyphicon-trash"></span>
							</a></li>
						{/if}
					</ul>
				{/if}	
			</div>
        </header>
    {/block}

    {block name="topic_content"}
        <div class="topic-content text">
            {hook run='topic_content_begin' topic=$oTopic bTopicList=true}

            {$oTopic->getTextShort()}

            {if $oTopic->getTextShort()!=$oTopic->getText()}
                <br/>
                <a href="{$oTopic->getUrl()}#cut" title="{$aLang.topic_read_more}" class="read-more">
                    {if $oTopic->getCutText()}
                        {$oTopic->getCutText()} &rarr;
                    {else}
                        {$aLang.topic_read_more} &rarr;
                    {/if}
                </a>
            {/if}

            {hook run='topic_content_end' topic=$oTopic bTopicList=true}
        </div>
    {/block}

    {block name="topic_footer"}
        {$oBlog=$oTopic->getBlog()}
        {$oUser=$oTopic->getUser()}
        {$oVote=$oTopic->getVote()}
        {$oFavourite=$oTopic->getFavourite()}
        <footer class="topic-footer">
            {include file="fields/field.tags.show.tpl"}

            <div class="topic-share" id="topic_share_{$oTopic->getId()}">
                {hookb run="topic_share" topic=$oTopic bTopicList=true}
                    <div class="yashare-auto-init" data-yashareTitle="{$oTopic->getTitle()|escape:'html'}"
                         data-yashareLink="{$oTopic->getUrl()}" data-yashareL10n="ru" data-yashareType="none"
                         data-yashareQuickServices="yaru,vkontakte,facebook,twitter,odnoklassniki,moimir,lj,gplus"></div>
                {/hookb}
            </div>

            <ul class="list-unstyled list-inline small topic-info">
                <li class="topic-info-author">
                    <a href="{$oUser->getProfileUrl()}"><img src="{$oUser->getAvatarUrl(24)}"
                                                             alt="{$oUser->getDisplayName()}" class="avatar"/></a>
                    <a rel="author" href="{$oUser->getProfileUrl()}">{$oUser->getDisplayName()}</a>
                </li>
                <li class="topic-info-favourite">
                    <a href="#" onclick="return ls.favourite.toggle({$oTopic->getId()},this,'topic');"
                       class="favourite {if E::IsUser() AND $oTopic->getIsFavourite()}active{/if}"><span
                                class="glyphicon glyphicon-star-empty"></span></a>
                    <span class="text-muted favourite-count"
                          id="fav_count_topic_{$oTopic->getId()}">{$oTopic->getCountFavourite()}</span>
                </li>
                <li class="topic-info-share"><a href="#" class="glyphicon glyphicon-share-alt"
                                                title="{$aLang.topic_share}"
                                                onclick="jQuery('#topic_share_' + '{$oTopic->getId()}').slideToggle(); return false;"></a>
                </li>

                <li class="topic-info-comments">
                    {if $oTopic->getCountCommentNew()}
                        <a href="{$oTopic->getUrl()}#comments" title="{$aLang.topic_comment_read}" class="new">
                            <span class="glyphicon glyphicon-comment icon-active"></span>
                            <span>{$oTopic->getCountComment()}</span>
                            <span class="count">+{$oTopic->getCountCommentNew()}</span>
                        </a>
                    {elseif $oTopic->getCountComment()}
                        <a href="{$oTopic->getUrl()}#comments" title="{$aLang.topic_comment_read}"
                           class="icon-active">
                            <span class="glyphicon glyphicon-comment"></span>
                            <span>{$oTopic->getCountComment()}</span>
                        </a>
                    {else}
                        <a href="{$oTopic->getUrl()}#comments" title="{$aLang.topic_comment_read}">
                            <span class="glyphicon glyphicon-comment"></span>
                            <span>{$oTopic->getCountComment()}</span>
                        </a>
                    {/if}
                </li>

                <li id="vote_area_topic_{$oTopic->getId()}"
                    class="pull-right vote
                {if $oVote OR E::UserId()==$oTopic->getUserId() OR strtotime($oTopic->getDateAdd())<$smarty.now-Config::Get('acl.vote.topic.limit_time')}
                    {if $oTopic->getRating() > 0}
                        vote-count-positive
                    {elseif $oTopic->getRating() < 0}
                        vote-count-negative
                    {/if}
                {/if}

                {if $oVote}
                    voted {if $oVote->getDirection() > 0} voted-up {elseif $oVote->getDirection() < 0} voted-down{/if}
                {/if}">

                    {if $oTopic->isVoteInfoShow()}
                        {$bVoteInfoShow=true}
                    {/if}
                    <div class="vote-down" onclick="return ls.vote.vote({$oTopic->getId()},this,-1,'topic');"><span
                                class="glyphicon glyphicon-thumbs-down"></span></div>
                    <div class="vote-count {if $bVoteInfoShow}js-infobox-vote-topic{/if}"
                         id="vote_total_topic_{$oTopic->getId()}"
                         title="{$aLang.topic_vote_count}: {$oTopic->getCountVote()}">
                        {if $bVoteInfoShow}
                            {if $oTopic->getRating() > 0}+{/if}{$oTopic->getRating()}
                        {else}
                            <a href="#" onclick="return ls.vote.vote({$oTopic->getId()},this,0,'topic');">?</a>
                        {/if}
                    </div>
                    <div class="vote-up" onclick="return ls.vote.vote({$oTopic->getId()},this,1,'topic');"><span
                                class="glyphicon glyphicon-thumbs-up"></span></div>
                    {if $bVoteInfoShow}
                        <div id="vote-info-topic-{$oTopic->getId()}" style="display: none;">
                            <ul class="list-unstyled vote-topic-info">
                                <li><span class="glyphicon glyphicon-thumbs-up"></span>{$oTopic->getCountVoteUp()}</li>
                                <li><span class="glyphicon glyphicon-thumbs-down"></span>{$oTopic->getCountVoteDown()}
                                </li>
                                <li><span class="glyphicon glyphicon-eye-open"></span>{$oTopic->getCountVoteAbstain()}
                                </li>
                                {hook run='topic_show_vote_stats' topic=$oTopic}
                            </ul>
                        </div>
                    {/if}
                </li>

                {hook run='topic_show_info' topic=$oTopic}
            </ul>

        </footer>
    {/block}
</article> 
</div>
<!-- /.topic -->
