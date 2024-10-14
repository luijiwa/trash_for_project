import 'package:flutter/material.dart';

void main() {
  runApp(TimelineApp());
}

// Основное приложение
class TimelineApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Custom Painter Timeline',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Custom Painter Timeline'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Timeline(
              events: [
                TimelineEvent(title: 'Event 1', time: DateTime(2023, 1, 1)),
                TimelineEvent(title: 'Event 2', time: DateTime(2023, 2, 14)),
                TimelineEvent(title: 'Event 3', time: DateTime(2023, 5, 20)),
                TimelineEvent(title: 'Event 4', time: DateTime(2023, 8, 10)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Модель события таймлайна
class TimelineEvent {
  final String title;
  final DateTime time;
  TimelineEvent({required this.title, required this.time});
}

// Таймлайн виджет
class Timeline extends StatelessWidget {
  final List<TimelineEvent> events;

  const Timeline({Key? key, required this.events}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(300, events.length * 100.0), // Устанавливаем размер для виджета
      painter: TimelinePainter(events: events),
    );
  }
}

// Painter для рисования таймлайна
class TimelinePainter extends CustomPainter {
  final List<TimelineEvent> events;
  final double circleRadius = 10.0;
  final double lineWidth = 2.0;

  TimelinePainter({required this.events});

  @override
  void paint(Canvas canvas, Size size) {
    Paint linePaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = lineWidth;

    Paint circlePaint = Paint()..color = Colors.blueAccent;

    double startX = 50; // Начало линии по X
    double startY = 50; // Начальная позиция первого события по Y

    // Проходим по каждому событию
    for (int i = 0; i < events.length; i++) {
      // Координаты для текущего события
      double circleCenterX = startX;
      double circleCenterY = startY + i * 100;

      // Рисуем соединительные линии между событиями, кроме последнего
      if (i != events.length - 1) {
        canvas.drawLine(
          Offset(circleCenterX, circleCenterY + circleRadius),
          Offset(circleCenterX, circleCenterY + 100 - circleRadius),
          linePaint,
        );
      }

      // Рисуем круг для события
      canvas.drawCircle(Offset(circleCenterX, circleCenterY), circleRadius, circlePaint);

      // Рисуем текст рядом с каждым событием
      TextSpan span = TextSpan(
        style: TextStyle(color: Colors.black, fontSize: 14),
        text: '${events[i].title}\n${events[i].time.year}-${events[i].time.month}-${events[i].time.day}',
      );
      TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
      );
      tp.layout();

      // Рисуем текст справа от круга
      tp.paint(canvas, Offset(circleCenterX + 20, circleCenterY - circleRadius));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
