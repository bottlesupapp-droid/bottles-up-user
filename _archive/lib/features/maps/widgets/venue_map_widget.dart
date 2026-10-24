import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class VenueMapWidget extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String venueName;
  final String? address;
  final bool showDirections;

  const VenueMapWidget({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.venueName,
    this.address,
    this.showDirections = true,
  });

  @override
  State<VenueMapWidget> createState() => _VenueMapWidgetState();
}

class _VenueMapWidgetState extends State<VenueMapWidget> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _createMarker();
  }

  void _createMarker() {
    _markers = {
      Marker(
        markerId: MarkerId(widget.venueName),
        position: LatLng(widget.latitude, widget.longitude),
        infoWindow: InfoWindow(
          title: widget.venueName,
          snippet: widget.address,
        ),
      ),
    };
  }

  Future<void> _openInMaps() async {
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${widget.latitude},${widget.longitude}',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.latitude, widget.longitude),
              zoom: 15,
            ),
            markers: _markers,
            onMapCreated: (controller) {
              _mapController = controller;
            },
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
          ),
        ),
        if (widget.showDirections) ...[
          const SizedBox(height: 12),
          FilledButton.tonalIcon(
            onPressed: _openInMaps,
            icon: const Icon(Icons.directions),
            label: const Text('Get Directions'),
          ),
        ],
      ],
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}

class VenueMapButton extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String venueName;

  const VenueMapButton({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.venueName,
  });

  Future<void> _openMap(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            AppBar(
              title: const Text('Location'),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            Expanded(
              child: VenueMapWidget(
                latitude: latitude,
                longitude: longitude,
                venueName: venueName,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => _openMap(context),
      icon: const Icon(Icons.map),
      label: const Text('View Map'),
    );
  }
}
