#####################
# Select inner
#####################
define-command encapsul8-action-select-inner -hidden %{
    encapsul8-position-restore-last-search
    execute-keys "H<a-;>L<a-;>"
}

#####################
# Select outer
#####################
define-command encapsul8-action-select-outer -hidden %{
    encapsul8-position-restore-last-search
}

#####################
# Delete
#####################
define-command encapsul8-action-delete -hidden %{
    execute-keys "d"
    encapsul8-undo-save
    encapsul8-position-restore-user
}


#####################
# Replace
#####################
define-command encapsul8-action-replace-with -hidden -params 1 %{
    # eval here to perform only one history_id change
    evaluate-commands %{
        encapsul8-position-restore-last-search
        encapsul8-wrap-add-pair-based-on %arg{1}
        encapsul8-position-restore-last-search
        encapsul8-highlight-wrapping
        execute-keys "d"
    }
    encapsul8-undo-save
    encapsul8-position-restore-user
}

define-command encapsul8-action-replace -hidden %{
    encapsul8-info action_replace
    on-key %{
        encapsul8-check-cancel-with-user-position-restore %val{key}
        encapsul8-action-replace-with %val{key}
    }
}

declare-option -hidden str encapsul8_opt_quick_replace_resolve_char_hotkey
define-command encapsul8-action-quick-replace -hidden %{
    encapsul8-resolve-char-hotkey %val{key} encapsul8_opt_quick_replace_resolve_char_hotkey
    encapsul8-action-replace-with %opt{encapsul8_opt_quick_replace_resolve_char_hotkey}
}

#####################
# Iterate
#####################
declare-option -hidden str encapsul8_iterate_current_search

define-command encapsul8-iterate -hidden %{
    encapsul8-position-restore-last-search
    encapsul8-action-select
}

#####################
# Encapsul8 wrap wrappers
#####################
define-command encapsul8-wrap-around-action-shortcut -hidden %{
    encapsul8-action-select-outer
    encapsul8-wrap-exec
}

define-command encapsul8-wrap-within-action-shortcut -hidden %{
    encapsul8-action-select-inner
    encapsul8-wrap-exec
}

#####################
# Action switch
#####################
define-command encapsul8-action-switch -params 1 -hidden %{
    encapsul8-info action_switch
    on-key %{
        encapsul8-check-cancel-with-user-position-restore %val{key}
        %sh{
            case $kak_key in
                $kak_opt_encapsul8_mapping_action_select_inner)         echo encapsul8-action-select-inner ;;
                $kak_opt_encapsul8_mapping_action_select_outer)         echo encapsul8-action-select-outer ;;
                $kak_opt_encapsul8_mapping_action_delete)               echo encapsul8-action-delete ;;
                $kak_opt_encapsul8_mapping_action_replace)              echo encapsul8-action-replace ;;
                $kak_opt_encapsul8_mapping_action_wrap_within_shortcut) echo encapsul8-wrap-within-action-shortcut ;;
                $kak_opt_encapsul8_mapping_action_wrap_around_shortcut) echo encapsul8-wrap-around-action-shortcut ;;
                $kak_opt_encapsul8_iterate_current_search)              echo encapsul8-iterate ;;
                *)                                                    echo encapsul8-action-quick-replace
            esac
        }
    }
}

define-command encapsul8-action-select -hidden %{
    encapsul8-check-cancel-with-user-position-restore %val{key}
    try %{
        encapsul8-search-pair "%val{key}"
    } catch %{
        encapsul8-position-restore-user
        fail "%val{error}"
    }
    encapsul8-highlight-wrapping
    encapsul8-action-switch "%val{key}" # async
}

define-command encapsul8-action -docstring 'Search for a wrapping and perform an action on it' %{
    encapsul8-info action
    on-key %{
        encapsul8-position-save-user
        try %{
            evaluate-commands %sh{
                [[ $kak_key == $kak_opt_encapsul8_mapping_wrap_shortcut ]] && echo nop || echo fail
            }
            encapsul8-wrap-exec # async
        } catch %{
            set-option window encapsul8_iterate_current_search "%val{key}"
            encapsul8-action-select
        }
    }
}
