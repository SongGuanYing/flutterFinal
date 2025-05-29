import 'package:flutter/material.dart';

// 索引 2: 運動追蹤 - 跑步進行中的實時數據和引導 (功能 1, 2, 3, 7, 9, 10)
class map extends StatefulWidget {
  const map({Key? key}) : super(key: key);

  @override
  State<map> createState() => _TrackRunPageState();
}

class _TrackRunPageState extends State<map> {
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