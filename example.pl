use strict;
use warnings;

use Document::Presentation;
use Document::Presentation::Theme::Stock;
use Graphics::Primitive::Driver::CairoPango;

my $pres = Document::Presentation->new(
    theme => Document::Presentation::Theme::Stock->new,
    width => 1024,
    height => 768,
    driver => Graphics::Primitive::Driver::CairoPango->new(format => 'pdf')
);
$pres->add_slide('Title', { title => 'Test Talk', subtitle => 'Testing' });

$pres->draw($pres->driver);
$pres->driver->write('/Users/gphat/talk.pdf');
