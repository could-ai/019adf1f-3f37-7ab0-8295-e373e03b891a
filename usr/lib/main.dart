import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'models/fmea_item.dart';
import 'screens/worksheet_screen.dart';
import 'screens/chart_screen.dart';

void main() {
  runApp(const FmeaApp());
}

class FmeaApp extends StatelessWidget {
  const FmeaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'نرم‌افزار FMEA',
      debugShowCheckedModeBanner: false,
      // تنظیمات زبان فارسی و راست‌چین
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fa', ''), // Persian
      ],
      locale: const Locale('fa', ''),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
        fontFamily: 'Roboto', // In a real app, use a Persian font like Vazirmatn
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // داده‌های نمونه اولیه
  final List<FmeaItem> _items = [
    FmeaItem(
      id: '1',
      processName: 'جوشکاری بدنه',
      failureMode: 'ترک خوردگی جوش',
      failureEffect: 'کاهش استحکام سازه',
      severity: 8,
      occurrence: 4,
      detection: 6,
      recommendedAction: 'بازرسی اولتراسونیک',
    ),
    FmeaItem(
      id: '2',
      processName: 'رنگ‌آمیزی',
      failureMode: 'پوسته شدن رنگ',
      failureEffect: 'زنگ زدگی و ظاهر نامناسب',
      severity: 5,
      occurrence: 7,
      detection: 3,
      recommendedAction: 'کنترل دمای کوره',
    ),
    FmeaItem(
      id: '3',
      processName: 'مونتاژ موتور',
      failureMode: 'نشت روغن',
      failureEffect: 'آسیب به موتور و آلودگی',
      severity: 9,
      occurrence: 3,
      detection: 8,
      recommendedAction: 'تست فشار ۱۰۰٪',
    ),
  ];

  void _addItem(FmeaItem item) {
    setState(() {
      _items.add(item);
    });
  }

  void _deleteItem(String id) {
    setState(() {
      _items.removeWhere((item) => item.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      WorksheetScreen(
        items: _items,
        onAddItem: _addItem,
        onDeleteItem: _deleteItem,
      ),
      RpnChartScreen(items: _items),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'کاربرگ ارزیابی ریسک (FMEA)' : 'نمودار تحلیل RPN'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        centerTitle: true,
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.table_chart_outlined),
            selectedIcon: Icon(Icons.table_chart),
            label: 'کاربرگ',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'نمودارها',
          ),
        ],
      ),
    );
  }
}
