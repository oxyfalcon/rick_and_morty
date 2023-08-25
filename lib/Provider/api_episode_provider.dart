import 'dart:async';
import 'dart:convert';
import 'package:app/Provider/local_provider.dart';
import 'package:app/Provider/pagination_state.dart';
import 'package:app/schema/episode_schema.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class ApiEpisode extends AutoDisposeNotifier<PaginationState<Episode>> {
  String str = '/episode';
  Timer _timer = Timer(const Duration(milliseconds: 0), () {});
  final String _baseUrl = "https://rickandmortyapi.com/api";
  String filter = "";
  String page = "page=";
  bool finished = false;
  List<Episode> _items = [];
  int length = 0;

  @override
  PaginationState<Episode> build() {
    finished = false;
    name();
    return const PaginationState<Episode>.loading();
  }

  void name() async {
    _items = await getResponseList("$_baseUrl$str");
    state = PaginationState.data(_items);
  }

  Future<List<Episode>> getResponseList(String r) async {
    final response = await http.get(Uri.parse(r));
    List<Episode> list = [];
    var json = jsonDecode(response.body)['results'];
    if (jsonDecode(response.body)['info'] == null) {
      length = 0;
      return list;
    } else {
      length = jsonDecode(response.body)['info']['pages'];
    }
    for (var itr in json) {
      list.add(Episode.fromJson(itr));
    }
    return list;
  }

  void getSearchItems(String r) async {
    finished = false;
    ref.watch(valueProvider.notifier).index = 1;
    state = const PaginationState.loading();
    _items = await getResponseList("$_baseUrl$str?$r");
    state = PaginationState.data(_items);
  }

  Future<void> getNextPage() async {
    if (_timer.isActive && _items.isNotEmpty) {
      return;
    }
    _timer = Timer(const Duration(milliseconds: 1000), () {});
    state = PaginationState.onGoingLoading(_items);
    int pageNumber = ref.watch(valueProvider.notifier).index;
    if (pageNumber <= length) {
      if (pageNumber == length) {
        finished = true;
        return;
      }
      pageNumber++;
      final nextItems =
          await getResponseList("$_baseUrl$str?$page$pageNumber&$filter");
      ref.watch(valueProvider.notifier).index = pageNumber;
      state = PaginationState.data(_items..addAll(nextItems));
    }
  }
}

final apiEpisodeProvider =
    NotifierProvider.autoDispose<ApiEpisode, PaginationState<Episode>>(
        () => ApiEpisode());
