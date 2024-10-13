import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../CategoryObjects/CategoryObjectsScreen.dart';
import '../CustomBottomSheet/CustomBottomSheet.dart';
import '../Gare/GareProvider.dart';
import 'FoundObject.dart';
import 'FoundObjectItem.dart';
import 'FoundObjectsProvider.dart';

class FoundObjectsScreen extends StatefulWidget {
  @override
  _FoundObjectsScreenState createState() => _FoundObjectsScreenState();
}

class _FoundObjectsScreenState extends State<FoundObjectsScreen> {
  final ScrollController _scrollController = ScrollController();
  late CustomBottomSheet _customBottomSheet;

  @override
  void initState() {
    super.initState();
    _customBottomSheet = CustomBottomSheet(gareSuggestions: [], typeSuggestions: []);

    // Refresh the found objects and fetch the gares for the filter
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData();
    });
  }

  Future<void> _refreshData() async {
    // Refresh found objects without category filter
    await Provider.of<FoundObjectsProvider>(context, listen: false).refreshFoundObjects();

    // Fetch the gares for the filter
    await Provider.of<GareProvider>(context, listen: false).fetchGares();

    // Fetch the types for the filter
    await Provider.of<FoundObjectsProvider>(context, listen: false).fetchTypes();

    // Update the custom bottom sheet after fetching data
    _updateCustomBottomSheet();
  }

  void _updateCustomBottomSheet() {
    final gareProvider = Provider.of<GareProvider>(context, listen: false);
    final foundObjectsProvider = Provider.of<FoundObjectsProvider>(context, listen: false);
    setState(() {
      _customBottomSheet = CustomBottomSheet(
        gareSuggestions: gareProvider.gares,
        typeSuggestions: foundObjectsProvider.types,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showFilter() {
    final gareProvider = Provider.of<GareProvider>(context, listen: false);
    final foundObjectsProvider = Provider.of<FoundObjectsProvider>(context, listen: false);
    if (gareProvider.gares.isNotEmpty || foundObjectsProvider.types.isNotEmpty) {
      _customBottomSheet.show(context, 'filtre');
    } else {
      print('No gares or types available to display in the filter');
    }
  }

  Widget _buildSortAndFilterButtons() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => _customBottomSheet.show(context, 'tri'),
              child: const Text('Tri'),
            ),
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: _showFilter,
              child: const Text('Filtre'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildObjectList(BuildContext context, Map<String, List<FoundObject>> objectsByType) {
    return ListView.builder(
      itemCount: objectsByType.keys.length,
      itemBuilder: (context, index) {
        String objectType = objectsByType.keys.elementAt(index);
        List<FoundObject> objects = objectsByType[objectType]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      objectType,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryObjectsScreen(category: objectType),
                        ),
                      );
                    },
                    child: const Text('Voir tous'),
                  ),
                ],
              ),
            ),
            Container(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: objects.length + 1, // +1 to add the "Voir tous" card
                itemBuilder: (context, index) {
                  if (index == objects.length) {
                    return _buildViewAllCard(objectType);
                  } else {
                    final foundObject = objects[index];
                    return FoundObjectItem(object: foundObject);
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildViewAllCard(String objectType) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryObjectsScreen(category: objectType),
          ),
        );
      },
      child: Container(
        width: 220,
        margin: const EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'Voir tous',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _refreshData();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Objets trouvés'),
        ),
        body: Column(
          children: [
            _buildSortAndFilterButtons(),
            Expanded(
              child: Consumer<FoundObjectsProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (provider.hasError) {
                    return Center(child: Text('Erreur: ${provider.errorMessage}'));
                  } else {
                    return _buildObjectList(context, provider.objectsByType);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
