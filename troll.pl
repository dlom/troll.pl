use Purple;

%PREFS = (
    current_troll_default => "none",
    current_troll => "none"
);
sub save_troll {
    Purple::Prefs::set_string("/plugins/core/troll/current_troll", $PREFS{current_troll});
}
sub load_troll {
    $PREFS{current_troll} = Purple::Prefs::get_string("/plugins/core/troll/current_troll");
}

%PLUGIN_INFO = (
    perl_api_version => 2,
    name => "Troll",
    version => "1.1",
    summary => "Speak like a troll and impress your friends!",
    description => "Speak like a troll.",
    author => "dlom234\@gmail.com",
    url => "https//github.com/Dlom/troll.pl",
    load => "plugin_load",
    unload => "plugin_unload",
    prefs_info => "prefs_info"
);

sub troll_log {
    Purple::Debug::info("$PLUGIN_INFO{name}", "$_[0]\n");
}
sub troll_display {
    my ($conv, $message) = @_;
    $message = "<html xmlns='http://jabber.org/protocol/xhtml-im'><body xmlns='http://www.w3.org/1999/xhtml'><p><span style='font-weight: bold;'><span style='color: #777777;'>$message</span></span></p></body></html>";
    $conv->write("", $message, Purple::Conversation::Flags::NO_LOG | Purple::Conversation::Flags::RAW | Purple::Conversation::Flags::NO_LINKIFY, 0);
}

sub troll_speak {
    load_troll();
    return $trolls{$PREFS{current_troll}}->(@_[0]);
}

# Trolls
sub aradia {
    my $message = $_[0];
    # downcase
    $message = lc($message);
    # o -> 0
    $message =~ y/o/0/;
    return $message;
}
sub tavros {
    my $message = $_[0];
    # iNVERT CASE
    $message =~ y/A-Za-z/a-zA-Z/;
    # . -> ,, ? -> ,, ! -> ,
    $message =~ y/\.\?!/,/;
    # Smileys
    $message =~ s/:(.)/}:$1/g;
    return $message;
}
sub sollux {
    $message = $_[0];
    # downcase
    $message = lc($message);
    # s -> 2, i -> ii, too -> two, to -> two
    $message =~ y/s/2/;
    $message =~ s/i/ii/g;
    $message =~ s/too?/two/g;
    return $message;
}
sub karkat {
    my $message = $_[0];
    # UPCASE
    $message = uc($message);
    return $message;
}
sub nepeta {
    my $message = $_[0];
    # downcase
    $message = lc($message);
    # strip punctuation except ? and !
    $message =~ s/[^\w\s!\?]//g;
    $message =~ s/_//g;
    # ee -> 33
    $message =~ s/ee/33/g;
    # Cat puns
    $message =~ s/per/purr/g;
    $message =~ s/pau/paw/g;
    # Prefix with :33 <
    $message = ":33 < $message";
    return $message;
}
sub kanaya {
    my $message = $_[0];
    # Strip punctuation
    $message =~ s/[^\w\s]//g;
    $message =~ s/_//g;
    # Upcase First Letter Of Each Word
    $message =~ s/(\w+)/\u\L$1/g;
    return $message;
}
sub terezi {
    my $message = $_[0];
    # UPCASE
    $message = uc($message);
    # A -> 4, E -> 3, I -> 1
    $message =~ y/AEI/431/;
    # Strip , . and '
    $message =~ s/(,|\.|')//g;
    # Smileys
    $message =~ s/:(.)/>:$1/g;
    $message =~ s/>:\)/>:]/g;
    $message =~ s/>:\(/>:[/g;
    return $message;
}
sub vriska {
    my $message = $_[0];
    # Randomly multiply vowels
    $message =~ s/([AEIOUaeiou])$/("$1$1$1$1$1$1$1$1", "$1", "$1", "$1")[rand(8)]/eg;
    # Randomly multiply puntuation
    $message =~ s/([\.\?\,\!])$/("$1$1$1$1$1$1$1$1", "$1", "$1", "$1")[rand(8)]/eg;
    # b -> 8, B -> 8
    $message =~ s/[bB]/8/g;
    # Smileys
    $message =~ s/:(.)/::::$1/g;
    return $message;
}
sub equius {
    my $message = $_[0];
    # STRONG
    $message =~ s/(\b[sS][tT][rR][oO][nN][gG]\w*)/uc($1)/eg;
    # x -> %
    $message =~ s/[xX]/%/g;
    # ool -> 001, loo -> 001
    $message =~ s/[oO][oO][lL]/001/g;
    $message =~ s/[lL][oO][oO]/100/g;
    # oo -> 00
    $message =~ s/[oO][oO]/00/g;
    # Prefix with D --> 
    $message = "D --> $message";
    return $message;
}
sub gamzee {
    my $message = $_[0];
    # AlTeRnAtE cApS
    $message =~ s/([\w\s])([\w\s]?)/uc($1) . lc($2)/eg;
    # Smileys
    $message =~ s/:(.)/:o$1/g;
    return $message;
}
sub eridan {
    my $message = $_[0];
    # downcase
    $message = lc($message);
    # Strip punctuation
    $message =~ s/[^\w\s]//g;
    $message =~ s/_//g;
    # want to -> wanna, going to -> gonna
    $message =~ s/want to/wanna/g;
    $message =~ s/going to/gonna/g;
    # ing -> in
    $message =~ s/ing/in/g;
    # v -> vv, w -> ww
    $message =~ s/([vw])/$1$1/g;
    return $message;
}
sub feferi {
    my $message = $_[0];
    # h -> )(
    $message =~ s/[hH]/)(/g;
    # E -> -E
    $message =~ s/E/-E/g;
    return $message;
}
sub none {
    return $_[0];
}

%trolls = (
    aradia => \&aradia,
    tavros => \&tavros,
    sollux => \&sollux,
    karkat => \&karkat,
    nepeta => \&nepeta,
    kanaya => \&kanaya,
    terezi => \&terezi,
    vriska => \&vriska,
    equius => \&equius,
    gamzee => \&gamzee,
    eridan => \&eridan,
    feferi => \&feferi,
    none => \&none
);

sub ucarray {
    my (@arr) = @_;
    foreach my $index (0..$#arr) {
        @arr[$index] = ucfirst(@arr[$index]);
    }
    return @arr;
}
sub plugin_init {
    return %PLUGIN_INFO;
}
sub on_troll_command {
    my ($conv, $cmd, $data, @args) = @_;
    my $arg = $args[0];
    if ($arg eq "") {
        load_troll();
        troll_log("The current troll is " . ucfirst($PREFS{current_troll}));
        troll_display($conv, "The current troll is " . ucfirst($PREFS{current_troll}));
    } elsif (exists($trolls{lc($arg)})) {
        $PREFS{current_troll} = lc($arg);
        save_troll();
        troll_log("Troll set to: $PREFS{current_troll}");
        troll_display($conv, "Troll set to: " . ucfirst($PREFS{current_troll}));
    } elsif ($arg eq "list") {
        troll_display($conv, "Trolls: " . join(", ", ucarray(keys(%trolls))));
    } else {
        troll_log("$arg is not a valid troll!");
        troll_display($conv, "$arg is not a valid troll!");
    }
    return Purple::Cmd::Return::OK;
}
sub sending_message {
    my ($account, $id, $message) = @_;
    $message = troll_speak($message);
    @_[2] = $message;
}
sub prefs_info {
    my $frame = Purple::PluginPref::Frame->new();
    my $ppref = Purple::PluginPref->new_with_name_and_label("/plugins/core/troll/current_troll", "Which Troll");
    $ppref->set_type(1);
    $ppref->add_choice("Aradia", "aradia");
    $ppref->add_choice("Tavros", "tavros");
    $ppref->add_choice("Sollux", "sollux");
    $ppref->add_choice("Karkat", "karkat");
    $ppref->add_choice("Nepeta", "nepeta");
    $ppref->add_choice("Kanaya", "kanaya");
    $ppref->add_choice("Terezi", "terezi");
    $ppref->add_choice("Vriska", "vriska");
    $ppref->add_choice("Equius", "equius");
    $ppref->add_choice("Gamzee", "gamzee");
    $ppref->add_choice("Eridan", "eridan");
    $ppref->add_choice("Feferi", "feferi");
    $ppref->add_choice("None", "none");
    $frame->add($ppref);
    return $frame;
}
sub plugin_load {
    my $plugin = shift;
    Purple::Prefs::add_none("/plugins/core/troll");
    Purple::Prefs::add_string("/plugins/core/troll/current_troll", $PREFS{current_troll_default});
    load_troll();    
    troll_log("Current troll set to: $PREFS{current_troll}");
    my $conversations_handle = Purple::Conversations::get_handle();
    my $help = "/troll name|none";
    Purple::Signal::connect($conversations_handle, "sending-im-msg", $plugin, \&sending_message);
    my $command_id = Purple::Cmd::register($plugin, "troll", "s", Purple::Cmd::Priority::DEFAULT, Purple::Cmd::Flag::IM | Purple::Cmd::Flag::ALLOW_WRONG_ARGS, "prpl-trolls", \&on_troll_command, "$help", $plugin);
    troll_log("Trolls loaded :D");
}
sub plugin_unload {
    my $plugin = shift;
    troll_log("Trolls unloaded :(");
}