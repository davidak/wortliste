#! /usr/bin/env nix-shell
#! nix-shell -i bash -p bash gawk gnused coreutils libiconv wget unzip gzip p7zip xmlstarlet
#bzip2 gnugrep

echo -e "Wordliste generieren...\n"

mkdir -p sources workdir clean

echo -e "\nWortlisten aus dem Internet laden...\n"

cd sources/
wget --no-clobber --content-disposition http://clarin.bbaw.de:8088/fedora/objects/dwds:2/datastreams/xml/content
#wget --no-clobber https://github.com/hermitdave/FrequencyWords/raw/master/content/2016/de/de_full.txt
wget --no-clobber http://wortschatz.uni-leipzig.de/Papers/top10000de.txt
#wget --no-clobber https://dumps.wikimedia.org/dewiktionary/20160820/dewiktionary-20160820-pages-articles.xml.bz2

wget --no-clobber http://www1.ids-mannheim.de/fileadmin/kl/derewo/derewo-v-ww-bll-320000g-2012-12-31-1.0.zip
wget --no-clobber http://www1.ids-mannheim.de/fileadmin/kl/derewo/DeReKo-2014-II-MainArchive-STT.100000.freq.7z
wget --no-clobber http://www1.ids-mannheim.de/fileadmin/kl/derewo/derewo-v-ww-bll-250000g-2011-12-31-0.1.zip

wget --no-clobber http://corpora2.informatik.uni-leipzig.de/downloads/deu_news_2015_3M.tar.gz
wget --no-clobber http://corpora2.informatik.uni-leipzig.de/downloads/deu_news_2014_3M.tar.gz
wget --no-clobber http://corpora2.informatik.uni-leipzig.de/downloads/deu_news_2010_1M-text.tar.gz
wget --no-clobber http://corpora2.informatik.uni-leipzig.de/downloads/deu_news_2009_1M-text.tar.gz
wget --no-clobber http://corpora2.informatik.uni-leipzig.de/downloads/deu_news_2008_1M-text.tar.gz
wget --no-clobber http://corpora2.informatik.uni-leipzig.de/downloads/deu_news_2007_1M-text.tar.gz
wget --no-clobber http://corpora2.informatik.uni-leipzig.de/downloads/deu_news_2006_1M-text.tar.gz
wget --no-clobber http://corpora2.informatik.uni-leipzig.de/downloads/deu_news_2005_1M-text.tar.gz
wget --no-clobber http://corpora2.informatik.uni-leipzig.de/downloads/deu_news_2004_1M-text.tar.gz
wget --no-clobber http://corpora2.informatik.uni-leipzig.de/downloads/deu_news_2003_1M-text.tar.gz
wget --no-clobber http://corpora2.informatik.uni-leipzig.de/downloads/deu_news_2002_1M-text.tar.gz
wget --no-clobber http://corpora2.informatik.uni-leipzig.de/downloads/deu_news_2001_1M-text.tar.gz
wget --no-clobber http://corpora2.informatik.uni-leipzig.de/downloads/deu_news_1999_1M-text.tar.gz
wget --no-clobber http://corpora2.informatik.uni-leipzig.de/downloads/deu_news_1998_1M-text.tar.gz
wget --no-clobber http://corpora2.informatik.uni-leipzig.de/downloads/deu_news_1997_1M-text.tar.gz
wget --no-clobber http://corpora2.informatik.uni-leipzig.de/downloads/deu_news_1996_1M-text.tar.gz
wget --no-clobber http://corpora2.informatik.uni-leipzig.de/downloads/deu_news_1995_1M-text.tar.gz

wget --no-clobber http://corpora2.informatik.uni-leipzig.de/downloads/deu_web_2002_1M-text.tar.gz

wget --no-clobber http://corpora2.informatik.uni-leipzig.de/downloads/deu_wikipedia_2014_3M.tar.gz
wget --no-clobber http://corpora2.informatik.uni-leipzig.de/downloads/deu_wikipedia_2010_1M-text.tar.gz
wget --no-clobber http://corpora2.informatik.uni-leipzig.de/downloads/deu_wikipedia_2007_1M-text.tar.gz
cd ..

echo -e "\nDateien entpacken...\n"

unzip -n sources/XML\ fulltext\ of\ dwdsDWDS-W\ rterbuch\ \(Stichwortliste\).zip -d workdir
unzip -n sources/derewo-v-ww-bll-320000g-2012-12-31-1.0.zip -d workdir
unzip -n sources/derewo-v-ww-bll-250000g-2011-12-31-0.1.zip -d workdir
7z e -oworkdir -aos sources/DeReKo-2014-II-MainArchive-STT.100000.freq.7z
for i in sources/deu_*; do tar xzfk $i -C workdir; done

echo -e "\nDaten bereinigen...\n"

if [ ! -f clean/dwds.txt ] ; then
	xmlstarlet sel -t -v '/LexicalResource/Lexicon/LexicalEntry/Lemma/feat/@val' workdir/headwords.dwds*.xml | sed -E '/[^a-zA-ZäöüÄÖÜß]/d' | sed -E '/[A-ZÄÖÜ]{2,}/d' | sed '/^.$/d' | sed '/^\s*$/d' > clean/dwds.txt
fi
if [ ! -f workdir/derewo-v-ww-bll-320000g-2012-12-31-1.0-utf8.txt ] ; then
	iconv -f "windows-1252" -t "UTF-8" workdir/derewo-v-ww-bll-320000g-2012-12-31-1.0.txt > workdir/derewo-v-ww-bll-320000g-2012-12-31-1.0-utf8.txt
fi
if [ ! -f clean/derewo-2012.txt ] ; then
	cat workdir/derewo-v-ww-bll-320000g-2012-12-31-1.0-utf8.txt | sed '/#/d' | awk '$2 <= 18' | awk '{print $1}' | sed -E "/[^a-zA-ZäöüÄÖÜß]/d" | sed -E '/[A-ZÄÖÜ]{2,}/d' | sed '/^.$/d' | sed '/^\s*$/d' > clean/derewo-2012.txt
fi
if [ ! -f workdir/derewo-v-ww-bll-250000g-2011-12-31-0.1-utf8.txt ] ; then
	iconv -f "windows-1252" -t "UTF-8" workdir/derewo-v-ww-bll-250000g-2011-12-31-0.1.txt > workdir/derewo-v-ww-bll-250000g-2011-12-31-0.1-utf8.txt
fi
if [ ! -f clean/derewo-2011.txt ] ; then
	cat workdir/derewo-v-ww-bll-250000g-2011-12-31-0.1-utf8.txt | sed '/#/d' | awk '$2 <= 20' | awk '{print $1}' | sed -E "/[^a-zA-ZäöüÄÖÜß]/d" | sed -E '/[A-ZÄÖÜ]{2,}/d' | sed '/^.$/d' | sed '/^\s*$/d' > clean/derewo-2011.txt
fi
if [ ! -f clean/DeReKo-2014.txt ] ; then
	cat workdir/DeReKo-2014-II-MainArchive-STT.100000.freq | sed '/NE/d' | sed '/FM/d' | sed '/XY/d' | awk -F$'\t' '{print $2}' | sed -E "/[^a-zA-ZäöüÄÖÜß]/d" | sed -E '/[A-ZÄÖÜ]{2,}/d' | sed '/^.$/d' | sed '/^\s*$/d' | sed '/^unknown/d' > clean/DeReKo-2014.txt
fi
#if [ ! -f clean/dewiktionary_words.txt ] ; then
#	bzcat sources/dewiktionary-*.bz2 | grep '<title>[^[:space:][:punct:]]*</title>' | sed 's:.*<title>\(.*\)</title>.*:\1:' | sed -E '/[^a-zA-ZäöüÄÖÜß]/d' | sed -E '/[A-ZÄÖÜ]{2,}/d' | sed '/^.$/d' | sed '/^\s*$/d' > clean/dewiktionary_words.txt
#fi
#if [ ! -f clean/de_full.txt ] ; then
#	cat sources/de_full.txt | awk '$2 >= 10' | awk '{print $1}' | sed -E '/[^a-zA-ZäöüÄÖÜß]/d' | sed -E '/[A-ZÄÖÜ]{2,}/d' | sed '/^.$/d' | sed '/^\s*$/d' > clean/de_full.txt
#	cat clean/dewiktionary_words.txt clean/de_full.txt | sort | uniq -c | sort -nr | awk '$1 >= 2' | awk '{print $2}' | sort > clean/de_full.txt
#fi
if [ ! -f sources/top10000de_utf8.txt ] ; then
	iconv -f "windows-1252" -t "UTF-8" sources/top10000de.txt > sources/top10000de_utf8.txt
fi
if [ ! -f clean/top10000de_utf8.txt ] ; then
	cat sources/top10000de_utf8.txt | sed -E '/[^a-zA-ZäöüÄÖÜß]/d' | sed -E '/[A-ZÄÖÜ]{2,}/d' | sed '/^.$/d' | sed '/^\s*$/d' > clean/top10000de_utf8.txt
fi
for i in workdir/deu_*words.txt ; do
	if [ ! -f clean/$(basename $i) ] ; then
		cat $i | awk -F$'\t' '$3 >= 10' | awk -F$'\t' '{print $2}' | sed -E "/[^a-zA-ZäöüÄÖÜß]/d" | sed -E '/[A-ZÄÖÜ]{2,}/d' | sed '/^.$/d' | sed '/^\s*$/d' > clean/$(basename $i)
	fi
done
for i in workdir/deu_*3M/*words.txt ; do
	if [ ! -f clean/$(basename $i) ] ; then
		cat $i | awk -F$'\t' '$4 >= 10' | awk -F$'\t' '{print $2}' | sed -E "/[^a-zA-ZäöüÄÖÜß]/d" | sed -E '/[A-ZÄÖÜ]{2,}/d' | sed '/^.$/d' | sed '/^\s*$/d' > clean/$(basename $i)
	fi
done
if [ ! -f clean/deu_news_words.txt ] ; then
	cat clean/deu_news_* | sort | uniq -c | sort -nr | awk '$1 >= 8' | awk '{print $2}' | sort > clean/deu_news_words.txt
fi
if [ ! -f clean/deu_wikipedia_words.txt ] ; then
	cat clean/deu_wikipedia_* | sort | uniq -c | sort -nr | awk '$1 >= 3' | awk '{print $2}' | sort > clean/deu_wikipedia_words.txt
fi
cat clean/{deu_news_words.txt,deu_wikipedia_words.txt,dwds.txt,derewo-2012.txt,derewo-2011.txt,DeReKo-2014.txt,top10000de_utf8.txt} | sort -u > wortliste.txt
# keine Namen wie McLaren
sed -i "/^Mc[A-Z]/d" wortliste.txt
