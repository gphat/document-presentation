package Document::Presentation::Theme::Stock::Title;
use Moose;

with 'Document::Presentation::Slide';

use Graphics::Primitive::TextBox;
use Layout::Manager::Compass;
use Graphics::Color::RGB;

has 'title' => (
    is => 'rw',
    isa => 'Str',
    required => 1
);
has 'subtitle' => (
    is => 'rw',
    isa => 'Str',
    required => 1
);

sub make_slide {
    my ($self, $slide) = @_;

    my $gray = Graphics::Color::RGB->new(red => 0, green => 0, blue => 0, alpha => .5);
    my $black = Graphics::Color::RGB->new(red => 0, green => 0, blue => 0, alpha => 1);
    my $stfont = Graphics::Primitive::Font->new(
        family => 'Arial',
        size => 50
    );
    my $hrfont = Graphics::Primitive::Font->new(
        family => 'Arial',
        size => 50
    );
    my $sbfont = Graphics::Primitive::Font->new(
        family => 'Arial',
        size => 40
    );


    $slide->body->class('simple-slide');
    $slide->body->layout_manager(Layout::Manager::Compass->new);

    $slide->body->margins->top(40);

    $slide->body->margins->left(10);
    $slide->body->margins->right(10);

    # my $head = $slide->header;
    # $head->text($self->title);
    # $head->font($hrfont);
    # $head->horizontal_alignment('right');
    # $head->color($gray);
    # $head->padding(10);

    my $bhead = Graphics::Primitive::TextBox->new(
        color => $black,
        text => $self->title,
        font => $stfont,
        class => 'slide-head',
        horizontal_alignment => 'center',
        line_height => 85,
        minimum_width => -1
    );
    $slide->body->add_component($bhead, 'n');

    if(defined($self->subtitle)) {
        my $body = Graphics::Primitive::TextBox->new(
            color => $black,
            text => $self->subtitle,
            font => $sbfont,
            class => 'slide-body',
            line_height => 66,
            minimum_width => $slide->body->minimum_inside_width,
            indent => -35
        );

        $body->margins->left(50);
        $body->margins->right(50);
        $body->margins->top(60);
        $slide->body->add_component($body, 'c');
    }

    # if(defined($pagenum)) {
    #     my $foot = $slide->footer;
    #     $foot->border->top->width(2);
    #     $foot->border->top->color($gray);
    # 
    #     $foot->margins->right(10);
    #     $foot->margins->left(10);
    # 
    #     $foot->padding->top(10);
    #     $foot->text($pagenum);
    #     $foot->horizontal_alignment('center');
    #     $foot->font($footfont);
    #     $foot->class('slide-foot');
    #     $foot->margins->bottom(20);
    #     $foot->color($black);

    # }

    return $slide;
}

1;