import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateSelector extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const DateSelector({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  bool _isCalendarOpen = false;
  late DateTime _focusedMonth;

  @override
  void initState() {
    super.initState();
    _focusedMonth = widget.selectedDate;
  }

  String _getRelativeDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final tomorrow = today.add(const Duration(days: 1));

    final targetDate = DateTime(date.year, date.month, date.day);

    if (targetDate.isAtSameMomentAs(today)) {
      return '오늘';
    } else if (targetDate.isAtSameMomentAs(yesterday)) {
      return '어제';
    } else if (targetDate.isAtSameMomentAs(tomorrow)) {
      return '내일';
    } else {
      return '';
    }
  }

  // 달력 UI를 그리는 함수
  Widget _buildCalendar() {
    final year = _focusedMonth.year;
    final month = _focusedMonth.month;
    final firstDayOfMonth = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final weekdayOfFirstDay = firstDayOfMonth.weekday;

    return Column(
      children: [
        // 월 이동 헤더 ( < 2025년 9월 > )
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 16),
              onPressed: () {
                setState(() {
                  _focusedMonth = DateTime(year, month - 1);
                });
              },
            ),
            Text(
              DateFormat('yyyy년 M월', 'ko_KR').format(_focusedMonth),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, size: 16),
              onPressed: () {
                setState(() {
                  _focusedMonth = DateTime(year, month + 1);
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        // 요일 표시 (일, 월, 화, 수, 목, 금, 토)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['일', '월', '화', '수', '목', '금', '토']
              .map((day) => Text(day, style: const TextStyle(fontWeight: FontWeight.bold)))
              .toList(),
        ),
        const SizedBox(height: 10),
        // 날짜 그리드
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
          ),
          itemCount: daysInMonth + weekdayOfFirstDay - 1,
          itemBuilder: (context, index) {
            if (index < weekdayOfFirstDay - 1) {
              return Container(); // 빈 칸
            }
            final day = index - (weekdayOfFirstDay - 2);
            final date = DateTime(year, month, day);
            final isSelected = date.year == widget.selectedDate.year &&
                date.month == widget.selectedDate.month &&
                date.day == widget.selectedDate.day;

            return GestureDetector(
              onTap: () {
                widget.onDateSelected(date);
                // 날짜 선택 시 달력은 닫히도록 설정
                setState(() {
                  _isCalendarOpen = false;
                });
              },
              child: Container(
                margin: const EdgeInsets.all(4),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$day',
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('M/d', 'ko_KR');

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 5),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // '어제', '오늘', '내일' 버튼
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // ✅ 3. 변경된 _buildDateButton 함수를 호출합니다.
              _buildDateButton(context, -1, formatter),
              _buildDateButton(context, 0, formatter),
              _buildDateButton(context, 1, formatter),
            ],
          ),
          // 4. 달력 열기/닫기 화살표 버튼
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: Icon(
              _isCalendarOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            ),
            onPressed: () {
              setState(() {
                _isCalendarOpen = !_isCalendarOpen;
              });
            },
          ),
          if (_isCalendarOpen) _buildCalendar(),
        ],
      ),
    );
  }

  Widget _buildDateButton(BuildContext context, int offset, DateFormat formatter) {
    final date = widget.selectedDate.add(Duration(days: offset));
    final label = _getRelativeDateLabel(date);
    final isSelected = offset == 0;
    final formattedDate = formatter.format(date);

    return InkWell(
      onTap: () => widget.onDateSelected(date),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Text(
              formattedDate,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: 18,
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black54,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

