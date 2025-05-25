import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

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
    const DashboardPage(),        // 索引 0: 主頁/儀表板
    const ToolsPage(),            // 索引 1: 工具 (新的分頁)
    const TrackRunPage(),         // 索引 2: 運動
    const DataAnalysisPage(),     // 索引 3: 紀錄
    const RoutesPage(),           // 索引 4: 路線
    const TrainingPage(),         // 索引 5: 教學
  ];

  // 處理 BottomNavigationBar 項目點擊事件
  void _onItemTapped(int index) {
    setState(() {
      // BottomNavigationBar 的索引從 0 開始，對應 _pages 列表中的索引 1-5
      _selectedIndex = index + 1;
    });
  }

  // 定義 BottomNavigationBar 的項目列表
  final List<BottomNavigationBarItem> _bottomItems = const [
    // 對應 _pages[1] - 工具 (新的項目)
    BottomNavigationBarItem(icon: Icon(Icons.build), label: '工具'), // 使用工具箱圖示，標籤為「工具」
    // 對應 _pages[2] - 運動
    BottomNavigationBarItem(icon: Icon(Icons.directions_run), label: '運動'),
    // 對應 _pages[3] - 紀錄
    BottomNavigationBarItem(icon: Icon(Icons.analytics), label: '紀錄'),
    // 對應 _pages[4] - 路線
    BottomNavigationBarItem(icon: Icon(Icons.map), label: '路線'),
    // 對應 _pages[5] - 教學
    BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: '教學'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.directions_run_outlined, color: Colors.white), // 圖示可調整
        backgroundColor: Colors.transparent, // AppBar 背景透明，以便顯示 FlexibleSpace 的漸層
        elevation: 0, // 移除 AppBar 的陰影
        flexibleSpace: Container(
          decoration: BoxDecoration( // BoxDecoration 允許設定漸層
            gradient: LinearGradient( // 嘗試新的柔和漸層顏色
              colors: [Colors.blueGrey[600]!, Colors.teal[300]!], // 使用較柔和的藍灰和藍綠色
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          // AppBar 的 Home 按鈕，導回 _pages[0] (DashboardPage)
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              setState(() {
                _selectedIndex = 0;
              });
            },
            color: Colors.white, // 確保圖示在深色漸層背景上可見
          ),
        ],
        // AppBar 標題可以選擇性添加，但原設計沒有所以保留
        // title: Text('超慢跑 App', style: TextStyle(color: Colors.white)),
      ),
      // 根據 _selectedIndex 顯示對應的頁面內容
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomItems,
        // BottomNavigationBar 的 currentIndex 需要對應 _pages 列表的索引 1-5
        // 當 _selectedIndex 為 0 時 (DashboardPage)，BottomNavigationBar 不應該有選中項
        currentIndex: _selectedIndex == 0 ? 0 : _selectedIndex - 1,
        selectedItemColor: Theme.of(context).primaryColor, // 使用主題的 primaryColor 作為選中顏色
        unselectedItemColor: Colors.grey, // 未選中顏色
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // 固定 BottomNavigationBarItems 的大小
        backgroundColor: Colors.white, // BottomNavigationBar 背景顏色
        elevation: 8.0, // BottomNavigationBar 陰影
      ),
    );
  }
}

// --- 各分頁的程式碼 (包含完善外觀的變更和新配色) ---

// 索引 0: 主頁/儀表板
class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    int mockRunStreak = 10; // 模擬數據
    double mockTotalDistance = 55.6;
    int mockTotalRuns = 15;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 日曆顯示跑步日期
        Card( // 日曆外層加 Card 增加立體感
          elevation: 2.0,
          child: TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: today,
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Theme.of(context).primaryColor, // 使用主題 primaryColor
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration( // 模擬跑步日期的標記
                color: Theme.of(context).colorScheme.secondary, // 使用主題 secondaryColor
                shape: BoxShape.circle,
              ),
              canMarkersOverflow: true,
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            // 模擬標記有跑步活動的日子
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                // 這裡可以根據 date 是否有跑步紀錄來顯示標記
                // 簡單模擬：假設本月 10, 15, 20, 25 有跑步
                final runDays = [10, 15, 20, 25];
                if (date.month == today.month && runDays.contains(date.day)) {
                  return Positioned(
                    right: 1,
                    bottom: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary, // 使用主題 secondaryColor
                        shape: BoxShape.circle,
                      ),
                      width: 8.0,
                      height: 8.0,
                    ),
                  );
                }
                return null;
              },
            ),
          ),
        ),
        const SizedBox(height: 32),
        const Text(
          '超慢跑總覽',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 18),
        // 總計數據卡片
        Card(
          elevation: 2.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text('總距離', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('${mockTotalDistance.toStringAsFixed(1)} km', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)), // 使用主題 primaryColor
                  ],
                ),
                Column(
                  children: [
                    const Text('總次數', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('$mockTotalRuns 次', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)), // 使用主題 primaryColor
                  ],
                ),
                Column(
                  children: [
                    const Text('連續達成', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('$mockRunStreak 天', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)), // 使用主題 primaryColor
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: 點擊此按鈕開始跑步追蹤，導航到 TrackRunPage 並啟動功能 (對應功能 1, 7, 9, 10)
              print('開始跑步!');
            },
            icon: const Icon(Icons.play_arrow),
            label: const Text('開始跑步', style: TextStyle(fontSize: 20)),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              backgroundColor: Theme.of(context).primaryColor, // 使用主題 primaryColor
              foregroundColor: Colors.white, // 文字顏色
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        const Text(
          '最近跑步紀錄',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        Card( // 最近一次跑步總結 (模擬列表項)
          elevation: 1.0,
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          child: ListTile(
            leading: Icon(Icons.run_circle, color: Theme.of(context).primaryColor), // 使用主題 primaryColor
            title: const Text('2023/10/26 - 3.5 km', style: TextStyle(fontSize: 18)),
            subtitle: const Text('時間: 30:00, 配速: 8:30 / km', style: TextStyle(fontSize: 16)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: 點擊查看單次跑步詳細紀錄，導航到 DataAnalysisPage 的詳細頁面
              print('查看 2023/10/26 跑步詳細!');
            },
          ),
        ),
        Card( // 另一個模擬列表項
          elevation: 1.0,
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          child: ListTile(
            leading: Icon(Icons.run_circle, color: Theme.of(context).primaryColor), // 使用主題 primaryColor
            title: const Text('2023/10/24 - 3.0 km', style: TextStyle(fontSize: 18)),
            subtitle: const Text('時間: 26:15, 配速: 8:45 / km', style: TextStyle(fontSize: 16)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: 點擊查看單次跑步詳細紀錄
              print('查看 2023/10/24 跑步詳細!');
            },
          ),
        ),
        // 可以添加更多最近紀錄項目
      ],
    );
  }
}

// 索引 1: 工具 - GPX、裝置、設定等
class ToolsPage extends StatelessWidget {
  const ToolsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          '工具與設定', // 新頁面標題
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        // 跑步相關設定區塊 (從原來的 ProfileSettingsPage 移過來，與功能 2, 3 相關)
        Card(
          elevation: 2.0,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('跑步設定', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                ListTile(
                  leading: Icon(Icons.music_note, color: Theme.of(context).primaryColor), // 使用主題 primaryColor
                  title: const Text('步頻節奏引導設定', style: TextStyle(fontSize: 18)),
                  trailing: const Icon(Icons.chevron_right),
                  // TODO: 點擊後導航到步頻設定頁面 (功能 2 設定)
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.accessibility_new, color: Theme.of(context).primaryColor), // 使用主題 primaryColor
                  title: const Text('姿勢矯正提醒設定', style: TextStyle(fontSize: 18)),
                  trailing: const Icon(Icons.chevron_right),
                  // TODO: 點擊後導航到姿勢提醒設定頁面 (功能 3 設定)
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        // GPX 工具區塊 (功能 9, 10 相關)
        Card(
          elevation: 2.0,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('GPX 工具', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                ListTile( // 匯入 GPX
                    leading: Icon(Icons.file_upload, color: Theme.of(context).primaryColor), // 使用主題 primaryColor
                    title: const Text('匯入 GPX 檔案', style: TextStyle(fontSize: 18)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: 實現 GPX 匯入功能
                      print('匯入 GPX');
                    }
                ),
                const Divider(),
                ListTile( // 匯出 GPX
                    leading: Icon(Icons.file_download, color: Theme.of(context).primaryColor), // 使用主題 primaryColor
                    title: const Text('匯出跑步紀錄為 GPX', style: TextStyle(fontSize: 18)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: 實現 GPX 匯出功能
                      print('匯出 GPX');
                    }
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        // 穿戴裝置區塊 (功能 10 相關設定)
        Card(
          elevation: 2.0,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('穿戴裝置', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                ListTile(
                    leading: Icon(Icons.watch, color: Theme.of(context).primaryColor), // 使用主題 primaryColor
                    title: const Text('連接新的裝置', style: TextStyle(fontSize: 18)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: 導航到裝置配對頁面
                      print('連接裝置');
                    }
                ),
                const Divider(),
                ListTile(
                    leading: Icon(Icons.bluetooth_connected, color: Theme.of(context).primaryColor), // 使用主題 primaryColor
                    title: const Text('已連接裝置', style: TextStyle(fontSize: 18)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: 導航到已連接裝置列表頁面
                      print('查看已連接裝置');
                    }
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        // 通用設定區塊 (單位、通知等)
        Card(
          elevation: 2.0,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('通用設定', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                ListTile(
                  leading: Icon(Icons.straighten, color: Theme.of(context).primaryColor), // 使用主題 primaryColor
                  title: const Text('單位設定 (公里/英里)', style: TextStyle(fontSize: 18)),
                  trailing: const Icon(Icons.chevron_right),
                  // TODO: 點擊後導航到單位設定頁面
                ),
                const Divider(),
                ListTile(
                  leading: Icon(Icons.notifications_none, color: Theme.of(context).primaryColor), // 使用主題 primaryColor
                  title: const Text('通知設定', style: TextStyle(fontSize: 18)),
                  trailing: const Icon(Icons.chevron_right),
                  // TODO: 點擊後導航到通知設定頁面
                ),
                // TODO: 添加更多通用設定項目
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        // 關於 App (範例)
        Card(
          elevation: 2.0,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            leading: Icon(Icons.info_outline, color: Theme.of(context).primaryColor), // 使用主題 primaryColor
            title: const Text('關於 App', style: TextStyle(fontSize: 18)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: 顯示 App 資訊或導航到關於頁面
              print('關於 App');
            },
          ),
        ),
        const SizedBox(height: 20),
        // 登出按鈕 (從原來的 ProfileSettingsPage 移過來)
        Center(
          child: ElevatedButton(
            onPressed: () {
              // TODO: 實現登出功能
              print('登出');
            },
            child: const Text('登出'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent), // 登出按鈕保持紅色，表示危險操作
          ),
        )
      ],
    );
  }
}

// 索引 2: 運動追蹤 - 跑步進行中的實時數據和引導 (功能 1, 2, 3, 7, 9, 10)
class TrackRunPage extends StatefulWidget {
  const TrackRunPage({Key? key}) : super(key: key);

  @override
  State<TrackRunPage> createState() => _TrackRunPageState();
}

class _TrackRunPageState extends State<TrackRunPage> {
  // State variables for Pace Guidance
  bool _isMetronomePlaying = false;
  int _targetBPM = 180; // Default target BPM for slow running

  void _toggleMetronome() {
    setState(() {
      _isMetronomePlaying = !_isMetronomePlaying;
      // TODO: Implement actual metronome/music playback logic here
      if (_isMetronomePlaying) {
        print('節拍器開始播放, BPM: $_targetBPM');
      } else {
        print('節拍器暫停');
      }
    });
  }

  void _adjustBPM(int delta) {
    setState(() {
      _targetBPM = (_targetBPM + delta).clamp(100, 200); // Clamp BPM to a reasonable range
      // TODO: Update metronome/music tempo if playing
      print('調整 BPM 至: $_targetBPM');
    });
  }

  @override
  Widget build(BuildContext context) {
    // 模擬實時數據
    String mockTime = '00:15:30';
    String mockDistance = '2.55'; // km
    String mockPace = '6:05'; // min/km
    String mockHeartRate = '135'; // BPM

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 實時數據顯示區塊
          Card(
            elevation: 4.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(children: [const Text('時間', style: TextStyle(fontSize: 18)), Text(mockTime, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor))]), // 使用主題 primaryColor
                      Column(children: [const Text('距離 (km)', style: TextStyle(fontSize: 18)), Text(mockDistance, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor))]), // 使用主題 primaryColor
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(children: [const Text('配速 (分/km)', style: TextStyle(fontSize: 18)), Text(mockPace, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor))]), // 使用主題 primaryColor
                      Column(children: [const Text('心率 (BPM)', style: TextStyle(fontSize: 18)), Text(mockHeartRate, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.redAccent))]), // 心率保持紅色
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 步頻節奏引導區塊 (功能 2)
          Card(
            elevation: 4.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('步頻節奏', style: TextStyle(fontSize: 18)),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => _adjustBPM(-5),
                        color: Theme.of(context).primaryColor, // 使用主題 primaryColor
                      ),
                      Text('$_targetBPM BPM', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)), // 使用主題 primaryColor
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => _adjustBPM(5),
                        color: Theme.of(context).primaryColor, // 使用主題 primaryColor
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(_isMetronomePlaying ? Icons.pause : Icons.play_arrow),
                    onPressed: _toggleMetronome,
                    color: _isMetronomePlaying ? Colors.red : Theme.of(context).primaryColor, // 播放按鈕使用主題 primaryColor，暫停使用紅色
                    iconSize: 30,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 地圖顯示區塊 (使用圖片作為佔位符) (功能 7, 9, 10 - 軌跡)
          Expanded(
            child: Card( // 保留 Card 可以提供陰影和圓角效果
              elevation: 4.0,
              clipBehavior: Clip.antiAlias, // 裁剪圖片以適應 Card 的形狀
              child: Image.asset(
                'assets/map.jpg', // <-- 請將 'assets/map.jpg' 替換為你的圖片路徑
                fit: BoxFit.cover, // 讓圖片覆蓋可用空間
                errorBuilder: (context, error, stackTrace) {
                  // 如果圖片載入失敗或路徑不對，顯示一個提示
                  return Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Text('地圖圖片載入失敗或不存在\n請確認圖片路徑和 pubspec.yaml 設定', textAlign: TextAlign.center, style: TextStyle(color: Colors.red)),
                    ),
                  );
                },
              ),
              // TODO: 將來這裡應該替換為實際的地圖 Widget
            ),
          ),
          const SizedBox(height: 16),
          // 控制按鈕區塊
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  // TODO: 暫停跑步追蹤
                  print('暫停');
                },
                child: const Icon(Icons.pause, size: 30),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(15),
                  shape: const CircleBorder(),
                  backgroundColor: Colors.blueAccent, // 控制按鈕保留藍色
                  foregroundColor: Colors.white,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // TODO: 停止跑步追蹤並保存數據
                  print('停止');
                },
                child: const Icon(Icons.stop, size: 30),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(15),
                  shape: const CircleBorder(),
                  backgroundColor: Colors.redAccent, // 停止按鈕保持紅色
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          // TODO: 可以添加姿勢提醒的視覺指示器或文字提示 (功能 3)
        ],
      ),
    );
  }
}


// 索引 3: 紀錄 - 數據統計、分析與建議 (功能 5, 6)
class DataAnalysisPage extends StatelessWidget {
  const DataAnalysisPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 模擬跑步歷史數據 (更多數據)
    final mockRunData = const [
      {'date': '2025/4/29', 'distance': '4.2', 'pace': '8:10', 'bpm': 82, 'time': '34:20'},
      {'date': '2025/4/27', 'distance': '3.8', 'pace': '8:18', 'bpm': 79, 'time': '31:30'},
      {'date': '2025/4/26', 'distance': '3.5', 'pace': '8:30', 'bpm': 75, 'time': '30:00'},
      {'date': '2025/4/24', 'distance': '3.0', 'pace': '8:45', 'bpm': 72, 'time': '26:15'},
      {'date': '2025/4/22', 'distance': '4.0', 'pace': '8:20', 'bpm': 78, 'time': '33:20'},
      {'date': '2025/4/20', 'distance': '3.2', 'pace': '8:38', 'bpm': 74, 'time': '27:30'},
      {'date': '2025/4/18', 'distance': '3.8', 'pace': '8:15', 'bpm': 80, 'time': '31:20'},
      {'date': '2025/4/15', 'distance': '3.0', 'pace': '8:50', 'bpm': 70, 'time': '26:30'},
      {'date': '2025/4/12', 'distance': '4.5', 'pace': '8:05', 'bpm': 85, 'time': '36:20'},
      {'date': '2025/4/10', 'distance': '3.3', 'pace': '8:40', 'bpm': 73, 'time': '28:40'},
    ];

    // 隨機編寫的模擬運動建議 (功能 6)
    const List<String> dummySuggestions = [
      '根據您的近期表現，建議您本週的跑步總距離可以挑戰增加 15%，但請注意身體的反應。',
      '您的平均步頻穩定維持在 175 SPM 左右，這是一個非常適合超慢跑的頻率，請繼續保持。',
      '心率數據顯示您在跑步過程中能夠保持在目標心率區間，這對提升有氧能力非常有幫助。',
      '記得安排充足的休息日，讓身體充分恢復。',
      '嘗試在下一次跑步時，將注意力放在保持上半身挺直，這有助於改善跑步姿勢。',
      '每週納入 1-2 次的力量訓練，特別是核心和腿部力量，將有助於提升跑步效率和預防運動傷害。',
      '注意到您在月中的跑步次數有所增加，保持這樣的頻率對健康非常有益。',
      '您的最快配速有所提升，但超慢跑的重點在於低強度穩定運動，請根據身體感覺調整。',
    ];

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          '跑步數據與分析',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        const Text('數據總覽', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), // 功能 5
        const SizedBox(height: 10),
        Card( // 總體統計卡片
          elevation: 2.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(children: [const Text('總距離(km)', style: TextStyle(fontSize: 16)), Text('55.6', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor))]), // 使用主題 primaryColor
                Column(children: [const Text('總次數', style: TextStyle(fontSize: 16)), Text('15', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor))]), // 使用主題 primaryColor
                Column(children: [const Text('平均配速', style: TextStyle(fontSize: 16)), Text('8:35', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor))]), // 使用主題 primaryColor
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text('數據趨勢圖表', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), // 功能 5
        const SizedBox(height: 10),
// ... 其他程式碼 ...

        Card( // 圖表顯示區
          elevation: 2.0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('過去7天平均配速趨勢 (分/km)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 模擬垂直度量衡
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          Text('6:00', style: TextStyle(fontSize: 12)),
                          Text('7:00', style: TextStyle(fontSize: 12)),
                          Text('8:00', style: TextStyle(fontSize: 12)),
                          Text('9:00', style: TextStyle(fontSize: 12)),
                          Text('10:00', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      const SizedBox(width: 8), // 度量衡和圖表區域之間的間距
                      Expanded( // 確保圖表區域佔據剩餘空間
                        child: Row( // 這個 Row 用來放置每天的柱子和標籤組成的 Column
                          mainAxisAlignment: MainAxisAlignment.spaceAround, // 平均分佈每天的數據 Column
                          crossAxisAlignment: CrossAxisAlignment.end, // 讓每天的 Column 底部對齊
                          children: List.generate(7, (index) { // 模擬 7 個數據點 (7天)
                            // ... 柱子高度計算邏輯不變 ...
                            double simulatedPaceSeconds = 8 * 60 + (30 - index * 5) + (index % 2) * 10;
                            double minScalePaceSeconds = 6 * 60.0;
                            double maxScalePaceSeconds = 10 * 60.0;
                            double scaleRange = maxScalePaceSeconds - minScalePaceSeconds;
                            double heightRatio = 1.0 - (simulatedPaceSeconds - minScalePaceSeconds) / scaleRange;
                            heightRatio = heightRatio.clamp(0.0, 1.0);
                            double barHeight = heightRatio * 200.0;
                            if (barHeight < 10) barHeight = 10;

                            return Expanded( // 讓每個 Column 平均佔據 Row 的空間
                              child: Column( // 將柱子和星期幾標籤放在同一個 Column
                                mainAxisAlignment: MainAxisAlignment.end, // 讓內容靠底部對齊 (柱子和文字)
                                crossAxisAlignment: CrossAxisAlignment.center, // 水平居中
                                children: [
                                  Container( // 柱狀圖
                                    width: 25, // 柱子寬度
                                    height: barHeight,
                                    color: Theme.of(context).primaryColor,
                                    // Removed horizontal margin here as spacing is handled by Expanded and Column alignment
                                  ),
                                  const SizedBox(height: 4), // 柱子和星期幾標籤之間的間距
                                  Text(['一', '二', '三', '四', '五', '六', '日'][index], style: const TextStyle(fontSize: 12)), // 星期幾標籤
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                // Removed the separate Row for X-axis labels here
              ],
            ),
          ),
        ),

// ... 其他程式碼 ...
        const SizedBox(height: 30),
        const Text('運動建議', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), // 功能 6
        const SizedBox(height: 10),
        Card( // 運動建議區塊 (模擬多條建議)
          elevation: 1.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // 使用 map 將建議列表轉換為 Widget 列表
              children: dummySuggestions.map((suggestion) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0), // 調整建議之間的間距
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.lightbulb_outline, size: 20, color: Theme.of(context).primaryColor), // 小燈泡圖示使用主題 primaryColor
                    const SizedBox(width: 10), // 圖示和文字間距
                    Expanded( // 使用 Expanded 讓文字自動換行
                      child: Text(suggestion, style: const TextStyle(fontSize: 16, height: 1.4)), // 調整行高
                    ),
                  ],
                ),
              )).toList(),
            ),
          ),
        ),
        const SizedBox(height: 30),
        const Text('跑步歷史紀錄', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), // 功能 5
        const SizedBox(height: 10),
        // 跑步歷史列表 (使用模擬數據)
        ...mockRunData
            .map((entry) => Card( // 跑步歷史列表項目
          elevation: 1.0,
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          child: ListTile(
            leading: Icon(Icons.run_circle, color: Theme.of(context).primaryColor), // 圖示使用主題 primaryColor
            title: Text('${entry['date']} - ${entry['distance']} km', style: const TextStyle(fontSize: 18)),
            subtitle: Text('時間: ${entry['time']}, 配速: ${entry['pace']} / km, 心率: ${entry['bpm']} BPM', style: const TextStyle(fontSize: 16)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: 點擊查看單次跑步詳細紀錄頁面
              print('查看 ${entry['date']} 跑步詳細!');
            },
          ),
        ))
            .toList(),
      ],
    );
  }
}

// 索引 4: 路線 - 路線推薦與 GPX (功能 8, 部分 9/10)
class RoutesPage extends StatelessWidget {
  const RoutesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 模擬推薦路線數據
    final mockRoutes = [
      {'name': '公園環湖路線', 'distance': '3.0 km', 'duration': '約 30 分鐘'},
      {'name': '河濱自行車道', 'distance': '5.2 km', 'duration': '約 50 分鐘'},
    ];

    // 模擬已儲存路線數據 (這個區塊的功能已部分移至工具頁，這裡只保留列表外觀)
    final mockSavedRoutes = [
      {'name': '我家附近的路線 A', 'distance': '2.5 km'},
      {'name': '學校操場路線', 'distance': '1.2 km'},
    ];

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          '跑步路線',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Card( // 路線推薦區塊 (功能 8)
          elevation: 2.0,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('推薦路線', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                const Text('根據您的位置推薦周圍的優質跑步路線：', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                ...mockRoutes.map((route) => ListTile( // 模擬推薦路線列表項
                  leading: Icon(Icons.map_outlined, color: Theme.of(context).colorScheme.secondary), // 使用主題 secondaryColor
                  title: Text(route['name']!, style: const TextStyle(fontSize: 18)),
                  subtitle: Text('${route['distance']}, ${route['duration']}', style: const TextStyle(fontSize: 16)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: 點擊查看推薦路線詳情或導航
                    print('查看推薦路線: ${route['name']}');
                  },
                )).toList(),
                const SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: 實現尋找更多推薦路線功能 (功能 8)
                      print('尋找更多推薦路線!');
                    },
                    child: const Text('尋找更多路線'),
                    style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor, foregroundColor: Colors.white), // 使用主題 primaryColor
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Card( // 已儲存路線區塊 (保留列表外觀)
          elevation: 2.0,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('已儲存路線', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                ...mockSavedRoutes.map((route) => ListTile( // 模擬已儲存路線列表項
                  leading: Icon(Icons.save, color: Theme.of(context).primaryColor), // 使用主題 primaryColor
                  title: Text(route['name']!, style: const TextStyle(fontSize: 18)),
                  subtitle: Text('${route['distance']}', style: const TextStyle(fontSize: 16)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: 點擊查看已儲存路線詳情或用於運動
                    print('查看已儲存路線: ${route['name']}');
                  },
                )).toList(),
              ],
            ),
          ),
        ),
        // 原來的 GPX 工具區塊已移至 ToolsPage
      ],
    );
  }
}

// 索引 5: 教學 - 動作展示與學習 (功能 4)
class TrainingPage extends StatelessWidget {
  const TrainingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 模擬教學內容數據
    final mockTrainingItems = const [
      {'title': '正確的跑步姿勢', 'subtitle': '觀看教學影片', 'icon': Icons.accessibility_new},
      {'title': '超慢跑步頻練習', 'subtitle': '學習如何找到適合的步頻', 'icon': Icons.music_note},
      {'title': '跑步前熱身運動', 'subtitle': '避免運動傷害', 'icon': Icons.whatshot},
      {'title': '跑步後拉伸運動', 'subtitle': '加速恢復', 'icon': Icons.fitness_center},
    ];

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          '跑步技巧與教學',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        ...mockTrainingItems.map((item) => Card( // 教學項目卡片
          elevation: 2.0,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            leading: Icon(item['icon'] as IconData?, color: Theme.of(context).primaryColor), // 使用主題 primaryColor
            // 修正：明確將 title 和 subtitle 轉換為 String
            title: Text(item['title']! as String, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            subtitle: Text(item['subtitle']! as String, style: const TextStyle(fontSize: 16)),
            trailing: Icon(Icons.play_circle_fill, color: Theme.of(context).colorScheme.secondary, size: 30), // 使用主題 secondaryColor
            onTap: () {
              // TODO: 點擊後播放教學影片或顯示詳細步驟 (功能 4)
              print('點擊教學: ${item['title']}');
            },
          ),
        )).toList(),
        // 可添加更多教學內容或分類
      ],
    );
  }
}