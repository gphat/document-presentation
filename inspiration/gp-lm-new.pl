use strict;
use utf8;

use Chart::Clicker;
use Chart::Clicker::Context;
use Chart::Clicker::Data::Series;
use Chart::Clicker::Data::DataSet;
use Chart::Clicker::Data::Marker;
use Chart::Clicker::Renderer::Area;
use Chart::Clicker::Renderer::Bar;
use Document::Writer;
use Forest;
use Forest::Tree::Writer::ASCIIWithBranches;
use Geometry::Primitive::Circle;
use Geometry::Primitive::Polygon;
use Graphics::Color::RGB;
use Graphics::Primitive::Font;
use Graphics::Primitive::Image;
use Graphics::Primitive::TextBox;
use Graphics::Primitive::Driver::Cairo;
use Graphics::Primitive::Driver::CairoPango;
use Graphics::Primitive::Operation::Fill;
use Graphics::Primitive::Operation::Stroke;
use Graphics::Primitive::Paint::Gradient::Linear;
use Graphics::Primitive::Paint::Gradient::Radial;
use Graphics::Primitive::Paint::Solid;
use Layout::Manager::Compass;

my $white = Graphics::Color::RGB->new(red => 1, green => 1, blue => 1, alpha => 1);
my $black = Graphics::Color::RGB->new(red => 0, green => 0, blue => 0, alpha => 1);
my $gray = Graphics::Color::RGB->new(red => 0, green => 0, blue => 0, alpha => .25);
my $darkgray = Graphics::Color::RGB->new(red => 0, green => 0, blue => 0, alpha => .5);

my $red = Graphics::Color::RGB->new(red => 1, green => 0, blue => 0, alpha => 1);
my $darkred = Graphics::Color::RGB->new(red => .5, green => 0, blue => 0, alpha => 1);
my $orange = Graphics::Color::RGB->new(red => 1, green => .54, blue => 0, alpha => 1);
my $yellow = Graphics::Color::RGB->new(red => 1, green => 1, blue => 0, alpha => 1);
my $blue = Graphics::Color::RGB->new(red => 0, green => 0, blue => 1, alpha => 1);
my $otherblue = Graphics::Color::RGB->new( red => .44, green => .63, blue => .76, alpha => 1);
my $green = Graphics::Color::RGB->new(red => 0, green => 1, blue => 0, alpha => 1);
my $indigo = Graphics::Color::RGB->new(red => .29, green => 0, blue => .50, alpha => .5);
my $violet = Graphics::Color::RGB->new(red => .93, green => .50, blue => .93, alpha => .5);

my $doc = Document::Writer->new;
my $driver = Graphics::Primitive::Driver::CairoPango->new(format => 'pdf');

my $page = Document::Writer::Page->new(color => $black, width => 1024, height => 768);
$doc->add_page_break($driver, $page);

my $hrfont = Graphics::Primitive::Font->new(
    size => 26,
    family => 'Palatino',
    slant => 'italic'
);
my $hfont = Graphics::Primitive::Font->new(
    size => 110,
    family => 'Palatino'
);
my $shfont = Graphics::Primitive::Font->new(
    size => 42,
    family => 'Gill Sans'
);
my $stfont = Graphics::Primitive::Font->new(
    size => 84,
    family => 'Palatino'
);
my $sbfont = Graphics::Primitive::Font->new(
    size => 55,
    family => 'Gill Sans'
);
my $codefont = Graphics::Primitive::Font->new(
    size => 34,
    family => 'Monaco'
);

my $footfont = Graphics::Primitive::Font->new(
    size => 26,
    family => 'Georgia'
);

my $pagenum = 0;

$page->body->layout_manager(Layout::Manager::Compass->new);

my $tb = Graphics::Primitive::TextBox->new(
    color => $black,
    text => "<span font_desc=\"Palatino 89\">Introduction to</span> Graphics::Primitive",
    # text => 'to',
    font => $hfont,
    horizontal_alignment => 'center',
    # vertical_alignment => 'bottom',
    class => 'talk-title',
    minimum_width => $page->body->inside_width
);
my $cont = Graphics::Primitive::Container->new;
$cont->layout_manager(Layout::Manager::Compass->new);
$cont->add_component($tb, 's');
my $tb2 = Graphics::Primitive::TextBox->new(
    class => 'talk-subtitle',
    color => $black,
    text => 'Documents, Graphics, Charts and More',
    font => $shfont,
    horizontal_alignment => 'center',
    minimum_width => $page->body->inside_width
);
$page->body->add_component($cont, 'c');
$page->body->add_component($tb2, 'c');

make_simple_slide(
    "Cory G Watson: ‘gphat’",
"• Infinity Interactive - iinteractive.com
• Catalyst, DBIx::Class, Chart::Clicker
• http://www.onemogin.com/blog",
++$pagenum
);

# make_simple_slide(
#     'Southern Primer',
#     '• s/y’?all/you guys/gi
# • s/figgered/thought that/g
# • s/cain’?t/can not/g; s/ain’?t/am not/g
# • s/bard/borrowed/g
# • s/fokes/people/gi
# • s/gone do/going to do/g',
# ++$pagenum
# );

make_simple_slide(
    'Goals',
    '• document creation
• output agnostic
• reusable
• embeddable',
++$pagenum
);

make_simple_slide(
    'What Is It?',
    '• scene graph
• intermediary representation
• graphics toolkit',
++$pagenum
);

make_major_slide(
    'What can it do?',
++$pagenum
);
make_major_slide(
    'Make <b>this</b> presentation.',
++$pagenum
);
make_canvas_slide('Graphics Toolkit', ++$pagenum);
make_image_slide(
    "Implement Old Formats", 'rip.png', [ 1, 1 ], ++$pagenum, 'RIP converter (by Brian Cassidy)'
);
make_page_slide(
    ++$pagenum
);
make_simple_chart_slide(
    "Charts", ++$pagenum
);
make_chart_slide(
    "Fancier Charts", ++$pagenum
);
make_image_slide(
    "Javascript Canvas", 'canvas.png', [ .8, .8 ], ++$pagenum, 'JSCanvas (by Cosmin Budrica)'
);
make_image_slide(
    "Catalyst View", 'cat-view.png', undef, ++$pagenum, 'Catalyst::View::Graphics::Primitive'
);
make_simple_slide(
    'Laying The Foundation',
    '• Graphics::Color
• Geometry::Primitive
• Graphics::Primitive
• Layout::Manager',
++$pagenum
);
make_simple_slide(
    'Graphics::Color',
'• RGB, CMYK, etc
• <span font_desc="Monaco 42">isa => \'Graphics::Color\'</span>',
++$pagenum
);
make_simple_slide(
    'Geometry::Primitive',
'• Common entities: <span font_desc="Monaco 42">Arc, Bezier, Circle, Line, Point, Polygon, Rectangle</span>
• Scaling, start <span font_desc="Georgia">&amp;</span> end points, etc',
++$pagenum
);
make_simple_slide(
    "Geometry::Primitive\n(example)",
    '<span font_desc="Monaco 35">$r = Geometry::Primitive::Rectangle->new(
    origin => [0, 0],
    width => 100,
    height => 100
);</span>',
++$pagenum
);
make_simple_slide(
    'Graphics::Primitive',
'• Marry styling to Geometry primitives.
• Border, Brush, Font, Insets
• Drawing',
++$pagenum
);
make_image_slide(
    "Scene Graph", 'graph.png', [ .93, .93 ], ++$pagenum
);
make_simple_slide(
    "Graphics::Primitive\nComponent",
'• Margins, Border <span font_desc="Georgia">&amp;</span> Padding
• CSS Box Model
• <span font_desc="Monaco 42">origin, width, height, color, background_color</span>',
++$pagenum
);
make_simple_slide(
    "Graphics::Primitive\nContainer",
'• Extends Component
• <span font_desc="Monaco 42">has \'components\'</span>
• <span font_desc="Monaco 42">has \'layout_manager\'</span> (more on this later)',
++$pagenum
);
make_image_slide(
    "Intermediary Representation", 'tree-dump.png', [.8, .8], ++$pagenum
);
make_simple_slide(
    "Graphics::Primitive\nPath",
'• Series of Primitives (e.g. <span font_desc="Monaco 42">Line</span>, <span font_desc="Monaco 42">Circle</span>)
• Drawing methods: (e.g. <span font_desc="Monaco 42">line_to</span>, <span font_desc="Monaco 42">curve_to</span>)',
++$pagenum
);
make_simple_slide(
    "Graphics::Primitive\nCanvas",
'• Component with a Path
• <span font_desc="Monaco 42">save</span> <span font_desc="Georgia">&amp;</span> <span font_desc="Monaco 42">restore</span>
• Operations: <span font_desc="Monaco 42">Fill</span>, <span font_desc="Monaco 42">Stroke</span>',
++$pagenum
);
make_simple_slide(
"Graphics::Primitive\nDriver",
'• Crawls scene
• Turns IR into code
• Moose Role',
++$pagenum
);
make_simple_slide(
    "Graphics::Primitive\nLifecycle",
'<span font_desc="Monaco 42">$driver->prepare($comp);
$driver->finalize($comp);
$driver->draw($comp);
$driver->write($filename);</span>',
++$pagenum
);
make_simple_slide(
    "Layout::Manager",
'• Sizes <span font_desc="Georgia">&amp;</span> positions components in a container.
• Can be nested.  Containers in containers.',
++$pagenum
);
# make_simple_slide(
#     "Layout::Manager\nImplementations",
# '• Absolute
# • Axis
# • Compass
# • Flow
# • Single',
# ++$pagenum
# );
# make_lm_demo_slide(
#     "Layout::Manager\nCompass", ++$pagenum
# );
# make_simple_slide(
#     'LM LUVS GP',
# '<span font_desc="Monaco 40">my $c = Graphics::Primitive::Container->new;
# ...
# $c->add_component(
#   $comp, $constraints
# );</span>',
# ++$pagenum
# );
# make_simple_slide(
#     "LM LUVS GP",
# '<span font_desc="Monaco 40">$d->prepare($c);
# $lm = Layout::Manager::Compass->new;
# $lm->do_layout($c)</span>',
# ++$pagenum
# );
# make_simple_slide(
#     "LM LUVS GP",
# '<span font_desc="Monaco 42">$d->finalize($c);
# $d->draw($c);
# $d->write($filename);</span>',
# ++$pagenum
# );
make_simple_slide(
    "Things I Didn't Mention",
'• MooseX::Storage: Fully Serializable
• Cairo, Cairo+Pango, JSCanvas
• Driver hinting: per-driver optimizations
• <span font_desc="Monaco 42">$container->find(...)->each(...)</span>',
++$pagenum
);

make_simple_slide(
    "Future Work",
'• Transformations?
• More page layout.
• Make more drivers
• Converters!
• More features...',
++$pagenum
);

make_simple_slide(
    "Thanks!",
'Email: <span font_desc="Monaco 30">gphat@cpan.org</span>
IRC: <span font_desc="Monaco 30">irc.perl.org, #graphics-primitive</span>

<span font_desc="Monaco 30">http://search.cpan.org/perldoc?Graphics::Primitive</span>',
++$pagenum, 'center'
);

my $pages = $doc->draw($driver);
$driver->write('/Users/gphat/talk.pdf');

# foreach my $p (@{ $pages }) {
#     my $w = Forest::Tree::Writer::ASCIIWithBranches->new(tree => $p->get_tree);
#     print $w->as_string;
# }


# my $w = Forest::Tree::Writer::ASCIIWithBranches->new(tree => $doc->get_tree);
# print $w->as_string;


sub make_simple_slide {
    my ($header, $text, $pagenum, $bodyalign) = @_;

    my $slide = $doc->add_page_break($driver);
    $slide->body->class('simple-slide');
    $slide->body->layout_manager(Layout::Manager::Compass->new);

    $slide->body->margins->top(40);

    $slide->body->margins->left(10);
    $slide->body->margins->right(10);

    my $head = $slide->header;
    $head->text('Introduction to Graphics::Primitive');
    $head->font($hrfont);
    $head->horizontal_alignment('right');
    $head->color($gray);
    $head->padding(10);

    my $bhead = Graphics::Primitive::TextBox->new(
        color => $black,
        text => $header,
        font => $stfont,
        class => 'slide-head',
        horizontal_alignment => 'center',
        line_height => 85,
        minimum_width => -1
    );

    my $body = Graphics::Primitive::TextBox->new(
        color => $black,
        text => $text,
        font => $sbfont,
        class => 'slide-body',
        line_height => 66,
        minimum_width => $slide->body->minimum_inside_width,
        indent => -35
    );
    if(defined($bodyalign)) {
        $body->horizontal_alignment($bodyalign);
    }

    $body->margins->left(50);
    $body->margins->right(50);
    $body->margins->top(40);

    if(defined($pagenum)) {
        my $foot = $slide->footer;
        $foot->border->top->width(2);
        $foot->border->top->color($gray);

        $foot->margins->right(10);
        $foot->margins->left(10);

        $foot->padding->top(10);
        $foot->text($pagenum);
        $foot->horizontal_alignment('center');
        $foot->font($footfont);
        $foot->class('slide-foot');
        $foot->margins->bottom(20);
        $foot->color($black);
    }

    $slide->body->add_component($bhead, 'n');
    $slide->body->add_component($body, 'c');

    $driver->prepare($slide);
    $slide->layout_manager->do_layout($slide);

    return $slide;
}

sub make_major_slide {
    my ($header, $pagenum) = @_;

    my $slide = $doc->add_page_break($driver);
    $slide->body->class('simple-slide');
    $slide->body->layout_manager(Layout::Manager::Compass->new);

    $slide->body->margins->left(10);
    $slide->body->margins->right(10);

    my $head = $slide->header;
    $head->text('Introduction to Graphics::Primitive');
    $head->font($hrfont);
    $head->horizontal_alignment('right');
    $head->color($gray);
    $head->padding(10);

    my $bhead = Graphics::Primitive::TextBox->new(
        color => $black,
        text => $header,
        font => $stfont,
        class => 'slide-head',
        horizontal_alignment => 'center',
		vertical_alignment => 'center',
        line_height => 80,
        minimum_width => -1
    );

    if(defined($pagenum)) {
        my $foot = $slide->footer;
        $foot->border->top->width(2);
        $foot->border->top->color($gray);

        $foot->margins->right(10);
        $foot->margins->left(10);

        $foot->padding->top(10);
        $foot->text($pagenum);
        $foot->horizontal_alignment('center');
        $foot->font($footfont);
        $foot->class('slide-foot');
        $foot->margins->bottom(20);
        $foot->color($black);
    }

    $slide->body->add_component($bhead, 'c');

    return $slide;
}

sub make_page_slide {
    my ($pagenum) = @_;

    my $slide = $doc->add_page_break($driver);
    $slide->body->class('simple-slide');
    $slide->body->layout_manager(Layout::Manager::Compass->new);

    $slide->body->margins->left(10);
    $slide->body->margins->right(10);

    my $head = $slide->header;
    $head->text('Introduction to Graphics::Primitive');
    $head->font($hrfont);
    $head->horizontal_alignment('right');
    $head->color($gray);
    $head->padding(10);

    my $bhead = Graphics::Primitive::TextBox->new(
        color => $black,
        text => 'Fancy Page Layout',
        font => $stfont,
        class => 'slide-head',
        horizontal_alignment => 'center',
        vertical_alignment => 'center',
        line_height => 80,
        minimum_width => -1
    );

    my $cont = Graphics::Primitive::Container->new;
    $cont->layout_manager(Layout::Manager::Compass->new);
    $cont->minimum_width($slide->body->minimum_inside_width);
    $cont->margins->left(60);

    my $page1 = Graphics::Primitive::Container->new( minimum_width => 300, name => 'woot!');
    $page1->layout_manager(Layout::Manager::Flow->new(anchor => 'north'));
    my $tb = Graphics::Primitive::TextBox->new(
        color => $black,
        minimum_width => 300,
        text => '<span font_desc="Palatino 40">Page One</span>',
        horizontal_alignment => 'center'
    );
    my $tb_text = Graphics::Primitive::TextBox->new(
        color => $black,
        indent => 15,
        minimum_width => 300,
        text => '<span font_desc="Gill Sans 15">Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. <b>Ut enim ad minim veniam</b>, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. <span color="red">Duis aute irure</span> dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</span>',
    );

    my $tb_text2 = Graphics::Primitive::TextBox->new(
        color => $darkgray,
        minimum_width => 300,
        text => '<span font_desc="Gill Sans Italic 15">Sed ut perspiciatis unde omnis iste natus error sit <s>voluptatem accusantium doloremque</s> laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.</span>',
    );
    $tb_text2->padding(10);
    # $tb_text2->padding->top(10);
    # $tb_text2->padding->left(10);
    # $tb_text2->padding->right(10);
    my $tb_text3 = Graphics::Primitive::TextBox->new(
        color => $black,
        indent => -15,
        minimum_width => 300,
        text => '<span font_desc="Gill Sans 15">Neque porro quisquam est, qui <u>dolorem ipsum quia</u> dolor sit amet, consectetur, <span color="green">adipisci velit</span>, sed quia non numquam eius modi<sup>*</sup> tempora incidunt<sub>32</sub> ut labore et dolore magnam aliquam quaerat.</span>',
    );

    $page1->add_component($tb);
    $page1->add_component($tb_text);
    $page1->add_component($tb_text2);
    $page1->add_component($tb_text3);

    $page1->padding(15);
    $page1->padding->top(0);
    # $page1->border->width(2);
    # $page1->border->color($black);
    $page1->margins->left(15);
    $page1->margins->bottom(15);
    $page1->margins->right(15);
    $page1->margins->top(15);
    $cont->add_component($page1, 'w');

    my $page2 = Graphics::Primitive::Container->new( minimum_width => 300);
    $page2->layout_manager(Layout::Manager::Flow->new);
    my $tb2 = Graphics::Primitive::TextBox->new(
        color => $black,
        minimum_width => 300,
        text => '<span font_desc="Palatino 40">Page Two</span>',
        horizontal_alignment => 'center'
    );
    $page2->add_component($tb2, 'n');

    my $tb2_text1 = Graphics::Primitive::TextBox->new(
        color => $black,
        # direction => 'rtl',
        font => Graphics::Primitive::Font->new(
            #family => 'Mshtakan',
            family => 'Arial Hebrew',
            size => 15
        ),
        # text => 'sdasd'
        text => "רעידת אדמה (או רעש אדמה) היא תופעת טבע גאולוגית שלא ניתנת לחיזוי לטווח הארוך (לפחות על פי המדע היום), המתרחשת לרוב בקרבת החיבורים שבין הלוחות הטקטוניים, והקשורה לתופעת נדידת היבשות. בעת רעידת אדמה משתחרר לחץ בין הלוחות הטקטוניים, ופני הקרקע רועדים במשך זמן קצר"
        #text => "Տարբեր ժամանակաշրջաններում երկրաշարժերի առաջացումը բացատրվել է տվյալ ժամանակներում ընդունված պատկերացումների համաձայն և հիմնականում կապվել է տարատեսակ կենդանիների շարժումների հետ",
    );

    my $tb2_text2 = Graphics::Primitive::TextBox->new(
        color => $black,
        minimum_width => 300,
        text => "<span font_desc=\"STKaiti 15\">とは、普段は固着している地下の岩盤が、一定の部分を境目にして、急にずれ動くこと。また、それによって引き起こされる地面の振動。正確には、前者を「地震（じしん」と呼び、後者を「地震動（じしんどう」という。一般にはどちらも地震と呼ぶ。通常は地震というと地震動を意味することが多い。</span>"
    );
    $tb2_text2->padding->top(15);

    my $tb2_text3 = Graphics::Primitive::TextBox->new(
        color => $black,
        text => "<span font_desc=\"Charcoal CY 14\">подземные удары и колебания поверхности Земли, вызванные естественными причинами (главным образом тектоническими процессами) или искусственными процессами (взрывы, заполнение водохранилищ, обрушением подземных полостей горных выработок).</span>"
    );
    $tb2_text3->padding->top(10);

    $page2->padding(15);
    $page2->padding->top(0);
    # $page2->border->width(2);
    # $page2->border->color($black);
    $page2->margins(15);
    $page2->margins->left(0);

    $page2->add_component($tb2_text1);
    $page2->add_component($tb2_text2);
    $page2->add_component($tb2_text3);

    $cont->add_component($page2, 'w');

    my $page3 = Graphics::Primitive::Container->new( minimum_width => 300);
    $page3->layout_manager(Layout::Manager::Flow->new(anchor => 'north'));
    my $tb3 = Graphics::Primitive::TextBox->new(
        color => $black,
        minimum_width => 300,
        text => '<span font_desc="Palatino 40">Page Three</span>',
        horizontal_alignment => 'center'
    );
    $page3->add_component($tb3);

    my $tb3_text1 = Graphics::Primitive::TextBox->new(
        color => $black,
        text => "<span font_desc=\"Gill Sans 15\">Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.</span>",
        justify => 1
    );
    # $tb3_text1->padding->top(10);

    my $tb3_text2 = Graphics::Primitive::TextBox->new(
        color => $black,
        text => "<span font_desc=\"Gill Sans 15\">Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt.</span>",
        horizontal_alignment => 'right'
    );
    $tb3_text2->padding->top(10);

    my $tb3_text3 = Graphics::Primitive::TextBox->new(
        color => $black,
        text => "<span font_desc=\"Gill Sans 15\">Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.</span>",
        horizontal_alignment => 'center'
    );
    $tb3_text3->padding->top(10);

    my $tb3_text4 = Graphics::Primitive::TextBox->new(
        color => $black,
        text => "<span font_desc=\"Gill Sans 15\">Ut</span> <span font_desc=\"Gill Sans 18\">enim</span> <span font_desc=\"Gill Sans 20\">ad</span> <span font_desc=\"Gill Sans 25\">minima veniam, </span><span font_desc=\"Academy Engraved LET 18\">quis nostrum</span><span font_desc=\"Futura 15\"> exercitationem ullam corporis suscipit laboriosam,</span><span font_desc=\"Bodoni Ornaments ITC TT\"> nisi</span><span font_desc=\"Cochin 15\"> ut aliquid ex ea commodi consequatur?</span><span font_desc=\"Cracked 15\">Excepteur sint occaecat cupidatat non proident,</span><span font_desc=\"Especial Kay 15\"> sunt in culpa qui officia deserunt mollit anim id est laborum.</span>",
    );
    $tb3_text4->padding->top(10);

    $page3->padding(15);
    $page3->padding->top(0);
    # $page3->border->width(2);
    # $page3->border->color($black);
    $page3->margins->bottom(15);
    $page3->margins->right(15);
    $page3->margins->top(15);

    $page3->add_component($tb3_text1);
    $page3->add_component($tb3_text2);
    $page3->add_component($tb3_text3);
    $page3->add_component($tb3_text4);

    $cont->add_component($page3, 'w');

    if(defined($pagenum)) {
        my $foot = $slide->footer;
        $foot->border->top->width(2);
        $foot->border->top->color($gray);

        $foot->margins->right(10);
        $foot->margins->left(10);

        $foot->padding->top(10);
        $foot->text($pagenum);
        $foot->horizontal_alignment('center');
        $foot->font($footfont);
        $foot->class('slide-foot');
        $foot->margins->bottom(20);
        $foot->color($black);
    }

    $slide->body->add_component($bhead, 'n');
    $slide->body->add_component($cont, 'c');

    return $slide;
}

sub make_lm_demo_slide {
    my ($header, $pagenum) = @_;

    my $slide = $doc->add_page_break($driver);
    $slide->body->class('simple-slide');
    $slide->body->layout_manager(Layout::Manager::Compass->new);

    my $head = $slide->header;
    $head->text('Introduction to Graphics::Primitive');
    $head->font($hrfont);
    $head->horizontal_alignment('right');
    $head->color($gray);
    $head->padding(10);

    my $bhead = Graphics::Primitive::TextBox->new(
        color => $black,
        text => $header,
        font => $stfont,
        class => 'slide-head',
        horizontal_alignment => 'center',
        line_height => 80,
        minimum_width => $slide->body->minimum_inside_width
    );

    my $body = Graphics::Primitive::Container->new(
        layout_manager => Layout::Manager::Compass->new
    );
    my $n = Graphics::Primitive::TextBox->new(
        color => $black,
        text => 'North',
        font => $codefont,
        horizontal_alignment => 'center',
        vertical_alignment => 'center',
        line_height => 60
    );
    my $s = Graphics::Primitive::TextBox->new(
        color => $black,
        text => 'South',
        font => $codefont,
        horizontal_alignment => 'center',
        vertical_alignment => 'center',
        line_height => 60
    );
    my $e = Graphics::Primitive::TextBox->new(
        color => $black,
        text => 'East',
        font => $codefont,
        horizontal_alignment => 'center',
        vertical_alignment => 'center',
        line_height => 60
    );
    my $w = Graphics::Primitive::TextBox->new(
        color => $black,
        text => 'West',
        font => $codefont,
        horizontal_alignment => 'center',
        vertical_alignment => 'center',
        line_height => 60
    );
    my $c = Graphics::Primitive::TextBox->new(
        color => $black,
        text => 'Center',
        font => $codefont,
        horizontal_alignment => 'center',
        vertical_alignment => 'center',
        line_height => 60
    );

    $body->add_component($n, 'n');
    $body->add_component($s, 's');
    $body->add_component($e, 'e');
    $body->add_component($w, 'w');
    $body->add_component($c, 'c');

    $body->find(sub { 1; })->each(sub {
        my ($comp, $const) = @_;
        $comp->border->color($black);
        $comp->border->width(2);
        my @foo = (5, 15);
        $comp->border->dash_pattern(\@foo);
        $comp->padding(5);
    });

    $c->border->width(0);
    $e->border->top->width(0);
    $w->border->top->width(0);
    $e->border->bottom->width(0);
    $w->border->bottom->width(0);

    $body->margins->left(70);
    $body->margins->right(70);
    $body->margins->top(60);
    $body->margins->bottom(40);

    if(defined($pagenum)) {
        my $foot = $slide->footer;
        $foot->border->top->width(2);
        $foot->border->top->color($gray);

        $foot->margins->right(10);
        $foot->margins->left(10);

        $foot->padding->top(10);
        $foot->text($pagenum);
        $foot->horizontal_alignment('center');
        $foot->font($footfont);
        $foot->class('slide-foot');
        $foot->margins->bottom(20);
        $foot->color($black);
    }

    $slide->body->margins->top(40);

    $slide->body->margins->left(10);
    $slide->body->margins->right(10);

    $slide->body->add_component($bhead, 'n');
    $slide->body->add_component($body, 'c');

    return $slide;
}

sub make_image_slide {
    my ($header, $image, $scale, $pagenum, $note) = @_;

    my $slide = $doc->add_page_break($driver);
    $slide->body->class('image-slide');
    $slide->body->layout_manager(Layout::Manager::Compass->new);

    my $head = $slide->header;
    $head->text('Introduction to Graphics::Primitive');
    $head->font($hrfont);
    $head->horizontal_alignment('right');
    $head->color($gray);
    $head->padding(10);

    my $bhead = Graphics::Primitive::TextBox->new(
        color => $black,
        text => $header,
        font => $stfont,
        class => 'slide-head',
        horizontal_alignment => 'center',
        minimum_width => $slide->body->minimum_inside_width,
        # line_height => 80
    );

    my $body = Graphics::Primitive::Image->new(
        image => $image,
        horizontal_alignment => 'center',
        vertical_alignment => 'center',
    );
    if(defined($scale)) {
        $body->scale($scale);
    }

    $body->margins->left(50);
    $body->margins->right(50);
    $body->margins->top(15);

    if(defined($pagenum)) {
        my $foot = $slide->footer;
        $foot->border->top->width(2);
        $foot->border->top->color($gray);

        $foot->margins->right(10);
        $foot->margins->left(10);

        $foot->padding->top(10);
        $foot->text($pagenum);
        $foot->horizontal_alignment('center');
        $foot->font($footfont);
        $foot->class('slide-foot');
        $foot->margins->bottom(20);
        $foot->color($black);
    }

    $slide->body->margins->top(40);

    $slide->body->margins->left(10);
    $slide->body->margins->right(10);

    $slide->body->add_component($bhead, 'n');
    $slide->body->add_component($body, 'c');

    if(defined($note)) {
        my $notec = Graphics::Primitive::TextBox->new(
            color => $black,
            text => $note,
            font => $sbfont,
            class => 'slide-body',
            horizontal_alignment => 'center',
            line_height => 66,
            minimum_width => $slide->body->minimum_inside_width,
            indent => -35
        );

        $notec->margins->left(50);
        $notec->margins->right(50);
        $notec->margins->top(10);
        $notec->margins->bottom(10);
        $slide->body->add_component($notec, 's');
    }

    return $slide;
}

sub make_canvas_slide {
    my ($header, $pagenum) = @_;

    my $slide = $doc->add_page_break($driver);
    $slide->body->class('canvas-slide');
    $slide->body->layout_manager(Layout::Manager::Compass->new);

    my $head = $slide->header;
    $head->text('Introduction to Graphics::Primitive');
    $head->font($hrfont);
    $head->horizontal_alignment('right');
    $head->color($gray);
    $head->padding(10);

    my $bhead = Graphics::Primitive::TextBox->new(
        color => $black,
        text => $header,
        font => $stfont,
        class => 'slide-head',
        horizontal_alignment => 'center',
        line_height => 80,
        minimum_width => $slide->body->minimum_inside_width
    );

    my $body = Graphics::Primitive::Canvas->new;

    $body->move_to(0, 0);
    $body->rectangle(1024, 768);

    my $backgrad = Graphics::Primitive::Paint::Gradient::Linear->new(
        line => Geometry::Primitive::Line->new(
            start => Geometry::Primitive::Point->new(x => 512, y => 0),
            end => Geometry::Primitive::Point->new(x => 512, y => 768),
        ),
    );
    $backgrad->add_stop(0.0, $white);
    $backgrad->add_stop(1, $gray);
    my $backop = Graphics::Primitive::Operation::Fill->new(
        paint => $backgrad
    );
    $body->do($backop);

    $body->path->move_to(100, 300);
    $body->path->ellipse(150, 90, 1);

    my $afillop = Graphics::Primitive::Operation::Fill->new(
        paint => Graphics::Primitive::Paint::Solid->new,
        preserve => 1
    );
    $afillop->paint->color($otherblue);

    my $astrokeop = Graphics::Primitive::Operation::Stroke->new;
    $astrokeop->brush->width(2);
    $astrokeop->brush->color($black);

    $body->do($afillop);
    $body->do($astrokeop);

    $body->path->move_to(500, 500);
    $body->path->arc(300, 0, 6.28, 1);

    my $grad = Graphics::Primitive::Paint::Gradient::Radial->new(
        start => Geometry::Primitive::Circle->new(
            origin => [419, 344],
            radius => 50
        ),
        end => Geometry::Primitive::Circle->new(
            origin => [540, 444],
            radius => 300
        ),
    );
    $grad->add_stop(0.0, $orange);
    $grad->add_stop(.5, $red);
    $grad->add_stop(1, $darkred);
    my $gradop = Graphics::Primitive::Operation::Fill->new(paint => $grad);
    $body->do($gradop);

    $body->path->move_to(725,50);
    $body->path->rectangle(150, 150);

    my $fillop = Graphics::Primitive::Operation::Fill->new(
        paint => Graphics::Primitive::Paint::Solid->new,
        preserve => 1
    );
    $fillop->paint->color($orange);

    my $strokeop = Graphics::Primitive::Operation::Stroke->new;
    $strokeop->brush->width(15);
    $strokeop->brush->color($black);
    $strokeop->brush->line_cap('round');

    $body->do($fillop);
    $body->do($strokeop);

    $body->path->move_to(350, 50);
    $body->arc(50, 0, 3.14, 1);
    $body->close_path;
    my $fillop2 = $fillop->clone;
    $fillop2->paint->color($green);
    my $strokeop2 = $strokeop->clone;
    $strokeop2->brush->width(5);
    $strokeop2->brush->line_join('round');
    $body->do($fillop2);
    $body->do($strokeop2);

    $body->path->move_to(475, 100);
    $body->path->line_to(525, 175);
    $body->path->line_to(575, 50);
    my $strokeop3 = $strokeop->clone;
    $strokeop3->brush->color($blue);
    $strokeop3->brush->line_join('bevel');
    $body->do($strokeop3);

    $body->path->move_to(80, 80);
    $body->path->curve_to(
        [300, 400],
        [400, 100],
        [300, 200]
    );
    $body->do($strokeop);

    my $poly = Geometry::Primitive::Polygon->new;
    $poly->add_point(Geometry::Primitive::Point->new(x => 850, y => 300));
    $poly->add_point(Geometry::Primitive::Point->new(x => 900, y => 300));
    $poly->add_point(Geometry::Primitive::Point->new(x => 900, y => 350));
    $poly->add_point(Geometry::Primitive::Point->new(x => 930, y => 350));
    $poly->add_point(Geometry::Primitive::Point->new(x => 930, y => 370));
    $poly->add_point(Geometry::Primitive::Point->new(x => 900, y => 370));
    $poly->add_point(Geometry::Primitive::Point->new(x => 850, y => 350));
    $body->path->add_primitive($poly);
    my $strokeop4 = $strokeop3->clone;
    $strokeop4->brush->color($indigo);
    $strokeop4->brush->width(8);
    $body->do($strokeop4);

    my $poly = Geometry::Primitive::Polygon->new;
    $poly->add_point(Geometry::Primitive::Point->new(x => 805, y => 370));
    $poly->add_point(Geometry::Primitive::Point->new(x => 900, y => 300));
    $poly->add_point(Geometry::Primitive::Point->new(x => 930, y => 350));
    $body->path->add_primitive($poly);
    my $strokeop5 = $strokeop4->clone;
    $strokeop4->brush->color($violet);
    $body->do($strokeop5);


    $body->margins->left(50);
    $body->margins->right(50);
    $body->margins->top(15);

    if(defined($pagenum)) {
        my $foot = $slide->footer;
        $foot->border->top->width(2);
        $foot->border->top->color($gray);

        $foot->margins->right(10);
        $foot->margins->left(10);

        $foot->padding->top(10);
        $foot->text($pagenum);
        $foot->horizontal_alignment('center');
        $foot->font($footfont);
        $foot->class('slide-foot');
        $foot->margins->bottom(20);
        $foot->color($black);
    }

    $slide->body->margins->top(40);

    $slide->body->margins->left(10);
    $slide->body->margins->right(10);

    $slide->body->add_component($bhead, 'n');
    $slide->body->add_component($body, 'c');

    return $slide;
}

sub make_simple_chart_slide {
    my ($header, $pagenum) = @_;

    my $slide = $doc->add_page_break($driver);
    $slide->body->class('simple-slide');
    $slide->body->layout_manager(Layout::Manager::Compass->new);

    my $head = $slide->header;
    $head->text('Introduction to Graphics::Primitive');
    $head->font($hrfont);
    $head->horizontal_alignment('right');
    $head->color($gray);
    $head->padding(10);

    my $bhead = Graphics::Primitive::TextBox->new(
        color => $black,
        text => $header,
        font => $stfont,
        class => 'slide-head',
        horizontal_alignment => 'center',
        line_height => 80
    );

    my $body = Chart::Clicker->new;

    my $series = Chart::Clicker::Data::Series->new(
        keys    => [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ],
        values  => [ 42, 25, 86, 23, 2, 19, 103, 12, 54, 9 ],
    );

    my $series2 = Chart::Clicker::Data::Series->new(
        keys    => [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ],
        values  => [ 67, 15, 6, 90, 11, 45, 83, 11, 9, 101 ],
    );

    my $ds = Chart::Clicker::Data::DataSet->new(series => [ $series, $series2 ]);

    $body->add_to_datasets($ds);

    $body->margins->left(70);
    $body->margins->right(70);
    $body->margins->top(60);
    $body->margins->bottom(20);
    $body->legend->visible(0);
    $body->get_context('default')->domain_axis->visible(0);
    $body->get_context('default')->range_axis->font->family('Georgia');
    $body->get_context('default')->range_axis->font->size(20);
    $body->border->width(0);
    $body->plot->grid->background_color($white);

    if(defined($pagenum)) {
        my $foot = $slide->footer;
        $foot->border->top->width(2);
        $foot->border->top->color($gray);

        $foot->margins->right(10);
        $foot->margins->left(10);

        $foot->padding->top(10);
        $foot->text($pagenum);
        $foot->horizontal_alignment('center');
        $foot->font($footfont);
        $foot->class('slide-foot');
        $foot->margins->bottom(20);
        $foot->color($black);
    }

    $slide->body->margins->top(10);

    $slide->body->margins->left(10);
    $slide->body->margins->right(10);

    my $note = Graphics::Primitive::TextBox->new(
        color => $black,
        text => 'Chart::Clicker',
        font => $sbfont,
        class => 'slide-body',
        horizontal_alignment => 'center',
        line_height => 66,
        minimum_width => $slide->body->minimum_inside_width,
        indent => -35
    );

    $note->margins->left(50);
    $note->margins->right(50);
    $note->margins->top(10);

    $slide->body->add_component($bhead, 'n');
    $slide->body->add_component($body, 'c');
    $slide->body->add_component($note, 's');

    return $slide;
}

sub make_chart_slide {
    my ($header, $pagenum) = @_;

    my $slide = $doc->add_page_break($driver);
    $slide->body->class('simple-slide');
    $slide->body->layout_manager(Layout::Manager::Compass->new);

    my $head = $slide->header;
    $head->text('Introduction to Graphics::Primitive');
    $head->font($hrfont);
    $head->horizontal_alignment('right');
    $head->color($gray);
    $head->padding(10);

    my $bhead = Graphics::Primitive::TextBox->new(
        color => $black,
        text => $header,
        font => $stfont,
        class => 'slide-head',
        horizontal_alignment => 'center',
        line_height => 80
    );

    my $body = Chart::Clicker->new;

    my $series = Chart::Clicker::Data::Series->new(
        keys    => [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ],
        values  => [ 42, 25, 86, 23, 2, 19, 103, 12, 54, 9 ],
    );

    my $series2 = Chart::Clicker::Data::Series->new(
        keys    => [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ],
        values  => [ 67, 15, 6, 90, 11, 45, 83, 11, 9, 101 ],
    );

    my $series3 = Chart::Clicker::Data::Series->new(
        keys    => [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ],
        values  => [ 76, 51, 60, 9, 11, 54, 38, 11, 90, 1 ],
    );

    my $series4 = Chart::Clicker::Data::Series->new(
        keys    => [ 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5, 5.5 ],
        values  => [ 6, 2, 2, 8, 6, 4, 2, 9, 1, 6 ],
    );

    my $ds = Chart::Clicker::Data::DataSet->new(series => [ $series, $series2 ]);
    my $ds2 = Chart::Clicker::Data::DataSet->new(series => [ $series3 ]);
    my $ds3 = Chart::Clicker::Data::DataSet->new(series => [ $series4 ]);

    $body->add_to_datasets($ds2, $ds3, $ds);

    my $ctx = $body->get_context('default');

    my $other = Chart::Clicker::Context->new(
        name => 'other',
        renderer => Chart::Clicker::Renderer::Area->new(
            fade => 1
        )
    );
    $other->renderer->brush->width(2);
    $body->add_to_contexts($other);

    $other->domain_axis($ctx->domain_axis);

    my $other2 = Chart::Clicker::Context->new(
        name => 'other2',
        renderer => Chart::Clicker::Renderer::Bar->new(
            opacity => .75
        )
    );
    $body->add_to_contexts($other2);

    $ds3->context('other2');
    $ds2->context('other');

    my $mark = Chart::Clicker::Data::Marker->new(key => 5, key2 => 6);
    $mark->brush->color(Graphics::Color::RGB->new(red => 0, green => 0, blue => 0, alpha => 1));
    $mark->inside_color(Graphics::Color::RGB->new(red => 0, green => 0, blue => 0, alpha => .25));
    $ctx->add_marker($mark);

    my $mark2 = Chart::Clicker::Data::Marker->new(value => 40, value2 => 60);
    $mark2->brush->color(Graphics::Color::RGB->new(red => 0, green => 0, blue => 0, alpha => 1));
    $mark2->inside_color(Graphics::Color::RGB->new(red => 0, green => 0, blue => 0, alpha => .25));
    $ctx->add_marker($mark2);

    $body->margins->left(70);
    $body->margins->right(70);
    $body->margins->top(60);
    $body->margins->bottom(20);

    if(defined($pagenum)) {
        my $foot = $slide->footer;
        $foot->border->top->width(2);
        $foot->border->top->color($gray);

        $foot->margins->right(10);
        $foot->margins->left(10);

        $foot->padding->top(10);
        $foot->text($pagenum);
        $foot->horizontal_alignment('center');
        $foot->font($footfont);
        $foot->class('slide-foot');
        $foot->margins->bottom(20);
        $foot->color($black);
    }

    $slide->body->margins->top(10);

    $slide->body->margins->left(10);
    $slide->body->margins->right(10);

    my $note = Graphics::Primitive::TextBox->new(
        color => $black,
        text => 'Chart::Clicker',
        font => $sbfont,
        class => 'slide-body',
        horizontal_alignment => 'center',
        line_height => 66,
        minimum_width => $slide->body->minimum_inside_width,
        indent => -35
    );

    $note->margins->left(50);
    $note->margins->right(50);
    $note->margins->top(10);

    $slide->body->add_component($bhead, 'n');
    $slide->body->add_component($body, 'c');
    $slide->body->add_component($note, 's');

    return $slide;
}
