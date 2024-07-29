#####################
# Select inner
#####################
define-command wrapify-action-select-inner -hidden %{
    wrapify-position-restore-last-search
    execute-keys "H<a-;>L<a-;>"
}

#####################
# Select outer
#####################
define-command wrapify-action-select-outer -hidden %{
    wrapify-position-restore-last-search
}

#####################
# Delete
#####################
define-command wrapify-action-delete -hidden %{
    execute-keys "d"
    wrapify-undo-save
    wrapify-position-restore-user
}


#####################
# Replace
#####################
define-command wrapify-action-replace-with -hidden -params 1 %{
    # eval here to perform only one history_id change
    evaluate-commands %{
        wrapify-position-restore-last-search
        wrapify-wrap-add-pair-based-on %arg{1}
        wrapify-position-restore-last-search
        wrapify-highlight-wrapping
        execute-keys "d"
    }
    wrapify-undo-save
    wrapify-position-restore-user
}

define-command wrapify-action-replace -hidden %{
    on-key %{
        wrapify-check-cancel-with-user-position-restore %val{key}
        wrapify-action-replace-with %val{key}
    }
}

define-command wrapify-action-replace-with-key -hidden %{
    wrapify-action-replace-with %val{key}
}

#####################
# Action switch
#####################
define-command wrapify-action-switch -params 1 -hidden %{
    on-key %{
        wrapify-check-cancel-with-user-position-restore %val{key}
        %sh{
            case $kak_key in
                $kak_opt_wrapify_mapping_action_select_inner) echo wrapify-action-select-inner ;;
                $kak_opt_wrapify_mapping_action_select_outer) echo wrapify-action-select-outer ;;
                $kak_opt_wrapify_mapping_action_delete)       echo wrapify-action-delete ;;
                $kak_opt_wrapify_mapping_action_replace)      echo wrapify-action-replace ;;
                *) echo wrapify-action-replace-with-key
            esac
        }
    }
}

define-command wrapify-action %{
    on-key %{
        try %{
            evaluate-commands %sh{
                [[ $kak_key == $kak_opt_wrapify_mapping_wrap_shortcut ]] && echo nop || echo fail
            }
            wrapify-wrap # async
        } catch %{
            wrapify-check-cancel %val{key}
            wrapify-position-save-user
            try %{
                wrapify-search-pair "%val{key}"
            } catch %{
                wrapify-position-restore-user
                fail "%val{error}"
            }
            wrapify-highlight-wrapping
            wrapify-action-switch "%val{key}" # async
        }
    }
}
