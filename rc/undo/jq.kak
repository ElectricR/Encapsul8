provide-module wrapify-undo-jq %{
    declare-option -hidden str wrapify_undo_jq_file %sh{
        mktemp -t "kak-wrapify.$kak_session.XXXXXXXX" --tmpdir=$XDG_RUNTIME_DIR
    }

    nop %sh{
        echo '{}' > $kak_opt_wrapify_undo_jq_file
    }

    hook global KakEnd .* %{
        nop %sh{
            rm $kak_opt_wrapify_undo_jq_file
        }
    }

    define-command wrapify-undo-save -hidden -override %{
        nop %sh{
            cat $kak_opt_wrapify_undo_jq_file | jq ". * { \"$kak_buffile\" : { \"$kak_history_id\" : \"$kak_opt_wrapify_position_save_user\" } }" > ${kak_opt_wrapify_undo_jq_file}.tmp
            mv ${kak_opt_wrapify_undo_jq_file}.tmp $kak_opt_wrapify_undo_jq_file
        }
    }

    declare-option -hidden str wrapify_undo_jq_selections

    define-command wrapify-undo -override -docstring 'Try to undo the last change, if it was made by Wrapify (jq version)' %{
        set-option window wrapify_undo_jq_selections %sh{
            cat $kak_opt_wrapify_undo_jq_file | jq -r .'"'$kak_buffile'"'.'"'$kak_history_id'"'
        }
        evaluate-commands %sh{
            [[ $kak_opt_wrapify_undo_jq_selections != null ]] && echo nop || echo fail null selections
        }
        execute-keys "u"
        wrapify-position-restore "%opt{wrapify_undo_jq_selections}"
    }

    define-command wrapify-redo -override -docstring 'Try to redo the last change, if it was made by Wrapify (jq version)' %{
        execute-keys "U"
        try %{
            set-option window wrapify_undo_jq_selections %sh{
                cat $kak_opt_wrapify_undo_jq_file | jq -r .'"'$kak_buffile'"'.'"'$kak_history_id'"'
            }
            evaluate-commands %sh{
                [[ $kak_opt_wrapify_undo_jq_selections != null ]] && echo nop || echo fail
            }
            wrapify-position-restore "%opt{wrapify_undo_jq_selections}"
        } catch %{
            execute-keys "u"
            fail
        }
    }
}
