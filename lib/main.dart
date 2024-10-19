import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//THis is the main method of the program
void main() {
  runApp(MyApp());
}

//THis is the class called MyApp that extends from StatelessWidget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          //Here we can change the color of the theme of the app we can use RGB Color.fromRGB(0, 255, 0, 1.0) or hexadecimals Color(0xFF00FF00).
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent), 
        ),
        home: MyHomePage(),
      ),
    );
  }
}

//THis is another definition class MyAppState that extends from ChangeNotifier 
///ChangeNotifier is one way to manage the app state, this is the most easy of explain.
///Extending from this class it means that the class MyAppState can notify to others about their changes.
///The state is created and provided to the whole app using a ChangeNotifierProvider (see code above in MyApp). This allows any widget in the app to get hold of the state.
class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var favorites = <WordPair>[];

  var history = <WordPair>[];

  var selectedIndex = 0;
  var selectedIndexInAnotherWidget = 0;
  var indexInYetAnotherWidget = 42;
  var optionASelected = false;
  var optionBSelected = false;
  var loadingFromNetwork = false;

  GlobalKey? historyListKey;        //A key that is unique across the entire app. Global keys uniquely identify elements

  ///The new getNext() method reassigns current with a new random WordPair. It also calls notifyListeners()(a method of ChangeNotifier)that ensures that anyone watching MyAppState is notified.
  void getNext() {
    history.insert(0, current);
    var animatedList = historyListKey?.currentState as AnimatedListState?;
    animatedList?.insertItem(0); // THis inserts the items in the History list
    current = WordPair.random();
    notifyListeners();
  }

  void toggleFavorite([WordPair? pair]){
    pair = pair ?? current;               // ?? Null Operator:  This operator returns expression on its left, except if it is null, and if so, it returns right expression
    if (favorites.contains(pair)){
      favorites.remove(pair);
    } else {
      favorites.add(pair);
    }
    notifyListeners();
  }

  void removeFavorite(WordPair pair){
  favorites.remove(pair);
  notifyListeners();
}

}


//class MyHomePage extends StatelessWidget { This is a Widget without state
class MyHomePage extends StatefulWidget{
  
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /*@override
  Widget build(BuildContext context) {                    // 1- Every widget defines a build() method that's automatically called every time the widget's circumstances change so that the widget is always up to date.
    var appState = context.watch<MyAppState>();  
    var pair = appState.current;                          // 2- MyHomePage tracks changes to the app's current state using the watch method.

    //Add the icon heart
    IconData icon;
    if (appState.favorites.contains(pair)){
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Scaffold(                                      // 3- Every build method must return a widget or (more typically) a nested tree of widgets. In this case, the top-level widget is Scaffold. You aren't going to work with Scaffold in this "codelab", but it's a helpful widget and is found in the vast majority of real-world Flutter apps.
      body: Center(
        child: Column(                                    // 4- Column is one of the most basic layout widgets in Flutter. It takes any number of children and puts them in a column from top to bottom. By default, the column visually places its children at the top. You'll soon change this so that the column is centered.
          mainAxisAlignment: MainAxisAlignment.center,    // This property aligns the element in this case the Card in the horizontal center.
          children: [
            //             |
            //Comment this V because has an explanation about what we need to have it
            //Text('A random Awesome Squirrel idea:'),    // 5- You changed this Text widget in the first step.
            BigCard(pair: pair),                          // 6- This second Text widget takes appState, and accesses the only member of that class, current (which is a WordPair). WordPair provides several helpful getters, such as asPascalCase or asSnakeCase. Here, we use asLowerCase but you can change this now if you prefer one of the alternatives.
            SizedBox(height: 10),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //This lines add a buttons
                ElevatedButton.icon(
                  onPressed: () {
                    //print('button pressed');
                    appState.toggleFavorite();
                  }, 
                  icon: Icon(icon),
                  label: Text('Like'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    //print('button pressed');
                    appState.getNext();
                  }, 
                  child: Text('Next'),
                ),
              ],
            ),
          ],                                              // 7- Notice how Flutter code makes heavy use of trailing commas. This particular comma doesn't need to be here, because children is the last (and also only) member of this particular Column parameter list. Yet it is generally a good idea to use trailing commas: they make adding more members trivial, and they also serve as a hint for Dart's auto-formatter to put a newline there. For more information, see Code formatting.
        ),
      ),
    );
  }*/

  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    
    Widget page;
    switch (selectedIndex) {
      case 0: 
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    // The container for the current page, with its background color and subtle switching animation.
    var mainArea = ColoredBox(
      color: colorScheme.surfaceContainerHighest, 
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: page,
      ),
    );

    /*return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  //extended: true,                  //False property avoid the objects in that widget(area) do not be hidden by a status bar. True expands the are to be visible 
                  extended: constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    //print('selected: $value');
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      }*/

      return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 450) {
            // Use a more mobile-friendly layout with BottomNavigationBar
            // on narrow screens.
            return Column(
              children: [
                Expanded(child: mainArea),
                SafeArea(
                  child: BottomNavigationBar(
                    items: [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.favorite),
                        label: 'Favorites',
                      ),
                    ],
                    currentIndex: selectedIndex,
                    onTap: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                )
              ],
            );
          } else {
            return Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 600,
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.favorite),
                        label: Text('Favorites'),
                      ),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                ),
                Expanded(child: mainArea),
              ],
            );
          }
        },
      ),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    //return Scaffold(       
    return Center(                                      //We don't return an Scaffold we are returning a widget
      child: Column(                                    // 4- Column is one of the most basic layout widgets in Flutter. It takes any number of children and puts them in a column from top to bottom. By default, the column visually places its children at the top. You'll soon change this so that the column is centered.
          mainAxisAlignment: MainAxisAlignment.center,    // This property aligns the element in this case the Card in the horizontal center.
          children: [
            Expanded(
              flex: 3,
              child: HistoryListView(),
            ),
            SizedBox(height: 10),
            //             |
            //Comment this V because has an explanation about what we need to have it
            //Text('A random Awesome Squirrel idea:'),    // 5- You changed this Text widget in the first step.
            BigCard(pair: pair),                          // 6- This second Text widget takes appState, and accesses the only member of that class, current (which is a WordPair). WordPair provides several helpful getters, such as asPascalCase or asSnakeCase. Here, we use asLowerCase but you can change this now if you prefer one of the alternatives.
            SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                //This lines add a buttons
                ElevatedButton.icon(
                  onPressed: () {
                    //print('button pressed');
                    appState.toggleFavorite();
                  }, 
                  icon: Icon(icon),
                  label: Text('Like'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    //print('button pressed');
                    appState.getNext();
                  }, 
                  child: Text('Next'),
                ),
              ],
            ),
            Spacer(flex: 2),
          ],                                              // 7- Notice how Flutter code makes heavy use of trailing commas. This particular comma doesn't need to be here, because children is the last (and also only) member of this particular Column parameter list. Yet it is generally a good idea to use trailing commas: they make adding more members trivial, and they also serve as a hint for Dart's auto-formatter to put a newline there. For more information, see Code formatting.
      ),
    );
    //);
  }
}

class FavoritesPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty){
      return Center(
        child: Text('No favorites yet.'),
      );
    }
    
    //return ListView(
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.all(20),
        child: Text('You have '
            '${appState.favorites.length} favorites:'),
        ),
        Expanded(
          // Make better use of wide windows with a grid.
          child: GridView(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400,
              childAspectRatio: 400 / 400
            ),
            children:[
              for (var pair in appState.favorites)
                ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.delete_outline, semanticLabel: 'Delete'),
                    color: theme.colorScheme.primary,
                    onPressed: (){
                      appState.removeFavorite(pair);
                    },
                  ),
                  title: Text(
                    pair.asLowerCase,
                    semanticsLabel: pair.asPascalCase,),
          )
            ]),)
        
      ]
    );
  }
}
///THe widgets are also classes
class BigCard extends StatelessWidget {
  const BigCard({
    Key? key, 
    required this.pair,
  }): super(key: key);

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context); //I changed the variable from final to var, the same for style variable

    ///By using theme.textTheme, you access the app's font theme. This class includes members such as bodyMedium (for standard text of medium size), caption (for captions of images), or headlineLarge (for large headlines).
    ///The displayMedium property is a large style meant for display text. The word display is used in the typographic sense here, such as in display typeface. The documentation for displayMedium says that "display styles are reserved for short, important text"—exactly our use case.
    ///The theme's displayMedium property could theoretically be null. Dart, the programming language in which you're writing this app, is null-safe, so it won't let you call methods of objects that are potentially null. In this case, though, you can use the ! operator ("bang operator") to assure Dart you know what you're doing. (displayMedium is definitely not null in this case. The reason we know this is beyond the scope of this codelab, though.)
    ///Calling copyWith() on displayMedium returns a copy of the text style with the changes you define. In this case, you're only changing the text's color.
    //To get the new color, you once again access the app's theme. The color scheme's onPrimary property defines a color that is a good fit for use on the app's primary color.
    var style = theme.textTheme.displayMedium!.copyWith( 
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      color : theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: AnimatedSize(
          duration: Duration(milliseconds: 200),
          // Make sure that the compound word wraps correctly when the window is too narrow.
          child: MergeSemantics(
            child: MergeSemantics(
              child: Wrap(
                children: [
                  Text(
                    pair.first,
                    style: style.copyWith(fontWeight: FontWeight.w200)
                  ),
                  Text(
                    pair.second,
                    style: style.copyWith(fontWeight: FontWeight.bold),
                  )
                ]
              )
            )
          )
        )
        // Text(pair.asLowerCase, style: style,semanticsLabel: "${pair.first} ${pair.second}") //we add the style to the text this is changed for the MergeSemantics
      ),
    );
  }
}

class HistoryListView extends StatefulWidget {
  const HistoryListView({Key? key}) : super(key: key);

  @override
  State<HistoryListView> createState() => _HistoryListViewState();
}

class _HistoryListViewState extends State<HistoryListView> {
  /// Needed so that [MyAppState] can tell [AnimatedList] below to animate
  /// new items.
  final _key = GlobalKey();

  /// Used to "fade out" the history items at the top, to suggest continuation.
  static const Gradient _maskingGradient = LinearGradient(
    // This gradient goes from fully transparent to fully opaque black...
    colors: [Colors.transparent, Colors.black],
    // ... from the top (transparent) to half (0.5) of the way to the bottom.
    stops: [0.0, 0.5],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    appState.historyListKey = _key;

    return ShaderMask(
      shaderCallback: (bounds) => _maskingGradient.createShader(bounds),
      // This blend mode takes the opacity of the shader (i.e. our gradient)
      // and applies it to the destination (i.e. our animated list).
      blendMode: BlendMode.dstIn,
      child: AnimatedList(
        key: _key,
        reverse: true,
        padding: EdgeInsets.only(top: 100),
        initialItemCount: appState.history.length,
        itemBuilder: (context, index, animation) {
          final pair = appState.history[index];
          return SizeTransition(
            sizeFactor: animation,
            child: Center(
              child: TextButton.icon(
                onPressed: () {
                  appState.toggleFavorite(pair);
                },
                icon: appState.favorites.contains(pair)
                    ? Icon(Icons.favorite, size: 12)
                    : SizedBox(),
                label: Text(
                  pair.asLowerCase,
                  semanticsLabel: pair.asPascalCase,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
