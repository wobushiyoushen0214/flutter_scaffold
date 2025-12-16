import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_getx_dio_scaffold/common/constants/app_colors.dart';
import '../controllers/statistics_controller.dart';

class StatisticsView extends GetView<StatisticsController> {
  const StatisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('统计'),
        actions: [
          // 图表切换按钮
          IconButton(
            icon: Obx(
              () => Icon(
                controller.selectedChartType.value == ChartType.pie
                    ? Icons.bar_chart
                    : Icons.pie_chart,
              ),
            ),
            onPressed: controller.toggleChartType,
            tooltip: '切换图表',
          ),
          // 收支切换按钮
          IconButton(
            icon: Obx(
              () => Icon(
                controller.selectedType.value == 'expense'
                    ? Icons.money_off
                    : Icons.attach_money,
              ),
            ),
            onPressed: controller.toggleType,
            tooltip: controller.selectedType.value == 'expense'
                ? '切换为收入'
                : '切换为支出',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildPeriodTabs(),
          _buildDateSelector(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildChartArea(),
                  const SizedBox(height: 24),
                  _buildCategoryList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodTabs() {
    return Container(
      color: Get.theme.cardTheme.color,
      child: Obx(
        () => Row(
          children: [
            _buildTabItem('日', StatisticsPeriod.day),
            _buildTabItem('月', StatisticsPeriod.month),
            _buildTabItem('年', StatisticsPeriod.year),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(String label, StatisticsPeriod period) {
    final isSelected = controller.selectedPeriod.value == period;
    return Expanded(
      child: InkWell(
        onTap: () => controller.setPeriod(period),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? AppColors.primary : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: Get.theme.cardTheme.color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: controller.previousPeriod,
          ),
          Obx(() {
            final date = controller.selectedDate.value;
            String text;
            switch (controller.selectedPeriod.value) {
              case StatisticsPeriod.day:
                text = DateFormat('yyyy年 MM月 dd日').format(date);
                break;
              case StatisticsPeriod.month:
                text = DateFormat('yyyy年 MM月').format(date);
                break;
              case StatisticsPeriod.year:
                text = DateFormat('yyyy年').format(date);
                break;
            }
            return Text(
              text,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            );
          }),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: controller.nextPeriod,
          ),
        ],
      ),
    );
  }

  Widget _buildChartArea() {
    return Obx(() {
      if (controller.filteredTransactions.isEmpty) {
        return const SizedBox(
          height: 200,
          child: Center(child: Text('该时段暂无数据')),
        );
      }

      return SizedBox(
        height: 250,
        child: controller.selectedChartType.value == ChartType.pie
            ? _buildPieChart().animate().fadeIn()
            : _buildBarChart().animate().fadeIn(),
      );
    });
  }

  Widget _buildPieChart() {
    final stats = controller.categoryStats;
    int colorIndex = 0;
    final total = stats.values.reduce((a, b) => a + b);

    final sections = stats.entries.map((entry) {
      final category = controller.getCategory(entry.key);
      final color = category != null
          ? Color(category.colorValue)
          : AppColors.chartColors[colorIndex % AppColors.chartColors.length];
      colorIndex++;

      final percentage = entry.value / total * 100;

      return PieChartSectionData(
        color: color,
        value: entry.value,
        title: '${percentage.toStringAsFixed(0)}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        badgeWidget: percentage > 10
            ? _buildBadge(category?.iconCode, color)
            : null,
        badgePositionPercentageOffset: .98,
      );
    }).toList();

    return PieChart(
      PieChartData(
        sections: sections,
        centerSpaceRadius: 40,
        sectionsSpace: 2,
        borderData: FlBorderData(show: false),
      ),
    );
  }

  Widget _buildBadge(int? iconCode, Color color) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Icon(
        iconCode != null
            ? IconData(iconCode, fontFamily: 'MaterialIcons')
            : Icons.category,
        size: 16,
        color: color,
      ),
    );
  }

  Widget _buildBarChart() {
    final stats = controller.trendStats;
    if (stats.isEmpty) return const SizedBox();

    final maxY = stats.values.reduce((curr, next) => curr > next ? curr : next);
    // 增加一点顶部空间
    final interval = maxY / 5;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY * 1.2,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            // tooltipBgColor: Colors.blueGrey, // Removed deprecated member
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                rod.toY.toStringAsFixed(0),
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: stats.entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value,
                color: AppColors.primary,
                width: 12, // 柱子宽度
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: maxY * 1.2,
                  color: Colors.grey.withValues(alpha: 0.1),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCategoryList() {
    return Obx(() {
      final stats = controller.categoryStats;
      final sortedEntries = stats.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      return Column(
        children: sortedEntries.map((entry) {
          final category = controller.getCategory(entry.key);
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: category != null
                    ? Color(category.colorValue).withValues(alpha: 0.2)
                    : Colors.grey.withValues(alpha: 0.2),
                child: Icon(
                  category != null
                      ? IconData(category.iconCode, fontFamily: 'MaterialIcons')
                      : Icons.category,
                  color: category != null
                      ? Color(category.colorValue)
                      : Colors.grey,
                ),
              ),
              title: Text(category?.name ?? '未知'),
              trailing: Text(
                entry.value.toStringAsFixed(2),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.1, end: 0);
        }).toList(),
      );
    });
  }
}
