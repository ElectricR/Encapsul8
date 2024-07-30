# Declaration of user-tweakable options

declare-option -hidden str wrapify_mapping_action_select_inner
declare-option -hidden str wrapify_mapping_action_select_outer
declare-option -hidden str wrapify_mapping_action_delete
declare-option -hidden str wrapify_mapping_action_replace
declare-option -hidden str wrapify_mapping_wrap_shortcut
declare-option -hidden str wrapify_mapping_cancel

# Suggested defaults
# Load them with `require-module wrapify-load-defaults`
provide-module wrapify-load-defaults %{
    set-option global wrapify_mapping_action_select_inner 'i'
    set-option global wrapify_mapping_action_select_outer 'a'
    set-option global wrapify_mapping_action_delete 'd'
    set-option global wrapify_mapping_action_replace 'r'
    set-option global wrapify_mapping_wrap_shortcut 's'
    set-option global wrapify_mapping_cancel '<esc>'

    define-command undo %{
        try %{ wrapify-undo } catch %{ try %{ execute-keys u } }
    }
    define-command redo %{
        try %{ wrapify-redo } catch %{ try %{ execute-keys U } }
    }
    map global normal u ':undo<ret>' -docstring "Wrapify-aware undo"
    map global normal U ':redo<ret>' -docstring "Wrapify-aware redo"
    map global normal m ':wrapify-action<ret>' -docstring 'Wrapify action'
}
