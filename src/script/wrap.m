
import bench;   // benchmarking

//
// greedy word wrap.
// words longer than the given width are on
// a line by themselves, otherwise width is
// strictly observed.
//
wrap(str:String, wid:Int) -> [String]
{
    // locations of wrappable positions in str,
    // plus start and end offsets
    spaces = [0] + strwhere(str, { _ == " " }) + [strlen(str)];

    // given current list of line breaks and current
    // position in space locations list, add a new
    // line break if necessary. return resulting list
    //
    checkline(breaks, spaceix)
    {
        // start position of current (i.e. final) line
        linestart = last(breaks);

        // current and next space positions
        (curspace, nextspace) = (spaces[spaceix], spaces[spaceix + 1]);

        // if current line holds word, a new line isn't needed.
        // also, if a word is too big to fit, we leave it on its
        // own line. otherwise, begin a new line at the current word.
        //
        guard(linestart + wid >= nextspace || { linestart == curspace }, breaks, {
            append(breaks, curspace + 1)
        })
    };

    // accumulate line breaks by scanning space positions
    breaks = evolve([0], checkline, count(size(spaces) - 1));

    // cut str into lines
    lines = strcut(str, breaks);

    // all but the last line end with a space. trim and return
    drop(-1, lines) | { strdrop(-1, _) } + take(-1, lines)
};

// replace a string's crlfs with spaces
unwrap(str)
{
    lines = strsplit(str, "\n");
    text = evolve("", { _.0 + " " + _.1 }, lines);
    strdrop(1, text)
};

// convert list of lines to string with crlfs
fmtlines(lines)
{
    text = evolve("", { _.0 + _.1 + "\n" }, lines);
    strdrop(-1, text)
};

// print a wrapped paragraph with numbered header
printpara(lines, wid)
{
    printstr("\n" + strtake(wid, "0123456789") + "\n" + fmtlines(lines))
};

// ----------------------------------------------------

//
// test script
//

// load book text as string
path = "data/annak.txt";
text = readfile(path);

// strsplit into nonempty paragraphs
paras = filter(strsplit(text, "\n\n") | unwrap, { !empty(_) });

// strsplit each para into words
parawords = paras | { strsplit(_, " ") };

// print initial stats
sizes = parawords | size;
nwords = sum sizes;
nparas = size paras;
print(
  path: path,
  size: strlen(text),
  words: nwords,
  paras: nparas ,
  avgpara: nwords / nparas,
  longpara: reduce(max, 0, sizes)
);

// sample random paras to print - boxed so it can
// be modified from the shell
samples = box(draw(5, size paras));

// benchmark wrap to given width
testwrap(wid)
{
    b = bench({ paras | { wrap(_, wid) } });

    // print elapsed time and a few random paragraphs
    print(time: b.time);
    mapll(*samples, b.result) | { printpara(_, wid) };
    printstr("");

    // return result
    b.result
};


// indexes of all paras with overflowing lines
overs = { paras, wid => where(paras, { any(_, { strlen _ > wid }) }) };

print "--- wrap to 100 columns ---";
w100 = testwrap 100;
print ("overs: ", overs (w100, 100));

print "--- wrap to 50 columns ---";
w50 = testwrap 50;
print ("overs: ", overs (w50, 50));


