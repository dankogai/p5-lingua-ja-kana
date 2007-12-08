#
# $Id: Makefile.PL,v 0.1 2007/12/08 11:04:08 dankogai Exp dankogai $
#
use 5.008001; # needs perl 5.8.1 or better
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Lingua::JA::Kana',
    AUTHOR              => 'Dan Kogai <dankogai@dan.co.jp>',
    VERSION_FROM        => 'lib/Lingua/JA/Kana.pm',
    ABSTRACT_FROM       => 'lib/Lingua/JA/Kana.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Lingua-JA-Kana-*' },
);
