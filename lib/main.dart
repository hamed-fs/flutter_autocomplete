import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class HomePage extends StatefulWidget {
  final String title;

  HomePage({this.title});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textEditController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: TypeAheadField<String>(
              getImmediateSuggestions: true,
              textFieldConfiguration: TextFieldConfiguration(
                controller: _textEditController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'What are you looking for?',
                  suffixIcon: InkWell(
                    onTap: _clearSearch,
                    borderRadius: BorderRadius.circular(25.0),
                    child: Icon(Icons.clear),
                  ),
                ),
              ),
              hideOnEmpty: true,
              suggestionsCallback: (String pattern) async {
                return pattern.isEmpty
                    ? null
                    : ['Search*"$pattern"*in Store', 'Search*"$pattern"*in News'];
              },
              itemBuilder: (context, String suggestion) {
                List<String> suggestionParts = suggestion.split('*');

                return Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(
                        Icons.search,
                        size: 24.0,
                      ),
                      title: RichText(
                        text: TextSpan(
                          text: '${suggestionParts[0]} ',
                          style: TextStyle(color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                              text: '${suggestionParts[1]}',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(text: ' ${suggestionParts[2]}'),
                          ],
                        ),
                      ),
                    ),
                    Divider(height: 1.0)
                  ],
                );
              },
              transitionBuilder: (
                BuildContext context,
                Widget suggestionsBox,
                AnimationController animationController,
              ) =>
                  FadeTransition(
                child: suggestionsBox,
                opacity: CurvedAnimation(
                  parent: animationController,
                  curve: Curves.easeOut,
                ),
              ),
              suggestionsBoxDecoration: SuggestionsBoxDecoration(
                elevation: 2.0,
                borderRadius: BorderRadius.circular(4.0),
              ),
              onSuggestionSelected: (String suggestion) {
                print("$suggestion selected");

                _clearSearch();
              },
            ),
          )
        ],
      ),
    );
  }

  void _clearSearch() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _textEditController.clear();
        FocusScope.of(context).unfocus();
      },
    );
  }
}
