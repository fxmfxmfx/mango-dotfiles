function fish_prompt
    if fish_is_root_user
        set_color --bold red
    else
        set_color --bold green
    end
    echo -n (whoami)'@'(prompt_hostname)

    if fish_is_root_user
        set_color --bold red
    else
        set_color --bold blue
    end
    echo -n ' '(prompt_pwd)

    set_color normal
    echo -n ' '

    if fish_is_root_user
        echo -n '# '
    else
        echo -n '$ '
    end
end
