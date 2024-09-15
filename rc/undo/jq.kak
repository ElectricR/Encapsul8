define-command encapsul8-undo-init-jq %{
    declare-option -hidden str encapsul8_undo_jq_file %sh{
        mktemp -t "kak-encapsul8.$kak_session.XXXXXXXX" --tmpdir=$XDG_RUNTIME_DIR
    }

    nop %sh{
        echo '{}' > $kak_opt_encapsul8_undo_jq_file
    }

    hook global KakEnd .* %{
        nop %sh{
            rm $kak_opt_encapsul8_undo_jq_file
        }
    }

    define-command encapsul8-undo-save -hidden -override %{
        nop %sh{
            cat $kak_opt_encapsul8_undo_jq_file | jq ". * { \"$kak_buffile\" : { \"$kak_history_id\" : \"$kak_opt_encapsul8_position_save_user\" } }" > ${kak_opt_encapsul8_undo_jq_file}.tmp
            mv ${kak_opt_encapsul8_undo_jq_file}.tmp $kak_opt_encapsul8_undo_jq_file
        }
    }

    declare-option -hidden str encapsul8_undo_jq_selections

    define-command encapsul8-undo -override -docstring 'Try to undo the last change, if it was made by Encapsul8 (jq version)' %{
        set-option window encapsul8_undo_jq_selections %sh{
            cat $kak_opt_encapsul8_undo_jq_file | jq -r .'"'$kak_buffile'"'.'"'$kak_history_id'"'
        }
        evaluate-commands %sh{
            [ "$kak_opt_encapsul8_undo_jq_selections" != null ] && echo nop || echo fail null selections
        }
        execute-keys "u"
        encapsul8-position-restore "%opt{encapsul8_undo_jq_selections}"
    }

    define-command encapsul8-redo -override -docstring 'Try to redo the last change, if it was made by Encapsul8 (jq version)' %{
        execute-keys "U"
        try %{
            set-option window encapsul8_undo_jq_selections %sh{
                cat $kak_opt_encapsul8_undo_jq_file | jq -r .'"'$kak_buffile'"'.'"'$kak_history_id'"'
            }
            evaluate-commands %sh{
                [ "$kak_opt_encapsul8_undo_jq_selections" != null ] && echo nop || echo fail
            }
            encapsul8-position-restore "%opt{encapsul8_undo_jq_selections}"
        } catch %{
            execute-keys "u"
            fail
        }
    }
}
