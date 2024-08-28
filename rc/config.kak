# Declaration of user-tweakable options

declare-option str encapsul8_mapping_action_select_inner
declare-option str encapsul8_mapping_action_select_outer
declare-option str encapsul8_mapping_action_delete
declare-option str encapsul8_mapping_action_replace
declare-option str encapsul8_mapping_action_surround_within_shortcut
declare-option str encapsul8_mapping_action_surround_around_shortcut
declare-option str encapsul8_mapping_surround_shortcut
declare-option str encapsul8_mapping_cancel

declare-option str encapsul8_mapping_alias_parentheses
declare-option str encapsul8_mapping_alias_square_brackets
declare-option str encapsul8_mapping_alias_braces
declare-option str encapsul8_mapping_alias_angle_brackets
declare-option str encapsul8_mapping_alias_single_quote
declare-option str encapsul8_mapping_alias_double_quote
declare-option str encapsul8_mapping_alias_grave

declare-option bool encapsul8_show_key_tips

# Suggested defaults
# Load them with `require-module encapsul8-load-defaults`
provide-module encapsul8-load-defaults %{
    require-module encapsul8-load-defaults-local
    require-module encapsul8-load-defaults-global
}

provide-module encapsul8-load-defaults-local %{
    set-option global encapsul8_mapping_action_select_inner 'i'
    set-option global encapsul8_mapping_action_select_outer 'a'
    set-option global encapsul8_mapping_action_delete 'd'
    set-option global encapsul8_mapping_action_surround_within_shortcut 'x'
    set-option global encapsul8_mapping_action_surround_around_shortcut 's'
    set-option global encapsul8_mapping_surround_shortcut 's'
    set-option global encapsul8_mapping_cancel '<esc>'
    # set-option global encapsul8_mapping_action_replace 'r'

    set-option global encapsul8_mapping_alias_parentheses 'p'
    set-option global encapsul8_mapping_alias_square_brackets 'b'
    set-option global encapsul8_mapping_alias_braces 'c'
    set-option global encapsul8_mapping_alias_angle_brackets 'n'
    set-option global encapsul8_mapping_alias_single_quote 'Q'
    set-option global encapsul8_mapping_alias_double_quote 'q'
    set-option global encapsul8_mapping_alias_grave 'g'

    set-option global encapsul8_show_key_tips true
}

provide-module encapsul8-load-defaults-global %{
    define-command encapsul8-undo-helper -docstring "Perform undo and try to restore saved selections" %{
        try %{ encapsul8-undo } catch %{ try %{ execute-keys u } }
    }
    define-command encapsul8-redo-helper -docstring "Perform redo and try to restore saved selections" %{
        try %{ encapsul8-redo } catch %{ try %{ execute-keys U } }
    }

    map global normal u ':encapsul8-undo-helper<ret>' -docstring "Encapsul8-aware undo"
    map global normal U ':encapsul8-redo-helper<ret>' -docstring "Encapsul8-aware redo"
    map global normal m ':encapsul8-action<ret>' -docstring 'Encapsul8 action'
}
