import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(LocationApp());
}

class LocationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LocationData? _locationData;
  final Location location = Location();
  bool _loading = true;
  late GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    final loc = await location.getLocation();
    setState(() {
      _locationData = loc;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Map View')),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(_locationData!.latitude!, _locationData!.longitude!),
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: MarkerId('currentLocation'),
            position: LatLng(_locationData!.latitude!, _locationData!.longitude!),
            infoWindow: InfoWindow(title: 'You are here'),
          ),
        },
        onMapCreated: (controller) {
          _mapController = controller;
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Show Details"),
        icon: Icon(Icons.info_outline),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LocationDetailScreen(
                latitude: _locationData!.latitude!,
                longitude: _locationData!.longitude!,
                timestamp: DateTime.now(),
              ),
            ),
          );
        },
      ),
    );
  }
}

class LocationDetailScreen extends StatelessWidget {
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  LocationDetailScreen({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Location Details')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text('Latitude: $latitude', style: TextStyle(fontSize: 18)),
            Text('Longitude: $longitude', style: TextStyle(fontSize: 18)),
            Text('Timestamp: $timestamp', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
