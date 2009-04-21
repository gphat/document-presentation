package Document::Presentation::Theme::Stock;
use Moose;

extends 'Document::Presentation::Theme';

use Graphics::Color::RGB;

has '+name' => ( default => sub { 'Stock' } );

has '+footer_color' => (
    default => sub { Graphics::Color::RGB->new(red => 0, green => 0, blue => 0, alpha => 1)}
);
has '+header_color' => (
    default => sub { Graphics::Color::RGB->new(red => 0, green => 0, blue => 0, alpha => .25)}
);


__PACKAGE__->meta->make_immutable;

1;
__END__