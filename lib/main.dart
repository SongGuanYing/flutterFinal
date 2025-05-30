import 'package:flutter/material.dart';
import 'profile.dart';
import 'map.dart';
import 'route.dart';
import 'teach.dart';
import 'main_page.dart';

import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
// 引入外部套件，如果需要更逼真的外觀可以考慮
// import 'package:fl_chart/fl_chart.dart'; // 範例：用於數據圖表
// import 'package:Maps_flutter/Maps_flutter.dart'; // 範例：用於地圖

// 主應用程式入口
void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 設定 App 的主要主題顏色
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal, // 使用藍綠色系作為主要的 Material 3 配色基礎
        // 其他主題設定可以在這裡調整，例如 字體、卡片陰影等
      ),
      home: const HomeScreen(),
    );
  }
}

// 主畫面 Scaffold，包含 AppBar 和 BottomNavigationBar
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 追蹤當前選中的頁面索引
  int _selectedIndex = 0;

  // 定義所有頁面 Widget 列表，順序對應 _selectedIndex
  // 索引 0 對應 AppBar 的 Home 按鈕
  // 索引 1-5 對應 BottomNavigationBar 的項目
  final List<Widget> _pages = [
    const route(),           // 索引 4: 路線
    const map(),         // 索引 2: 運動
    const main_page(),        // 索引 0: 主頁/儀表板
    const teach(),         // 索引 5: 教學
    const profile(),            // 索引 1: 工具 (新的分頁)
  ];

  // 處理 BottomNavigationBar 項目點擊事件
  void _onItemTapped(int index) {
    setState(() {
      // BottomNavigationBar 的索引從 0 開始，對應 _pages 列表中的索引 1-5
      _selectedIndex = index;
    });
  }

  // 定義 BottomNavigationBar 的項目列表
  final List<BottomNavigationBarItem> _bottomItems = const [
    BottomNavigationBarItem(icon: Icon(Icons.map), label: '路線'),
    BottomNavigationBarItem(icon: Icon(Icons.directions_run), label: '運動'),
    BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: '首頁'),
    BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: '教學'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: '使用者'), // 使用工具箱圖示，標籤為工具
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.directions_run_outlined, color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueGrey[600]!, Colors.teal[300]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        // Removed the home button from actions
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomItems,
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 8.0,
      ),
    );
  }
}

// --- 各分頁的程式碼 (包含完善外觀的變更和新配色) ---

void db() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 定義資料庫路徑
  final databasePath = join(await getDatabasesPath(), 'doggie2_database.db');

  final database;
  // 檢查資料庫是否已存在
  bool exists = await databaseExists(databasePath);
  if (exists) {
    print('資料庫已存在: $databasePath');
    database = openDatabase(
      databasePath,
      version: 1,
    );
  } else {
    print('資料庫不存在，將創建新資料庫: $databasePath');
    database = openDatabase(
      databasePath,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
        );
      },
      version: 1,
    );
  }

  // Define a function that inserts dogs into the database
  Future<void> insertDog(Dog dog) async {
    // Get a reference to the database.
    final db = await database;

    // Insert the Dog into the correct table. You might also specify the
    // conflictAlgorithm to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'dogs',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the dogs from the dogs table.
  Future<List<Dog>> dogs() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all the dogs.
    final List<Map<String, Object?>> dogMaps = await db.query('dogs');

    // Convert the list of each dog's fields into a list of Dog objects.
    return [
      for (final {'id': id as int, 'name': name as String, 'age': age as int}
      in dogMaps)
        Dog(id: id, name: name, age: age),
    ];
  }

  Future<void> updateDog(Dog dog) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Dog.
    await db.update(
      'dogs',
      dog.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [dog.id],
    );
  }

  Future<void> deleteDog(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      'dogs',
      // Use a where clause to delete a specific dog.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  // Create a Dog and add it to the dogs table
  var fido = Dog(id: 5, name: 'Hello5', age: 55);

  await insertDog(fido);

  // Now, use the method above to retrieve all the dogs.
  print(await dogs()); // Prints a list that include Fido.

  // Update Fido's age and save it to the database.
  //fido = Dog(id: fido.id, name: fido.name, age: fido.age + 7);
  //await updateDog(fido);

  // Print the updated results.
  //print(await dogs()); // Prints Fido with age 42.

  // Delete Fido from the database.
  //await deleteDog(fido.id);

  // Print the list of dogs (empty).
  //print(await dogs());

  print(await getDatabasesPath());
}

class Dog {
  final int id;
  final String name;
  final int age;

  Dog({required this.id, required this.name, required this.age});

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, Object?> toMap() {
    return {'id': id, 'name': name, 'age': age};
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Dog{id: $id, name: $name, age: $age}';
  }
}