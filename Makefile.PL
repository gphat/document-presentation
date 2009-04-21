use inc::Module::Install;

name     'Document-Presentation';
all_from 'lib/Document/Presentation.pm';
author   'Cory G Watson <gphat@cpan.org>';

build_requires 'Test::More';

requires 'Document::Writer' => '0.9';
requires 'Graphics::Color' => '0.15';
requires 'Graphics::Primitive' => '0.33';
requires 'Layout::Manager' => '0.19';
requires 'Moose' => '0.57';


WriteAll;

