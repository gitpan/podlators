# Makefile.PL for podlators.
# $Id: Makefile.PL,v 0.2 1999/07/29 15:32:08 eagle Exp $
use ExtUtils::MakeMaker;
WriteMakefile (
    NAME         => 'Pod',
    DISTNAME     => 'podlators',
    EXE_FILES    => [ 'scripts/pod2txt' ],
    ($] >= 5.005 ?
     (ABSTRACT   => 'Convert POD data to various other formats',
      AUTHOR     => 'Russ Allbery (rra@stanford.edu)') : ()),
    VERSION_FROM => 'VERSION',
    dist         => { COMPRESS => 'gzip', SUFFIX => 'gz' }
);
