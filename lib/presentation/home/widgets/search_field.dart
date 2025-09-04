import 'package:flutter/material.dart';

class AnimatedSearchField extends StatefulWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final Color fillColor;
  final Color iconColor;
  final Color borderColor;
  final double expandedWidthFactor; // 0..1 of screen width
  final double height;

  const AnimatedSearchField({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.fillColor = Colors.white,
    this.iconColor = const Color(0xFF6E67A6),
    this.borderColor = Colors.white,
    this.expandedWidthFactor = 0.9,
    this.height = 52,
  });

  @override
  State<AnimatedSearchField> createState() => _AnimatedSearchFieldState();
}

class _AnimatedSearchFieldState extends State<AnimatedSearchField> {
  bool _isExpanded = false;
  String _query = '';
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double collapsedWidth = widget.height;
    final double expandedWidth =
        MediaQuery.of(context).size.width *
        widget.expandedWidthFactor.clamp(0.4, 1.0);

    return Align(
      alignment: Alignment.centerRight,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOut,
        width: _isExpanded ? expandedWidth : collapsedWidth,
        height: widget.height,
        decoration: BoxDecoration(
          color: widget.fillColor,
          borderRadius: BorderRadius.circular(60),
          border: Border.all(color: widget.borderColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.search, color: widget.iconColor),
              onPressed: () {
                setState(() => _isExpanded = true);
              },
            ),
            if (_isExpanded)
              Expanded(
                child: AnimatedOpacity(
                  opacity: _isExpanded ? 1 : 0,
                  duration: const Duration(milliseconds: 180),
                  child: TextField(
                    controller: _searchCtrl,
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      border: InputBorder.none,
                      suffixIcon: _query.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, color: widget.iconColor),
                              onPressed: () {
                                setState(() {
                                  _query = '';
                                  _searchCtrl.clear();
                                  widget.onChanged('');
                                });
                              },
                            )
                          : IconButton(
                              icon: Icon(Icons.close, color: widget.iconColor),
                              onPressed: () {
                                setState(() {
                                  _isExpanded = false;
                                  _query = '';
                                  _searchCtrl.clear();
                                  widget.onChanged('');
                                });
                              },
                            ),
                    ),
                    onChanged: (v) {
                      final value = v.trim();
                      setState(() => _query = value);
                      widget.onChanged(value);
                    },
                    autofocus: true,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
