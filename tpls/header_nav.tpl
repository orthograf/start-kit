<nav id="nav" class="clearfix">
    <div class="container">
        <div class="row">

            <div class="col-sm-8 col-lg-8">
                {if $menu}
                    {if in_array($menu,$aMenuContainers)}{$aMenuFetch.$menu}{else}{include file="menus/menu.$menu.tpl"}{/if}
                {/if}
            </div>

        </div>
    </div>
</nav>
