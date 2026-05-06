function smallfetch --wraps='fastfetch --config small.jsonc' --description 'alias smallfetch=fastfetch --config small.jsonc'
    fastfetch --config small.jsonc $argv
end
