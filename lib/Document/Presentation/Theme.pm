package Document::Presentation::Theme;
use Moose;

use Graphics::Color;

has 'name' => (
    is => 'ro',
    isa => 'Str',
    required => 1
);

has 'footer_font' => (
    is => 'rw',
    isa => 'Graphics::Primitive::Font',
    default => sub { Graphics::Primitive::Font->new(size => 24) }
);
has 'footer_color' => (
    is => 'rw',
    isa => 'Graphics::Color',
);
has 'header_font' => (
    is => 'rw',
    isa => 'Graphics::Primitive::Font',
    default => sub { Graphics::Primitive::Font->new(size => 24) }
);
has 'header_color' => (
    is => 'rw',
    isa => 'Graphics::Color',
);


__PACKAGE__->meta->make_immutable;

1;
__END__