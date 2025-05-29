import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // 導入 flutter_map
import 'package:latlong2/latlong.dart'; // 導入 latlong2
import 'dart:async'; // 導入 Timer 類別
import 'package:audioplayers/audioplayers.dart'; // 導入 audioplayers
import 'dart:math'; // 導入 Random 類別，用於心率模擬

// 索引 2: 運動追蹤 - 跑步進行中的實時數據和引導 (功能 1, 2, 3, 7, 9, 10)
class TrackRunPage extends StatefulWidget {
  const TrackRunPage({super.key}); // 使用 super.key 簡化建構子

  @override
  State<TrackRunPage> createState() => _TrackRunPageState();
}

class _TrackRunPageState extends State<TrackRunPage> {
  // State variables for Pace Guidance
  bool _isMetronomePlaying = false;
  int _targetBPM = 100; // 預設 BPM 設定為 100
  // 新增 AudioPlayer 相關變數
  late AudioPlayer _audioPlayer; // 音頻播放器
  Timer? _metronomeTimer; // 節拍器定時器
  final String _metronomeSoundPath = 'audios/tick.mp3'; // 你的音效檔案路徑，請根據實際檔案名修改！

  // 計時器相關的 State variables
  final Stopwatch _stopwatch = Stopwatch(); // 用於精確計時，設為 final
  Timer? _timer; // 用於每秒更新 UI
  String _elapsedTime = '00:00:00'; // 顯示的經過時間
  bool _isRunning = false; // 新增狀態變數，追蹤計時器是否正在運行

  // 距離和配速相關的 State variables
  double _currentDistance = 0.0; // 預設距離為 0.0 公里
  String _currentPace = '00:00'; // 預設配速為 00:00 分/公里
  final double _averageSlowRunSpeedKph = 6.0; // 正常人超慢跑的速度，單位：公里/小時 (例如：6 公里/小時)

  // 心率模擬相關的 State variables
  int _currentHeartRate = 75; // 模擬初始心率
  final int _restingHeartRate = 75; // 靜止心率基礎值
  final int _runningHeartRateMin = 130; // 跑步最低心率
  final int _runningHeartRateMax = 170; // 跑步最高心率
  final Random _random = Random(); // 用於生成隨機數

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer(); // 初始化 AudioPlayer
  }

  @override
  void dispose() {
    _timer?.cancel(); // 離開頁面時取消計時器，避免內存洩漏
    _stopwatch.stop(); // 停止計時器
    _metronomeTimer?.cancel(); // 取消節拍器定時器
    _audioPlayer.dispose(); // 釋放音頻播放器資源
    super.dispose();
  }

  // 啟動計時器
  void _startTimer() {
    setState(() {
      _isRunning = true;
    });
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedTime = _formatDuration(_stopwatch.elapsed);
        _updateDistanceAndPace(); // 每秒更新距離和配速
        _updateHeartRate(); // 每秒更新心率
      });
    });
    print('計時器開始');
  }

  // 暫停計時器
  void _pauseTimer() {
    setState(() {
      _isRunning = false;
    });
    _stopwatch.stop();
    _timer?.cancel(); // 取消定時器
    print('計時器暫停');
  }

  // 重置計時器 (通常在停止跑步後使用)
  void _resetTimer() {
    // 同時停止節拍器
    if (_isMetronomePlaying) {
      _toggleMetronome(); // 停止節拍器
    }

    setState(() {
      _isRunning = false; // 停止時也應將運行狀態設為false
      _stopwatch.reset();
      _elapsedTime = '00:00:00';
      _currentDistance = 0.0; // 重置距離
      _currentPace = '00:00'; // 重置配速
      _currentHeartRate = _restingHeartRate; // 重置心率為靜止心率
    });
    _stopwatch.stop(); // 確保停止
    _timer?.cancel();
    print('計時器重置');
  }

  // 格式化時間：將 Duration 轉換為 HH:MM:SS 格式
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  // 更新距離和配速
  void _updateDistanceAndPace() {
    // 計算每秒增加的距離 (公里)
    // 速度 (km/h) / 3600 (秒/小時) = 每秒公里數
    final double distancePerSecond = _averageSlowRunSpeedKph / 3600.0;

    // 累加距離
    _currentDistance = _stopwatch.elapsed.inSeconds * distancePerSecond;

    // 計算配速 (分/公里)
    if (_currentDistance > 0) {
      // 總時間 (秒)
      final int totalElapsedSeconds = _stopwatch.elapsed.inSeconds;

      // 計算每公里所需秒數
      // 這裡將結果四捨五入到最近的整數秒，以避免浮點數精度問題導致的 59.99... = 60
      final int totalSecondsPerKm = (totalElapsedSeconds / _currentDistance).round();

      final int minutes = totalSecondsPerKm ~/ 60; // 整數除法，得到分鐘數
      final int seconds = totalSecondsPerKm % 60; // 取餘數，得到秒數 (確保在 0-59 之間)

      _currentPace = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      _currentPace = '00:00'; // 如果距離為0，配速顯示為 00:00
    }
  }

  // 模擬更新心率
  void _updateHeartRate() {
    setState(() {
      if (_isRunning) {
        // 跑步時心率上升並在一定範圍內波動
        if (_currentHeartRate < _runningHeartRateMin) {
          // 快速上升到跑步區間
          _currentHeartRate += _random.nextInt(3) + 1; // 每次增加 1-3
        } else {
          // 在跑步區間內小幅波動
          _currentHeartRate += _random.nextInt(5) - 2; // 每次變化 -2, -1, 0, 1, 2
        }
        // 限制心率在跑步區間的合理範圍內
        _currentHeartRate = _currentHeartRate.clamp(_runningHeartRateMin - 5, _runningHeartRateMax + 5);
      } else {
        // 停止或暫停時心率下降
        if (_currentHeartRate > _restingHeartRate) {
          // 快速下降到靜止區間
          _currentHeartRate -= _random.nextInt(3) + 1; // 每次減少 1-3
        } else {
          // 在靜止區間內小幅波動
          _currentHeartRate += _random.nextInt(3) - 1; // 每次變化 -1, 0, 1
        }
        // 限制心率在靜止區間的合理範圍內
        _currentHeartRate = _currentHeartRate.clamp(_restingHeartRate - 5, _restingHeartRate + 10);
      }
      // 總體限制，防止心率過高或過低
      _currentHeartRate = _currentHeartRate.clamp(50, 200);
    });
  }

  // 切換節拍器播放狀態
  void _toggleMetronome() {
    setState(() {
      _isMetronomePlaying = !_isMetronomePlaying;
    });

    if (_isMetronomePlaying) {
      _startMetronome();
      print('節拍器開始播放, BPM: $_targetBPM');
    } else {
      _stopMetronome();
      print('節拍器暫停');
    }
  }

  // 啟動節拍器音效播放
  void _startMetronome() {
    _metronomeTimer?.cancel(); // 先取消舊的定時器
    final double intervalSeconds = 60.0 / _targetBPM; // 計算每次敲擊的間隔秒數
    final Duration interval = Duration(milliseconds: (intervalSeconds * 1000).round());

    _metronomeTimer = Timer.periodic(interval, (timer) async {
      await _audioPlayer.play(AssetSource(_metronomeSoundPath));
    });
  }

  // 停止節拍器音效播放
  void _stopMetronome() {
    _metronomeTimer?.cancel(); // 取消節拍器定時器
  }

  // 調整 BPM
  void _adjustBPM(int delta) {
    setState(() {
      _targetBPM = (_targetBPM + delta).clamp(100, 200); // 限制 BPM 範圍
    });
    if (_isMetronomePlaying) {
      _startMetronome(); // 如果正在播放，重新啟動節拍器以應用新的 BPM
    }
    print('調整 BPM 至: $_targetBPM');
  }

  @override
  Widget build(BuildContext context) {
    // 地圖的初始中心點和縮放級別 (設定為嘉義市中心)
    final LatLng _initialCenter = LatLng(23.4792, 120.4497);
    final double _initialZoom = 13.0;

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
                      Column(children: [
                        const Text('時間', style: TextStyle(fontSize: 18)),
                        Text(
                          _elapsedTime, // 使用真實計時器時間
                          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                        )
                      ]),
                      Column(children: [
                        const Text('距離 (km)', style: TextStyle(fontSize: 18)),
                        Text(
                          _currentDistance.toStringAsFixed(2), // 顯示計算出的距離，保留兩位小數
                          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                        )
                      ]),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(children: [
                        const Text('配速 (分/km)', style: TextStyle(fontSize: 18)),
                        Text(
                          _currentPace, // 顯示計算出的配速
                          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                        )
                      ]),
                      Column(children: [
                        const Text('心率 (BPM)', style: TextStyle(fontSize: 18)),
                        Text(
                          _currentHeartRate.toString(), // 顯示模擬的心率
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.redAccent),
                        ) // 心率保持紅色
                      ]),
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
                  // 節拍器播放/暫停按鈕
                  IconButton(
                    icon: Icon(_isMetronomePlaying ? Icons.pause : Icons.play_arrow), // 根據狀態切換圖標
                    onPressed: _toggleMetronome, // 點擊呼叫切換方法
                    color: _isMetronomePlaying ? Colors.red : Theme.of(context).primaryColor, // 播放時紅色，暫停時主題色
                    iconSize: 30,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 地圖顯示區塊 (使用 flutter_map)
          Expanded(
            child: Card(
              elevation: 4.0,
              clipBehavior: Clip.antiAlias, // 裁剪地圖以適應 Card 的形狀
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: _initialCenter, // 修正為 initialCenter
                  initialZoom: _initialZoom, // 修正為 initialZoom
                  minZoom: 5.0, // 允許的最小縮放級別
                  maxZoom: 18.0, // 允許的最大縮放級別
                ),
                children: [
                  TileLayer(
                    // 這裡使用 OpenStreetMap 作為地圖瓦片來源
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    // 注意：userAgentPackageName 在較新版本的 flutter_map 中為必填項
                    // 請將 'com.example.your_app_name' 替換為您的應用程式包名
                    userAgentPackageName: 'com.example.run_tracker_app',
                  ),
                  // 添加中心點標記，修正 Marker 的 builder 參數為 child
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _initialCenter,
                        width: 80,
                        height: 80,
                        child: const Icon( // 將 builder 替換為 child
                          Icons.location_on,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 控制按鈕區塊
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (_isRunning) {
                    _pauseTimer(); // 如果正在運行，則暫停
                  } else {
                    _startTimer(); // 如果沒有運行，則啟動
                  }
                },
                child: Icon(
                  _isRunning ? Icons.pause : Icons.play_arrow, // 根據狀態切換圖標
                  size: 30,
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(15),
                  shape: const CircleBorder(),
                  backgroundColor: Colors.blueAccent, // 控制按鈕保留藍色
                  foregroundColor: Colors.white,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _resetTimer(); // 停止跑步追蹤並重置數據
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