import 'package:evently_c20_dokki/ui/home/tabs/maps_tab/provider/map_tab_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapTab extends StatelessWidget {
  const MapTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .center,
      crossAxisAlignment: .stretch,
      children: [
        Expanded(
          child: Consumer<MapTabProvider>(
            builder: (context, provider, child) {
              return GoogleMap(
                mapType: .normal,
                markers: provider.markers,
                zoomControlsEnabled: false,
                initialCameraPosition: provider.cameraPosition,
                onMapCreated: (controller) {
                  provider.mapController.complete(controller);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
