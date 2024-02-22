// Alexander Chen
// CPSC 5250 Homework 3
// SUID: 4186272

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hwone/floor_model/health_database.dart';
import 'package:hwone/userActivityWidget.dart';
import 'package:hwone/workoutRecorder.dart';
import 'package:provider/provider.dart';
import './userActivityProvider.dart';
import './emotionRecorder.dart';
import './dietRecorder.dart';

import 'recorder_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';




void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  AppDatabase database = await $FloorAppDatabase.databaseBuilder('healthRecord.db').build();
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(
          create: (context) => UserActivityProvider(database: database)),
        Provider(create: (context) => database)
      ],
      child: const MyApp()
  ));
}

class MyApp extends StatefulWidget{
  const MyApp({super.key});


  static _MyAppState? of(BuildContext context) => context.findAncestorStateOfType<_MyAppState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>  {

  Locale _locale = const Locale('en');
  bool _useCupertinoDesign = false;
  bool get useCupertinoDesign => _useCupertinoDesign;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  void setStyle(bool useCupertinoDesign) {
    setState(() {
      _useCupertinoDesign = useCupertinoDesign;
    });
  }




  @override
  Widget build(BuildContext context) {

    final GoRouter router = GoRouter(
      initialLocation: '/emotion',
      routes: [
        ShellRoute(
          builder: (context, state, child) => HealthRecorder(child: child),
          routes: [
            GoRoute(
              path: '/emotion',
              builder: (BuildContext context, GoRouterState state) => EmotionRecorderApp(),
            ),
            GoRoute(
              path: '/diet',
              builder: (BuildContext context, GoRouterState state) => DietRecorderApp(),
            ),
            GoRoute(
              path: '/workout',
              builder: (BuildContext context, GoRouterState state) => WorkoutRecorderApp(),
            ),
          ],
        ),
      ],
    );
    return MaterialApp.router(
      routerConfig: router,
      title: 'Health Recorder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      locale: _locale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        RecorderLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('zh', ''),
      ],
    );
  }
}


class HealthRecorder extends StatefulWidget {
  final Widget child;

  const HealthRecorder({super.key, required this.child});

  @override
  State<HealthRecorder> createState() => _HealthRecorderState();
}

class _HealthRecorderState extends State<HealthRecorder> {
  int _selectedIndex = 0;

  void _showSettingDialog(BuildContext context) {
    final appState = MyApp.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(RecorderLocalizations.of(context).translate('Setting')),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(RecorderLocalizations.of(context).translate('chooseLanguage')),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const <Locale>[Locale('en', ''), Locale('zh', '')].map((Locale locale) {
                    return RadioListTile<Locale>(
                      title: Text(RecorderLocalizations.of(context).translate(locale.languageCode)),
                      value: locale,
                      groupValue: MyApp.of(context)!._locale,
                      onChanged: (Locale? value) {
                        MyApp.of(context)?.setLocale(value!);
                      },
                    );
                  }).toList(),
                ),
                const Divider(),
                Text(RecorderLocalizations.of(context).translate('chooseTheme')),
                SwitchListTile(
                  title: Text(appState!.useCupertinoDesign ? 'Cupertino':'Material'),
                  value: appState.useCupertinoDesign,
                  onChanged: (bool value) {
                    appState.setStyle(value);
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(RecorderLocalizations.of(context).translate('close')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userMonitor = Provider.of<UserActivityProvider>(context, listen: false);
      userMonitor.showPtsAndAct();
    });
  }

  @override
  Widget build(BuildContext context) {
    final RecorderLocalizations localizations = RecorderLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF333333),
        title: Text(
          localizations.translate('appTitle'),
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            color: Colors.white,
            onPressed: () {
              _showSettingDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded (
            child: widget.child,
          ),
          const UserActivityWidget(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          switch (index) {
            case 0:
              context.go('/emotion');
              break;
            case 1:
              context.go('/diet');
              break;
            case 2:
              context.go('/workout');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.sentiment_very_dissatisfied), label: 'Emotion'),
          BottomNavigationBarItem(icon: Icon(Icons.food_bank), label: 'Diet'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Workout'),
        ],
      ),
    );
  }
}




