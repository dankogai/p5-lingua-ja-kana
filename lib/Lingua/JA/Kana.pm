package Lingua::JA::Kana;
use warnings;
use strict;
use utf8;

our $VERSION = sprintf "%d.%02d", q$Revision: 0.1 $ =~ /(\d+)/g;

our $USE_REGEXP_ASSEMBLE = do {
    eval 'require Regexp::Assemble';
    $@ ? 0 : 1;
};

our $Re_Vowels     = qr/[aeiou]/i;
our $Re_Consonants = qr/[bcdfghijklmnpqrstvwxyz]/i;

our %Kata2Hepburn = qw(
  ア   a       イ   i       ウ   u       エ   e       オ   o
  ァ   xa      ィ   xi      ゥ   xu      ェ   xe      ォ   xo
  カ   ka      キ   ki      ク   ku      ケ   ke      コ   ko
  ガ   ga      ギ   gi      グ   gu      ゲ   ge      ゴ   go
  キャ kya                  キュ kyu                  キョ kyo
  サ   sa      シ   shi     ス   su      セ   se      ソ   so
  ザ   za      ジ   ji      ズ   zu      ゼ   ze      ゾ   zo
  シャ sha                  シュ shu                  ショ sho
　ジャ ja                   ジュ ju                   ジョ jo
  タ   ta      チ   chi     ツ   tsu     テ   te      ト   to
               ティ ti      トゥ tu
  ダ   da      ディ di      ドゥ du      デ   de      ド   do
               ヂ   dhi     ヅ   dhu
  チャ cha                  チュ chu     チェ che     チョ cho
  ヂャ dha                  ヂュ dhu     ヂェ dhe     ヂョ dho
  ナ   na      ニ   ni      ヌ   nu      ネ   ne      ノ   no
  ハ   ha      ヒ   hi      フ   fu      ヘ   he      ホ   ho
  ヒャ hya                  ヒュ hyu                  ヒョ hyo
  バ   ba      ビ   bi      ブ   bu      ベ   be      ボ   bo
  ビャ bya                  ビュ byu                  ビョ byo
  パ   pa      ピ   pi      プ   pu      ペ   pe      ポ   po
  ピャ pya                  ピュ pyu                  ピョ pyo
  ファ fa      フィ fi                   フェ fe      フォ fo
  マ   ma      ミ   mi      ム   mu      メ   me      モ   mo
  ヤ   ya                   ユ   yu      イェ ye      ヨ   yo
  ャ   xya                  ュ   xyu                  ョ   xyo
  ラ   ra      リ   ri      ル   ru      レ   re      ロ   ro
  ワ   wa      ヰ   wi                   ヱ   we      ヲ   wo
  ウァ wa      ウィ wi                   ウェ we      ウォ wo
  ヴァ va      ヴィ vi      ヴ   vu      ヴェ ve      ヴォ vo
  ン   nn
);

our %Kana2Hepburn =
  ( %Kata2Hepburn, map { katakana2hiragana($_) } %Kata2Hepburn );

our $Re_Kana2Hepburn = do {
    if ($USE_REGEXP_ASSEMBLE) {
        my $ra = Regexp::Assemble->new();
        $ra->add($_) for keys %Kana2Hepburn;
        $ra->re;
    }
    else {
        my $str = join '|', keys %Kana2Hepburn;
        qr/(?:$str)/;
    }
};

our %Romaji2Kata = qw(
  a    ア      i    イ      u    ウ      e    エ      o    オ
  xa   ァ      xi   ィ      xu   ゥ      xe   ェ      xo   ォ
  ka   カ      ki   キ      ku   ク      ke   ケ      ko   コ
  ga   ガ      gi   ギ      gu   グ      ge   ゲ      go   ゴ
  kya  キャ                 kyu キュ                  kyo  キョ
  sa   サ      shi  シ      su   ス      se   セ      so   ソ
               si   シ
  za   ザ      ji   ジ      zu   ズ      ze   ゼ      zo   ゾ
               zi   ジ
  sha  シャ                 shu  シュ                 sho  ショ
  sya  シャ                 syu  シュ                 syo  ショ
  ta   タ      chi  チ      tsu  ツ      te   テ      to   ト
                            xtu  ッ 
               ti   ティ    tu   トゥ
  da   ダ      di   ディ    du   ドゥ    de   デ      do   ド
               dhi  ヂ      dhu  ヅ
  cha  チャ                 chu  チュ    che  チェ    cho  チョ
  tya  チャ                 tyu  チュ    tye　チェ    tyo  チョ
  dha  ヂャ                 dhu  ヂュ    dhe  ヂェ    dho  ヂョ
  dya  ヂャ                 tyu  ヂュ    tye　ヂェ    tyo  ヂョ
  na   ナ      ni   ニ      nu   ヌ      ne   ネ      no   ノ
  ha   ハ      hi   ヒ      fu   フ      he   ヘ      ho   ホ
                            hu   フ
  hya  ヒャ                 hyu  ヒュ                 hyo  ヒョ
  ba   バ      bi   ビ      bu   ブ      be   ベ      bo   ボ
  bya  ビャ                 byu  ビュ                 byo  ビョ
  pa   パ      pi   ピ      pu   プ      pe   ペ      po   ポ
  pya  ピャ                 pyu  ピュ                 pyo  ピョ
  fa   ファ    fi   フィ                 fe   フェ    fo   フォ
  ma   マ      mi   ミ      mu   ム      me   メ      mo   モ
  ya   ヤ                   yu   ユ      ye   イェ    yo   ヨ
  xya  ャ                   xyu  ュ                   xyo  ョ
  ra   ラ      ri   リ      ru   ル      re   レ      ro   ロ
  la   ラ      li   リ      lu   ル      le   レ      lo   ロ
  wa   ワ                                             wo   ヲ
               wi   ウィ                 we   ウェ
  va   ヴァ    vi   ヴィ    vu   ヴ      ve   ヴェ    vo   ヴォ
  nn   ン
);

our $Re_Romaji2Kata = do {
    if ($USE_REGEXP_ASSEMBLE) {
        my $ra = Regexp::Assemble->new();
        $ra->add($_) for keys %Romaji2Kata;
        my $str = $ra->re;
        substr( $str, 0,  8, '' );    # remove '(?-xism:'
        substr( $str, -1, 1, '' );    # and ')';
        qr/$str/i;                    # and recompile with i
    }
    else {
        my $str = join '|', keys %Romaji2Kata;
        qr/(?:$str)/i;
    }
};


our %Kana2Romaji    = %Kana2Hepburn;
our $Re_Kana2Romaji = $Re_Kana2Hepburn;

sub katakana2hiragana{
  my $str = shift;
  $str =~ tr/ァ-ン/ぁ-ん/;
  $str;
}

sub hiragana2katakana{
  my $str = shift;
  $str =~ tr/ぁ-ん/ァ-ン/;
  $str;
}

{
    no warnings 'once';
    *kata2hira = \&katakana2hiragana;
    *hira2kata = \&hiragana2katakana;
}

sub romaji2katakana{
  my $str = shift;
  # step 1; tta -> ッta
  $str =~ s{ ($Re_Consonants) \1 }{ "ッ$1" }msxgei;
  # step 2;
  $str =~ s{ ($Re_Romaji2Kata) }{ $Romaji2Kata{lc $1} || $1 }msxgei;
  # step 3;
  $str =~ s{ ([ァ-ン])[mn] }{ "$1ン" }msxgei;
  $str;
}

sub romaji2hiragana{ katakana2hiragana(romaji2katakana(shift)) };

sub kana2romaji{
  my $str = shift;
  # step 1;
  $str =~ s{ ($Re_Kana2Romaji) }{ $Kana2Romaji{$1} || $1 }msxge;
  # step 2; ッta -> tta
  $str =~ s{ ッ($Re_Consonants) }{ "$1$1" }msxge;
  # step 3; oー -> oo
  $str =~ s{ ($Re_Vowels)ー }{ "$1$1" }msxge;
  $str;
}


if ($0 eq __FILE__){
    warn $USE_REGEXP_ASSEMBLE;
    binmode STDOUT, ':utf8';
    local $\ = "\n";
    warn $Re_Romaji2Kata;
    print romaji2katakana("Dan Kogai");
    print romaji2katakana("shimbashi");
    print romaji2hiragana("Dan Kogai");
    print romaji2hiragana("shimbashi");
    warn $Re_Kana2Romaji;
    print kana2romaji("ダンコガイ");
    print kana2romaji("マイッタ");
    print kana2romaji("シンバシ");
}

1; # End of Lingua::JA::Kana
__END__

=head1 NAME

Lingua::JA::Kana - The great new Lingua::JA::Kana!

=head1 VERSION

$Id$

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Lingua::JA::Kana;

    my $foo = Lingua::JA::Kana->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 FUNCTIONS

=head2 function1

=cut

sub function1 {
}

=head2 function2

=cut

sub function2 {
}

=head1 AUTHOR

Dan Kogai, C<< <dankogai at dan.co.jp> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-lingua-ja-kana at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Lingua-JA-Kana>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Lingua::JA::Kana


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Lingua-JA-Kana>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Lingua-JA-Kana>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Lingua-JA-Kana>

=item * Search CPAN

L<http://search.cpan.org/dist/Lingua-JA-Kana>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2007 Dan Kogai, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

