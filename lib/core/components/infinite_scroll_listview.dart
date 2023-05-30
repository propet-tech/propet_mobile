import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:propet_mobile/core/paging_controller.dart';

class InfiniteScrollListView<T> extends StatefulWidget {
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget Function(BuildContext context, int index) separatorBuilder;
  final CustomPagingController<int, T>? pagingController;

  final void Function(int pageKey, CustomPagingController pagingController) fetchData;

  const InfiniteScrollListView({
    super.key,
    required this.itemBuilder,
    required this.separatorBuilder,
    required this.fetchData,
    this.pagingController,
  });

  @override
  State<InfiniteScrollListView> createState() =>
      _InfiniteScrollListViewState<T>();
}

class _InfiniteScrollListViewState<T> extends State<InfiniteScrollListView<T>> {
  late final CustomPagingController<int, T> pagingController;

  @override
  void initState() {
    if (widget.pagingController != null) {
      pagingController = widget.pagingController!;
    } else {
      pagingController = CustomPagingController(firstPageKey: 0);
    }
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
        pagingController: pagingController,
        builderDelegate: PagedChildBuilderDelegate<T>(
          itemBuilder: widget.itemBuilder,
        ),
        separatorBuilder: widget.separatorBuilder
      ),
      onRefresh: () {
        return Future.sync(() => pagingController.refresh());
      },
    );
  }
}
