import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/src/ui/default_indicators/first_page_error_indicator.dart';
import 'package:intl/intl.dart';
import 'package:propet_mobile/core/app_state.dart';
import 'package:propet_mobile/core/components/divider.dart';
import 'package:propet_mobile/core/dependencies.dart';
import 'package:propet_mobile/core/dio_image_provider.dart';
import 'package:propet_mobile/models/banner/banner.dart';
import 'package:propet_mobile/pages/pet/pet_list_page.dart';
import 'package:propet_mobile/services/banner_service.dart';
import 'package:propet_mobile/services/petshop_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final curreny = NumberFormat.simpleCurrency();
  List<String> images = [
    "https://images5.alphacoders.com/131/1316260.jpg",
    "https://images8.alphacoders.com/131/1314194.jpg",
    "https://images6.alphacoders.com/131/1315610.jpg",
  ];

  var _currentBanner = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Column(
          children: [
            FutureBuilder(
              future: getIt<BannerService>().listAllBanners(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                }
                if (snapshot.hasData) {
                  return BannerCarousel(banners: snapshot.data!);
                }

                return CircularProgressIndicator();
              },
            ),
            SizedBox(
              height: 2,
            ),
          ],
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text("Top Serviços",
                    style: Theme.of(context).textTheme.titleMedium),
              ),
              Expanded(
                child: FutureBuilder(
                  future: getIt<PetShopService>().getTopService(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.separated(
                        itemCount: snapshot.data!.length,
                        separatorBuilder: (context, index) =>
                            DividerWithoutMargin(),
                        itemBuilder: (context, index) {
                          final value = curreny
                              .format(snapshot.data![index].value);
                          return InkWell(
                            child: ListTile(
                              leading: CircleAvatar(child: Icon(Icons.pets)),
                              title: Text(snapshot.data![index].name),
                              subtitle: Text(value),
                              trailing: Icon(Icons.arrow_right),
                            ),
                            onTap: () => context.push("/orders/new", extra: snapshot.data![index]),
                          );
                        },
                      );
                    }

                    if (snapshot.hasError) return FirstPageErrorIndicator();

                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class BannerCarousel extends StatefulWidget {
  const BannerCarousel({
    super.key,
    required this.banners,
  });

  final List<BannerDto> banners;

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  // var _currentBanner = 0;
  final CarouselController _controller = CarouselController();
  final ValueNotifier<int> _currentBanner = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: _controller,
          itemCount: widget.banners.length,
          itemBuilder: (context, index, realIndex) {
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: DioImage(
                    Uri.parse(widget.banners[index].image),
                  ),
                ),
              ),
            );
          },
          options: CarouselOptions(
            autoPlay: true,
            viewportFraction: 1.0,
            onPageChanged: (position, reason) {
              _currentBanner.value = position;
            },
            enableInfiniteScroll: false,
          ),
        ),
        ValueListenableBuilder(
        valueListenable: _currentBanner,
          builder: (context, value, child) {
            return DotsIndicator(
              dotsCount: widget.banners.length,
              position: value,
              onTap: (index) => _controller.animateToPage(index),
              decorator: DotsDecorator(
                activeColor: Theme.of(context).colorScheme.primary,
                size: const Size.square(8.0),
                activeSize: const Size(18.0, 8.0),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            );
          }
        ),
      ],
    );
  }
}
