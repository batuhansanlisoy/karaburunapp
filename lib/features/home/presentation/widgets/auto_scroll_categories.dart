import 'dart:async';
import 'package:flutter/material.dart';
import 'package:karaburun/features/home/presentation/widgets/category_card.dart';

class AutoScrollCategories extends StatefulWidget {
  final List<Map<String, dynamic>> categories;
  final void Function(int) onPageChange;

  const AutoScrollCategories({
    super.key,
    required this.categories,
    required this.onPageChange,
  });

  @override
  State<AutoScrollCategories> createState() => _AutoScrollCategoriesState();
}

class _AutoScrollCategoriesState extends State<AutoScrollCategories> {
  final ScrollController _controller = ScrollController();
  double scrollPosition = 0.0;
  late double maxScrollExtent;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_controller.hasClients) return;
      maxScrollExtent = _controller.position.maxScrollExtent;

      _timer = Timer.periodic(const Duration(milliseconds: 50), (_) {
        if (!_controller.hasClients) return;

        scrollPosition += 1; // hız
        if (scrollPosition >= maxScrollExtent) {
          scrollPosition = 0; // başa dön
        }

        _controller.animateTo(
          scrollPosition,
          duration: const Duration(milliseconds: 50),
          curve: Curves.linear,
        );
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _controller,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: widget.categories.map((e) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            child: CategoryCard(
              icon: e['icon'],
              title: e['title'],
              color: e['color'],
              onTap: () {
                if (e['pageIndex'] != null) {
                  widget.onPageChange(e['pageIndex']);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Bu kategori henüz aktif değil.")),
                  );
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
