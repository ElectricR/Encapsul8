# Simple wrapper around 'z' and 'Z' to
# save and restore selections

declare-option -hidden str wrapify_position_save_user
declare-option -hidden str wrapify_position_save_last_search

define-command wrapify-position-save -hidden -params 1 %{
    evaluate-commands -save-regs '^' %{
        execute-keys -save-regs '/"|@:' "Z"
        echo
        set-option window "%arg{1}" "%val{reg_^}"
    }
}

define-command wrapify-position-restore -hidden -params 1 %{
    evaluate-commands -save-regs '^' %{
        execute-keys -save-regs '' ":set-register caret %arg{1}<ret>"
        execute-keys -save-regs '/"|@:' "z"
        echo
    }
}

define-command wrapify-position-save-user -hidden %{
    wrapify-position-save 'wrapify_position_save_user'
}

define-command wrapify-position-restore-user -hidden %{
    wrapify-position-restore "%opt{wrapify_position_save_user}"
}

define-command wrapify-position-save-last-search -hidden %{
    wrapify-position-save 'wrapify_position_save_last_search'
}

define-command wrapify-position-restore-last-search -hidden %{
    wrapify-position-restore "%opt{wrapify_position_save_last_search}"
}

