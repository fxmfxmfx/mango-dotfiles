function pip
    if not set -q VIRTUAL_ENV
        if test -d .venv
            source .venv/bin/activate.fish
        else
            python -m venv .venv
            source .venv/bin/activate.fish
        end
    end

    python -m pip $argv
end
