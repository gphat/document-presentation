package Document::Presentation;
use Moose;

extends 'Document::Writer';

our $AUTHORITY = 'gphat';
our $VERSION = '0.01';

has 'driver' => (
    is => 'ro',
    does => 'Graphics::Primitive::Driver'
);
has 'theme' => (
    is => 'ro',
    isa => 'Document::Presentation::Theme',
    required => 1
);
has 'height' => (
    is => 'rw',
    isa => 'Num',
);
has 'width' => (
    is => 'rw',
    isa => 'Num',
);
has 'first_slide' => (
    is => 'rw',
    isa => 'Bool',
    default => sub { 1 }
);

sub add_slide {
    my ($self, $name, $args) = @_;

    unless($name =~ /^\+/) {
        $name = "Document::Presentation::Theme::".$self->theme->name."::$name"
    }
    Class::MOP::load_class($name);
    my $slide = $name->new($args);

    my $page;
    if($self->first_slide) {
        $page = Document::Writer::Page->new(
            color   => Graphics::Color::RGB->new(red => 0, green => 0, blue => 0, alpha => 1),
            width   => $self->width,
            height  => $self->height,
        );
        $self->add_page_break($self->driver, $page);
    } else {
        $page = $self->add_page_break($self->driver);
    }
    $page = $slide->make_slide($page);

    $self->driver->prepare($page);
    if($page->can('layout_manager')) {
        $page->layout_manager->do_layout($page);
    }

    return $page;
}

__PACKAGE__->meta->make_immutable;
1;
=head1 NAME

Document::Presentation - The great new Document::Presentation!

=cut

=head1 SYNOPSIS

    use Document::Presentation;

    my $talk = Document::Presentation->new(theme => 'Stock', width => 1024, height => 768);
    $talk->add_slide('Title', { title => 'Test Talk' });
    ...

=head1 DESCRIPTION

C<Document::Presentation> is an object representation of the elements that
make up a slide-based presentation.  The idea is that you create a
C<Document::Presentation> object and repeatedly call C<add_slide> with
arguments.

The Theme allows you to use the same slides, but change up the look & feel.

It is expected that this won't be the method you use to actually U<write>
presentations, as that's somewhat cumbersome.  This can, instead, be a target
for other formats (parse them and then them into C<Document::Presentation>s).

=head1 METHODS

=head2 add_slide($theme_slide_name, { option1 => value })

Add a slide of C<$theme_slide_name> type to the Presentation.  The supplied
arguments are passed in when creating the Slide object.

=cut

=head1 AUTHOR

Cory G Watson, C<< <gphat at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-document-presentation at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Document-Presentation>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Document::Presentation


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Document-Presentation>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Document-Presentation>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Document-Presentation>

=item * Search CPAN

L<http://search.cpan.org/dist/Document-Presentation>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2008 Cory G Watson, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut
