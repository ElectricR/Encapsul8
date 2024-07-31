declare-option -hidden bool wrapify_undo_jq_detected %sh{
    ( [[ -n $(jq -h | tr -d '\n') ]] && echo true ) || echo false
}

declare-option -hidden str wrapify_undo_provider %sh{
    if $kak_opt_wrapify_undo_jq_detected; then
        echo jq
    else
        echo simple
    fi
}

define-command wrapify-undo-save -hidden -override %{
    require-module %sh{
        printf "wrapify-undo-$kak_opt_wrapify_undo_provider"
    }
    wrapify-undo-save
}

define-command wrapify-undo -docstring 'Try to undo the last change, if it was made by Wrapify' %{
    require-module %sh{
        printf "wrapify-undo-$kak_opt_wrapify_undo_provider"
    }
    wrapify-undo
}

define-command wrapify-redo -docstring 'Try to redo the last change, if it was made by Wrapify' %{
    require-module %sh{
        printf "wrapify-undo-$kak_opt_wrapify_undo_provider"
    }
    wrapify-redo
}
