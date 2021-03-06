ANNALES
=======

My entry for NaNoGenMo 2016. An exercise in cheap generative worldbuilding
built from a Haskell combinator library, an event loop and vocabulary from
a neural net trained on dictionary entries.

## ANNALES is finished!

* [ANNALES](output/annales.md)
* [ANNALES as a PDF](output/annales.pdf)

## Blog posts

[Annales: the gory details in three parts](http://mikelynch.org/2016/Dec/10/annales-details/)

1. [Vocabularies](http://mikelynch.org/2016/Dec/10/annales-1-vocab/):
   using a neural network, Python and regular expressions to generate
   a nonsense vocabulary
2. [TextGen](http://mikelynch.org/2016/Dec/10/annales-2-textgen/): a
   Haskell combinator library for making up randomised sentences (plus
   a one-paragraph explanation of how the State monad works!)
3. [Events](http://mikelynch.org/2016/Dec/10/annales-3-events/): in
   which I get bogged down writing a succession algorithm, but also
   figure out how to correct a typo in a randomly-generated text


## Code overview

Annales is build in three stages: vocabuary modelling, vocabulary
mining and procedural generation.

### Vocabulary modelling

The basis for the nonsensical names and words is a neural net which
has been trained on all of the word definitions in WordNet. I built
this a while ago to power a Twitter bot,
[@GLOSSATORY](http://bots.mikelynch.org/glossatory/), using Justin
Johnson's [torch-rnn](https://github.com/jcjohnson/torch-rnn) code.

Here is
[the eight-line script used to fetch around 82,000 definitions from WordNet](data/wordnetdefs.py)

### Vocabulary mining

I generated about 50,000 glossatory entries, and then generated
vocabulary files for Annales from that with a Python script,
[extract.py](data/extract.py). This creates lists like
[men.txt](data/men.txt) and [buildings.txt](data/buildings.txt) based on
regular expressions.

### Procedural generation

annales itself is a Haskell application which builds on
[TextGen](https://github.com/spikelynch/textgen), a Haskell combinator
library I wrote for another Twitter bot,
[@amightyhost](http://bots.mikelynch.org/amightyhost/).  It uses its
own event loop to generate incidents and then uses TextGen, with the
vocabulary files, to generate descriptions of those incidents.

## Sample output

* [Release 1.8.0.0 - Mallectoria](output/sample-1.8.0.0-Mallectoria.md)
* [Release 1.7.0.0 - Gingtel Parie](output/sample-1.7.0.0-Gingtel-Parie.md)
* [Release 1.6.0.0 - Homilation I](output/sample-1.6.0.0-Homilation-I.md)
* [Release 1.5.0.0 - Genus And Mounty](output/sample-1.5.0.0-Genus-And-Mounty.md)
* [Release 1.4.0.0 - Indolation](output/sample-1.4.0.0-Indolation.md)
* [Release 1.3.1.0 - Pacentirus](output/sample-1.3.1.0-Pacentirus.md)
* [Release 1.1.0.0 - Limonication](output/sample-1.1.0.0-Limonication.md)
* [Release 1.0.0.0 - Bladda](output/sample-1.0.0.0-Bladda.md)

