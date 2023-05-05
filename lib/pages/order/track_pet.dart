import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:propet_mobile/models/pet.dart';
import 'package:propet_mobile/models/petshop_service.dart';
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
  final StreamController<PetShopService> stream =
      StreamController<PetShopService>();
  int index = 0;

  @override
  void initState() {
    client = StompClient(
      config: StompConfig(
        url: "ws://192.168.1.124:8088/api/ws",
        onConnect: (p0) {
          client.subscribe(
            destination: "/topic/greetings",
            callback: (p0) {
              print(p0.body);
              stream.add(PetShopService.fromJson(jsonDecode(p0.body!)["content"]));
            },
          );
        },
      ),
    );
    client.activate();
    super.initState();
  }

  @override
  void dispose() {
    client.deactivate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.status == "RECEBIDO") {
            index = 0;
          } else if (snapshot.data!.status == "PROCESSO") {
            index = 1;
          } else if (snapshot.data!.status == "ENCAMINHADO") {
            index = 2;
          } else if (snapshot.data!.status == "ENTREGE") {
            index = 3;
          }

          return Stepper(
            currentStep: index,
            controlsBuilder: (context, details) {
              return Row();
            },
            steps: [
              Step(title: Text("Chegou"), content: Text("batata")),
              Step(title: Text("Processo"), content: Text("batata")),
              Step(title: Text("Encaminhado"), content: Text("batata")),
              Step(title: Text("Entrege"), content: Text("batata")),
            ],
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
