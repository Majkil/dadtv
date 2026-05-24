import 'package:dadtv/models/iptv_streams_model.dart';
import 'package:dadtv/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../services/iptv_git_service.dart';

class IptvGitListPage extends StatefulWidget {
  const IptvGitListPage({super.key});

  @override
  _IptvGitListPageState createState() => _IptvGitListPageState();
}

class _IptvGitListPageState extends State<IptvGitListPage> {
  final FocusNode _rootFocus = FocusNode();
  final FocusNode _searchFocus = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<IptvStreamModel> _items = [];
  List<IptvStreamModel> _filtered = [];
  bool _loading = true;
  int _focusedIndex = -1; // -1 means search bar (if focused) or none

  @override
  void initState() {
    super.initState();
    _loadItems();
    // ensure RawKeyboardListener receives keys
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_rootFocus.hasPrimaryFocus) _rootFocus.requestFocus();
    });
  }
  
  Future<void> _loadItems() async {
    setState(() => _loading = true);
    try {
       
       
      
      final data = (await DbService.instance).getAllStreams();
      // keep items as dynamic; UI will display sensible fields if present
      _items = List<IptvStreamModel>.from(data);
      _filtered = List<IptvStreamModel>.from(_items);
    } catch (e) {
      _items = [];
      _filtered = [];
      // ignore errors for now
    } finally {
      setState(() => _loading = false);
    }
  }

  void _filter(String q) {
    final lower = q.toLowerCase();
    _filtered = _items.where((it) {
      if (it is String) return it.title.toLowerCase().contains(lower);
      try {
        final name =it.title;
        return name.toLowerCase().contains(lower);
      } catch (_) {
        return it.toString().toLowerCase().contains(lower);
      }
    }).toList();
    _focusedIndex = -1;
    setState(() {});
  }

  void _onKey(RawKeyEvent event) {
    if (event is! RawKeyDownEvent) return;
    final key = event.logicalKey;

    if (key == LogicalKeyboardKey.arrowDown) {
      if (_focusedIndex < _filtered.length - 1) {
        _focusedIndex++;
        _ensureVisible(_focusedIndex);
        setState(() {});
      } else if (_focusedIndex == -1 && _filtered.isNotEmpty) {
        // move from search to first
        _focusedIndex = 0;
        _ensureVisible(_focusedIndex);
        setState(() {});
      }
    } else if (key == LogicalKeyboardKey.arrowUp) {
      if (_focusedIndex > 0) {
        _focusedIndex--;
        _ensureVisible(_focusedIndex);
        setState(() {});
      } else if (_focusedIndex == 0) {
        // move focus back to search
        _focusedIndex = -1;
        _searchFocus.requestFocus();
        setState(() {});
      }
    } else if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.select ||
        key == LogicalKeyboardKey.space) {
      _activateFocused();
    } else if (key == LogicalKeyboardKey.arrowLeft) {
      // optional: move focus back to search
      if (_focusedIndex != -1) {
        _focusedIndex = -1;
        _searchFocus.requestFocus();
        setState(() {});
      }
    } else if (key == LogicalKeyboardKey.arrowRight) {
      if (_focusedIndex == -1 && _filtered.isNotEmpty) {
        _focusedIndex = 0;
        _ensureVisible(_focusedIndex);
        setState(() {});
      }
    }
  }

  void _ensureVisible(int index) {
    if (index < 0 || index >= _filtered.length) return;
    // assume each item approx 72px tall; better to compute with context if needed
    final pos = index * 72.0;
    final viewport = _scrollController.position;
    final target = pos.clamp(viewport.minScrollExtent, viewport.maxScrollExtent);
    _scrollController.animateTo(target, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  void _activateFocused() {
    if (_focusedIndex == -1) {
      // if search focused, nothing to activate
      return;
    }
    if (_focusedIndex >= 0 && _focusedIndex < _filtered.length) {
      final item = _filtered[_focusedIndex];
      final title = _displayTitle(item);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selected: $title')),
      );
      // replace above with navigation or action you need
    }
  }

  String _displayTitle(dynamic item) {
    if (item == null) return '';
    if (item is String) return item;
    if (item is Map) {
      if (item.containsKey('name')) return '${item['name']}';
      if (item.containsKey('title')) return '${item['title']}';
    }
    try {
      return item.toString();
    } catch (_) {
      return '';
    }
  }

  @override
  void dispose() {
    _rootFocus.dispose();
    _searchFocus.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _rootFocus,
      onKey: _onKey,
      child: Scaffold(
        appBar: AppBar(title: const Text('IPTV Git List')),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Focus(
                focusNode: _searchFocus,
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Search...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: _filter,
                  onTap: () {
                    // when user focuses search via touch/remote center, mark focused index accordingly
                    _focusedIndex = -1;
                    setState(() {});
                  },
                ),
              ),
            ),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _filtered.isEmpty
                      ? const Center(child: Text('No items'))
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: _filtered.length,
                          itemBuilder: (context, index) {
                            final item = _filtered[index];
                            final title = _displayTitle(item);
                            final isFocused = index == _focusedIndex;
                            return GestureDetector(
                              onTap: () {
                                _focusedIndex = index;
                                setState(() {});
                                _activateFocused();
                                 GoRouter.of(context).push('/play', extra: {'url': item.url});
                              },
                              child: Container(
                                height: 72,
                                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isFocused ? Theme.of(context).highlightColor : Theme.of(context).cardColor,
                                  border: Border.all(color: isFocused ? Theme.of(context).colorScheme.primary : Colors.transparent, width: 2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.tv, size: 40),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        title,
                                        style: TextStyle(fontSize: 16, fontWeight: isFocused ? FontWeight.bold : FontWeight.normal),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}