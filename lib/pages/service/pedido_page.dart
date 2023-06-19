import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:propet_mobile/core/components/bottom_modal.dart';
import 'package:propet_mobile/core/components/infinite_scroll_listview.dart';
import 'package:propet_mobile/core/dependencies.dart';
import 'package:propet_mobile/core/paging_controller.dart';
import 'package:propet_mobile/core/util/textformat.dart';
import 'package:propet_mobile/models/petshop_service.dart';
import 'package:propet_mobile/services/petshop_service.dart';

class Pedidos extends StatefulWidget {
  const Pedidos({super.key});

  @override
  State<Pedidos> createState() => _PedidosState();
}

class _PedidosState extends State<Pedidos> {
  final _petshopService = getIt<PetShopService>();
  final _scrollController = ScrollController();
  final _showJumpToTop = ValueNotifier<bool>(false);
  final _pagingController =
      CustomPagingController<PetShopServiceDto>(firstPageKey: 0);
  String? _search;
  final _sort = ValueNotifier<String?>(null);
  String _sortDirection = "asc";

  @override
  void initState() {
    super.initState();

    _pagingController.addPageRequestListener(
      (pageKey) async {
        try {
          String? sort;
          if (_sort.value != null) sort = "${_sort.value},$_sortDirection";

          final result = await _petshopService.getAllServices(
              pageIndex: pageKey, search: _search, sort: sort);
          if (result.last) {
            _pagingController.appendLastPage(result.content);
          } else {
            _pagingController.appendPage(result.content, ++pageKey);
          }
        } catch (e) {
          _pagingController.error = e;
        }
      },
    );

    _scrollController.addListener(() {
      _showJumpToTop.value = _scrollController.offset > 10;
    });
  }

  void _jumpToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ValueListenableBuilder(
          valueListenable: _showJumpToTop,
          child: const Icon(Icons.arrow_upward),
          builder: (context, value, child) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: value
                  ? FloatingActionButton(
                      onPressed: _jumpToTop,
                      child: child,
                    )
                  : null,
            );
          }),
      body: Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Column(
          children: [
            TextField(
              onSubmitted: (value) {
                _search = value;
                _pagingController.refresh();
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(8),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => _showSortMenu(context),
                      icon: const Icon(Icons.filter_alt),
                    ),
                    ValueListenableBuilder(
                      valueListenable: _sort,
                      builder: (context, value, child) {
                        return IconButton(
                          onPressed: value == null
                              ? null
                              : () => _showSortDirectionMenu(context),
                          icon: const Icon(Icons.sort),
                        );
                      }
                    ),
                  ],
                ),
              ),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 10),
            Flexible(
              child: InfiniteScrollListView<PetShopServiceDto>(
                pagingController: _pagingController,
                scrollController: _scrollController,
                itemBuilder: (context, item, index) {
                  return ServiceItem(item: item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSortMenu(BuildContext ctx) {
    ModalBottomSheet.show(
      ctx,
      actions: [
        ModalBottomSheetAction(
          title: "Relevancia",
          onChanged: (ctx) {
            _sort.value = null;
            _pagingController.refresh();
            ctx.pop();
          },
        ),
        ModalBottomSheetAction(
          title: "Preço",
          onChanged: (ctx) {
            _sort.value = "value";
            _pagingController.refresh();
            ctx.pop();
          },
        ),
      ],
      title: "Classificar por",
      initialSelect: _sort.value == null ? 0 : 1,
    );
  }

  void _showSortDirectionMenu(BuildContext ctx) {
    ModalBottomSheet.show(
      ctx,
      actions: [
        ModalBottomSheetAction(
          title: "Ascendente",
          onChanged: (ctx) {
            _sortDirection = "asc";
            _pagingController.refresh();
            ctx.pop();
          },
        ),
        ModalBottomSheetAction(
          title: "Descendente",
          onChanged: (ctx) {
            _sortDirection = "desc";
            _pagingController.refresh();
            ctx.pop();
          },
        ),
      ],
      title: "Ordenar",
      initialSelect: _sortDirection == "asc" ? 0 : 1,
    );
  }
}

class ServiceItem extends StatelessWidget {
  final PetShopServiceDto item;

  const ServiceItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push("/orders/new", extra: item),
        child: ListTile(
          leading: const Icon(Icons.spa),
          title: Text(item.name),
          trailing: Text(
            TextFormat.currency(item.value),
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
      ),
    );
  }
}
