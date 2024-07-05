import 'package:arange/pages/arange_page.dart';
import 'package:arange/provider/arange_provider.dart';
import 'package:arange/service/arange_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  ArangeService service = ArangeService();
  WidgetsFlutterBinding.ensureInitialized();
  await service.load();
  
  ArangeProvider provider = ArangeProvider(service);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => provider)
    ],
    child: const MyApp()
    ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ARange',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ARangePage(),
    );
  }
}
