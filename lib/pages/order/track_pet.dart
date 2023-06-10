import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:propet_mobile/core/components/bottom_modal.dart';
import 'package:propet_mobile/core/dependencies.dart';
import 'package:propet_mobile/core/services/auth_service.dart';
import 'package:propet_mobile/environment.dart';
import 'package:propet_mobile/models/order/order_history_response.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';

class PetTrack extends StatefulWidget {
  final int id;
  const PetTrack({super.key, required this.id});

  @override
  State<PetTrack> createState() => _PetTrackState();
}

class _PetTrackState extends State<PetTrack> {
  late final StompClient client;
  final StreamController<List<OrderHistoryResponse>> stream =
      StreamController<List<OrderHistoryResponse>>();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    final token = await getIt<AuthService>().getAccessTokenAndRefresh();
    client = StompClient(
      config: StompConfig(
        webSocketConnectHeaders: {
          "Authorization": "Bearer $token",
        },
        url: "ws://${AppEnvironment.api}/ws",
        // onWebSocketError: (dynamic error) => print(error.toString()),
        onStompError: (p0) {
          print(p0.body);
        },
        onConnect: (p0) {
          client.subscribe(
            destination: "/user/pet/${widget.id}",
            callback: (p0) {
              List<dynamic> list = jsonDecode(p0.body!);
              var out =
                  list.map((e) => OrderHistoryResponse.fromJson(e)).toList();
              stream.add(out);
            },
          );

          // client.send(destination: "/ws");
        },
      ),
    );
    client.activate();
  }

  @override
  void dispose() {
    client.deactivate();
    stream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const ModalBottomSheetHeader(title: "Acompanhar"),
        StreamBuilder(
          stream: stream.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data!;
              return ListView.separated(
                shrinkWrap: true,
                reverse: true,
                separatorBuilder: (context, index) {
                  return Row(
                    children: [
                      const SizedBox(width: 35),
                      Container(
                        height: 32,
                        width: 2,
                        color: Colors.grey,
                      ),
                    ],
                  );
                },
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final element = data[index];

                  var (icon, text) = switch (element.status) {
                    "RECEIVED" => (Icons.start, "Recebido"),
                    "WAITING" => (Icons.hourglass_empty, "Espera"),
                    "PROCESS" => (Icons.cleaning_services, "Em Andamento"),
                    "ON_THE_WAY" => (Icons.delivery_dining, "A Caminho"),
                    "DELIVERED" => (Icons.pets, "Entrege"),
                    "FINISHED" => (Icons.done, "Finalizado"),
                    _ => (Icons.done, ""),
                  };

                  return Column(
                    children: [
                      ListTile(
                        title: Text(text),
                        subtitle: Row(
                          children: [
                            const Icon(Icons.schedule),
                            const SizedBox(width: 4),
                            Text(DateFormat("HH:mm, EEEE, d MMMM 'de' yyyy")
                                .format(element.dateTime)),
                          ],
                        ),
                        leading: CircleAvatar(
                          child: Icon(icon),
                        ),
                      ),
                    ],
                  );
                },
              );
            } else {
              return const Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
