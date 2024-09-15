declare-option -hidden bool encapsul8_undo_jq_detected %sh{
    ( [ -n "$(jq -h | tr -d '\n')" ] && echo true ) || echo false
}

declare-option -hidden str encapsul8_undo_provider %sh{
    if $kak_opt_encapsul8_undo_jq_detected; then
        echo jq
    else
        echo simple
    fi
}

define-command encapsul8-undo-save -hidden -override %{
    require-module "encapsul8-undo-%opt{encapsul8_undo_provider}"
    encapsul8-undo-save
}

define-command encapsul8-undo -docstring 'Try to undo the last change, if it was made by Encapsul8' %{
    require-module "encapsul8-undo-%opt{encapsul8_undo_provider}"
    encapsul8-undo
}

define-command encapsul8-redo -docstring 'Try to redo the last change, if it was made by Encapsul8' %{
    require-module "encapsul8-undo-%opt{encapsul8_undo_provider}"
    encapsul8-redo
}
