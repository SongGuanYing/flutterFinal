import 'package:flutter/material.dart';

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