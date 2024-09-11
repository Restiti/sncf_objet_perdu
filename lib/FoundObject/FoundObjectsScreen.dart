import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'FoundObjectsProvider.dart';

class FoundObjectsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Found Objects'),
      ),
      body: FutureBuilder(
        future: Provider.of<FoundObjectsProvider>(context, listen: false).fetchFoundObjects(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Consumer<FoundObjectsProvider>(
              builder: (context, provider, child) {
                return ListView.builder(
                  itemCount: provider.foundObjects.length,
                  itemBuilder: (context, index) {
                    final foundObject = provider.foundObjects[index];
                    return ListTile(
                      title: SelectableText(foundObject.gcOboNatureC),
                      subtitle: SelectableText('${foundObject.gcOboTypeC} - ${foundObject.gcOboGareOrigineRName}'),
                      trailing: SelectableText(foundObject.date),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
