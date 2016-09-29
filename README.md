# Wortliste

Deutsche Wortliste reproduzierbar erzeugen

## Verwendung

	./wortliste-generieren.sh

Es werden diverse Datensätze aus dem Internet geladen (etwa 5,5 GB), zusammen mit den entpackten und aufbereiteten Daten werden etwa 18 GB Speicherplatz benötigt. Die Generierung dauert etwa 30 Minuten.

Ergebnis ist eine 3 MB große Textdatei mit 239.650 deutschen Wörtern. Diese kann z.B. verwendet werden, um daraus sichere Passphrasen zu generieren.

Getestet auf OS X 10.10, NixOS 16.03 und Ubuntu 14.04.

## Abhängigkeiten

- [Nix](http://nixos.org/nix/)

(Alle weiteren Abhängigkeiten werden von Nix aufgelöst)

## Quellen

- [Digitales Wörterbuch der deutschen Sprache](http://www.dwds.de/) der [Berlin-Brandenburgischen Akademie der Wissenschaften](http://www.bbaw.de/)
- [Leipzig Corpora Collection (LCC)](http://wortschatz.uni-leipzig.de/) vom [Wortschatz-Projekt der Universität Leipzig](http://wortschatz.uni-leipzig.de/)
- [DeReWo – Korpusbasierte Grund-/Wortformenlisten](http://www1.ids-mannheim.de/kl/projekte/methoden/derewo.html) vom [Institut für Deutsche Sprache](http://www1.ids-mannheim.de/)
