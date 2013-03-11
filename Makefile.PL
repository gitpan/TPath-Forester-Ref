
use strict;
use warnings;

use 5.010000;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "TPath::Forester that understands Perl structs",
  "AUTHOR" => "David F. Houghton <dfhoughton\@gmail.com>",
  "BUILD_REQUIRES" => {
    "File::Find" => 0,
    "File::Temp" => 0,
    "List::MoreUtils" => 0,
    "Test::More" => "0.88",
    "strict" => 0,
    "warnings" => 0
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "TPath-Forester-Ref",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "TPath::Forester::Ref",
  "PREREQ_PM" => {
    "Moose" => 0,
    "Moose::Exporter" => 0,
    "Moose::Role" => 0,
    "Moose::Util" => 0,
    "MooseX::MethodAttributes" => 0,
    "Scalar::Util" => 0,
    "TPath::Expression" => 0,
    "TPath::Forester" => 0,
    "namespace::autoclean" => 0
  },
  "VERSION" => "0.001",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



