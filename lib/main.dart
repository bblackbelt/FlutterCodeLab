import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random words',
      theme: new ThemeData(
        primaryColor: Colors.yellow
      ),
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _savedWords = Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  Widget _buildSuggetions() {
    return ListView.builder(itemBuilder: (context, i) {
      if (i.isOdd) {
        return Divider();
      }

      final index = i ~/ 2;
      if (index >= _suggestions.length) {
        _suggestions.addAll(generateWordPairs().take(10));
      }

      return _buildRow(_suggestions[index]);
    },
        padding: const EdgeInsets.all(10.0));
  }

  Widget _buildRow(WordPair pair) {
    final alreaySaved = _savedWords.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreaySaved ? Icons.favorite : Icons.favorite_border,
        color: alreaySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreaySaved) {
            _savedWords.remove(pair);
          } else {
            _savedWords.add(pair);
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Random words'),
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved)
        ],
      ),
      body: _buildSuggetions(),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
          builder: (BuildContext context) {
            final Iterable<ListTile> titles = _savedWords.map(
                    (WordPair p) {
                  return new ListTile(
                    title: new Text(
                      p.asPascalCase,
                      style: _biggerFont,
                    ),
                  );
                },
            );
            final List<Widget> divided = ListTile
            .divideTiles(tiles: titles, context: context)
            .toList();

            return new Scaffold(
              appBar: new AppBar(
                title: const Text('Saved Suggestions'),
              ),
              body: new ListView(children: divided),
            );
          }),
    );
  }
}
