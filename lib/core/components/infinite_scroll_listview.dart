import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class InfiniteScrollListView<T> extends StatefulWidget {
  final Widget Function(
    BuildContext context,
    T item,
    int index,
  ) itemBuilder;

  final void Function(int pageKey, PagingController pagingController) fetchData;

  const InfiniteScrollListView(
      {super.key, required this.itemBuilder, required this.fetchData});

  @override
  State<InfiniteScrollListView> createState() =>
      _InfiniteScrollListViewState<T>();
}

class _InfiniteScrollListViewState<T> extends State<InfiniteScrollListView<T>> {
  late final PagingController<int, T> pagingController;

  @override
  void initState() {
    pagingController = PagingController(firstPageKey: 0);
    pagingController.addPageRequestListener((pageKey) {
      widget.fetchData(pageKey, pagingController);
    });
    super.initState();
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: PagedListView.separated(
        padding: const EdgeInsets.all(5),
        pagingController: pagingController,
        builderDelegate: PagedChildBuilderDelegate<T>(
          itemBuilder: widget.itemBuilder,
        ),
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 5,
          );
        },
      ),
      onRefresh: () {
        return Future.sync(() => pagingController.refresh());
      },
    );
  }
}
