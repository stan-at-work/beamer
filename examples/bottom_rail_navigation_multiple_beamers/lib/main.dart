import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

// DATA
const List<Map<String, String>> books = [
  {
    'id': '1',
    'title': 'Stranger in a Strange Land',
    'author': 'Robert A. Heinlein',
  },
  {
    'id': '2',
    'title': 'Foundation',
    'author': 'Isaac Asimov',
  },
  {
    'id': '3',
    'title': 'Fahrenheit 451',
    'author': 'Ray Bradbury',
  },
];

const List<Map<String, String>> articles = [
  {
    'id': '1',
    'title': 'Explaining Flutter Nav 2.0 and Beamer',
    'author': 'Toby Lewis',
  },
  {
    'id': '2',
    'title': 'Flutter Navigator 2.0 for mobile dev: 101',
    'author': 'Lulupointu',
  },
  {
    'id': '3',
    'title': 'Flutter: An Easy and Pragmatic Approach to Navigator 2.0',
    'author': 'Marco Muccinelli',
  },
];

// SCREENS
class BooksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Books'),
      ),
      body: ListView(
        children: books
            .map(
              (book) => ListTile(
            title: Text(book['title']!),
            subtitle: Text(book['author']!),
            onTap: () => context.beamToNamed('/books/${book['id']}'),
          ),
        )
            .toList(),
      ),
    );
  }
}

class BookDetailsScreen extends StatelessWidget {
  const BookDetailsScreen({required this.book});

  final Map<String, String> book;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book['title']!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Author: ${book['author']}'),
      ),
    );
  }
}

class ArticlesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Articles')),
      body: ListView(
        children: articles
            .map(
              (article) => ListTile(
            title: Text(article['title']!),
            subtitle: Text(article['author']!),
            onTap: () => context.beamToNamed('/articles/${article['id']}'),
          ),
        )
            .toList(),
      ),
    );
  }
}

class ArticleDetailsScreen extends StatelessWidget {
  const ArticleDetailsScreen({required this.article});

  final Map<String, String> article;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article['title']!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Author: ${article['author']}'),
      ),
    );
  }
}

// LOCATIONS
class BooksLocation extends BeamLocation<BeamState> {
  BooksLocation(RouteInformation routeInformation) : super(routeInformation);

  @override
  List<String> get pathPatterns => ['/books/:bookId'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
    BeamPage(
      key: ValueKey('books'),
      title: 'Books',
      type: BeamPageType.noTransition,
      child: BooksScreen(),
    ),
    if (state.pathParameters.containsKey('bookId'))
      BeamPage(
        key: ValueKey('book-${state.pathParameters['bookId']}'),
        title: books.firstWhere((book) => book['id'] == state.pathParameters['bookId'])['title'],
        child: BookDetailsScreen(
          book: books.firstWhere((book) => book['id'] == state.pathParameters['bookId']),
        ),
      ),
  ];
}

class ArticlesLocation extends BeamLocation<BeamState> {
  ArticlesLocation(RouteInformation routeInformation) : super(routeInformation);

  @override
  List<String> get pathPatterns => ['/articles/:articleId'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
    BeamPage(
      key: ValueKey('articles'),
      title: 'Articles',
      type: BeamPageType.noTransition,
      child: ArticlesScreen(),
    ),
    if (state.pathParameters.containsKey('articleId'))
      BeamPage(
        key: ValueKey('articles-${state.pathParameters['articleId']}'),
        title: articles.firstWhere((article) => article['id'] == state.pathParameters['articleId'])['title'],
        child: ArticleDetailsScreen(
          article: articles.firstWhere((article) => article['id'] == state.pathParameters['articleId']),
        ),
      ),
  ];
}

// APP
class AppScreen extends StatefulWidget {
  const AppScreen({Key? key}) : super(key: key);

  @override
  AppScreenState createState() => AppScreenState();
}

class AppScreenState extends State<AppScreen> {
  late int currentIndex;
  static const int breakingPoint = 640;

  final routerDelegates = [
    BeamerDelegate(
      initialPath: '/books',
      locationBuilder: (routeInformation, _) {
        if (routeInformation.location!.contains('books')) {
          return BooksLocation(routeInformation);
        }
        return NotFound(path: routeInformation.location!);
      },
    ),
    BeamerDelegate(
      initialPath: '/articles',
      locationBuilder: (routeInformation, _) {
        if (routeInformation.location!.contains('articles')) {
          return ArticlesLocation(routeInformation);
        }
        return NotFound(path: routeInformation.location!);
      },
    ),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final uriString = Beamer.of(context).configuration.location;
    currentIndex = uriString.contains('books') ? 0 : 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width >= breakingPoint)
            NavigationRail(
              selectedIndex: currentIndex,
              onDestinationSelected: _navigateTo,
              labelType: NavigationRailLabelType.selected,
              destinations: const [
                NavigationRailDestination(icon: Icon(Icons.book), label: Text('Books')),
                NavigationRailDestination(icon: Icon(Icons.article), label: Text('Articles')),
              ],
            ),
          const VerticalDivider(thickness: 1, width: 1),
          // This is the main content.
          Expanded(
            child: IndexedStack(
              index: currentIndex,
              children: [
                Beamer(
                  routerDelegate: routerDelegates[0],
                ),
                Container(
                  color: Colors.blueAccent,
                  padding: const EdgeInsets.all(32.0),
                  child: Beamer(
                    routerDelegate: routerDelegates[1],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: MediaQuery.of(context).size.width < breakingPoint
          ? BottomNavigationBar(
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(label: 'Books', icon: Icon(Icons.book)),
          BottomNavigationBarItem(label: 'Articles', icon: Icon(Icons.article)),
        ],
        onTap: _navigateTo,
      )
          : null,
    );
  }

  void _navigateTo(index) {
    if (index != currentIndex) {
      setState(() => currentIndex = index);
      routerDelegates[currentIndex].update(rebuild: false);
    }
  }
}

class MyApp extends StatelessWidget {
  final routerDelegate = BeamerDelegate(
    initialPath: '/books',
    locationBuilder: RoutesLocationBuilder(
      routes: {
        '*': (context, state, data) => AppScreen(),
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerDelegate: routerDelegate,
      routeInformationParser: BeamerParser(),
      backButtonDispatcher: BeamerBackButtonDispatcher(
        delegate: routerDelegate,
      ),
    );
  }
}

void main() => runApp(MyApp());
