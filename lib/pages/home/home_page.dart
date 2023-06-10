import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:propet_mobile/core/app_state.dart';
import 'package:propet_mobile/core/dependencies.dart';
import 'package:propet_mobile/services/petshop_service.dart';
import 'package:provider/provider.dart';
import 'package:infinite_scroll_pagination/src/ui/default_indicators/first_page_error_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> images = [
    "https://images5.alphacoders.com/131/1316260.jpg",
    "https://images8.alphacoders.com/131/1314194.jpg",
    "https://images6.alphacoders.com/131/1315610.jpg",
  ];

  var _currentBanner = 0;
  final CarouselController _controller = CarouselController();

  String getGreeting() {
    var hours = DateTime.now().hour;

    if (hours >= 6 && hours <= 12) {
      return "Bom dia";
    } else if (hours > 12 && hours < 18) {
      return "Boa Tarde";
    } else if (hours >= 18 && hours <= 23) {
      return "Boa Noite";
    } else {
      return "Boa Madrugada";
    }
  }

  @override
  Widget build(BuildContext context) {
    var userInfo = context.watch<AppState>().userinfo;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${getGreeting()}, ${userInfo?.name}!",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Card(
          child: Column(
            children: [
              CarouselSlider(
                carouselController: _controller,
                items: images.map<Widget>((e) {
                  return Builder(
                    builder: (context) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          // width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(e),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 220.0,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  initialPage: _currentBanner,
                  onPageChanged: (position, reason) {
                    // setState(() => _currentBanner = position);
                  },
                  enableInfiniteScroll: false,
                ),
              ),
              SizedBox(
                height: 2,
              ),
              DotsIndicator(
                dotsCount: images.length,
                position: _currentBanner,
                onTap: (index) => _controller.animateToPage(index),
                decorator: DotsDecorator(
                  activeColor: Theme.of(context).colorScheme.primary,
                  size: const Size.square(8.0),
                  activeSize: const Size(18.0, 8.0),
                  activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Card(
            child: Column(
              children: [
                Text("Top Serviços", style: Theme.of(context).textTheme.bodyLarge),
                Expanded(
                  child: FutureBuilder(
                    future: getIt<PetShopService>().getTopService(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              child: ListTile(
                                leading: CircleAvatar(child: Icon(Icons.pets)),
                                title: Text(snapshot.data![index].name),
                                subtitle: Text(snapshot.data![index].value.toString()),
                                trailing: Icon(Icons.arrow_right),
                              ),
                              onTap: () => context.go("/orders"),
                            );
                          },
                        );
                      }

                      if (snapshot.hasError)
                        return FirstPageErrorIndicator();

                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
