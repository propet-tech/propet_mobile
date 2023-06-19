import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:propet_mobile/core/paging_controller.dart';

class InfiniteScrollListView<T> extends StatelessWidget {
  const InfiniteScrollListView({
    super.key,
    required this.pagingController,
    required this.itemBuilder,
    this.scrollController
  }) : separatorBuilder = null;

  const InfiniteScrollListView.separated({
    super.key,
    required this.pagingController,
    required this.itemBuilder,
    required this.separatorBuilder,
    this.scrollController
  });

  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget Function(BuildContext context, int index)? separatorBuilder;
  final CustomPagingController<T> pagingController;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final child = separatorBuilder != null
        ? _buildWithSeparator()
        : _buildWithoutSeparator();

    return RefreshIndicator(
      onRefresh: () => Future.sync(() => pagingController.refresh()),
      child: child,
    );
  }

  Widget _buildWithSeparator() {
    return PagedListView<int, T>.separated(
      pagingController: pagingController,
      scrollController: scrollController,
      builderDelegate: defaultPagedChildBuilderDelegate(),
      separatorBuilder: separatorBuilder!,
    );
  }

  Widget _buildWithoutSeparator() {
    return PagedListView<int, T>(
      pagingController: pagingController,
      scrollController: scrollController,
      builderDelegate: defaultPagedChildBuilderDelegate(),
    );
  }

  PagedChildBuilderDelegate<T> defaultPagedChildBuilderDelegate() {
    return PagedChildBuilderDelegate<T>(
      itemBuilder: itemBuilder,
    );
  }
}
