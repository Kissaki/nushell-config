# https://www.nushell.sh/book/custom_completions.html#external-completions
# https://www.nushell.sh/cookbook/external_completers.html#carapace-completer

let multiple_completers = {|spans|
    match $spans.0 {
        # dotnet - nu_scripts has a completion which has item descriptions
        # dotnet https://learn.microsoft.com/en-us/dotnet/core/tools/enable-tab-autocomplete#nushell
        # `dotnet complete`: arg: args[1..], result: lines
        #dotnet => {|| dotnet complete ($spans | skip 1 | str join " ") | lines }
        dotnet => { dotnet complete ($spans | skip 1 | str join " ") | lines }

        # winget - nu_scripts has a completion which has item descriptions
        # winget https://learn.microsoft.com/en-us/windows/package-manager/winget/tab-completion
        # winget https://github.com/microsoft/winget-cli/blob/master/doc/Completion.md
        # winget - nushell has `commandline get-cursor` we could use, but word identification would be missing -> inconsistency breakage
        winget => { winget complete --commandline ($spans | str join " ") --word ($spans | last) --position 999 | lines }
        #winget => {|| dotnet-suggest get --executable winget -- ($spans | skip 1 | str join " ") | lines | skip 1 }

        # dotnet System.CommandLine https://learn.microsoft.com/en-us/dotnet/standard/commandline/tab-completion
        #_ => { dotnet-suggest get --executable ($spans | first) -- ($spans | skip 1 | str join " ") }

        #aa => {|| [{value: ($in | length), description:'in count'}] }
        #aa => {|| [{value: ($in), description:'in content'}] }
        ##aa => {|| [{value: ($spans | length), description:'spans count'}] }
        ##aa => {|| [{value: ($spans | str join "_" | collect), description:'spans joined'} {value:'second'}] }
        #aa => {|| $in | str join "," | {|span| {value:$spans} } }
        #aa => {|| $in | each {|span| {value:$spans} } }
        #a => { $spans | skip 1 | each {|span| {value: $span, description:'ye'} } }
        #_ => {|spans| [{value:'default'}] }
    }
}

$env.config.completions.external.completer = $multiple_completers
