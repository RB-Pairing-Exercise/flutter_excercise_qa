import 'package:flutter/material.dart';
import 'package:flutter_excercise/src/RitchieBros/models/rb_item.dart';
import 'package:share_plus/share_plus.dart';

class SampleItemDetailsView extends StatelessWidget {
  const SampleItemDetailsView({required this.item, super.key});
  final RBItem item;

  static const routeName = '/sample_item';

  static Route<void> route(RBItem item) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => SampleItemDetailsView(item: item),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareItem(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: 'image-${item.itemNumber}',
              child: Image.network(
                item.imageUrl,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 250,
                  color: Colors.grey[200],
                  child: const Center(child: Icon(Icons.broken_image)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.assetDescription,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),

                  Chip(
                    avatar: const Icon(Icons.location_on, size: 18),
                    label: Text(item.formattedLocation),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(thickness: 1),
                  ),

                  _buildDetailRow('Event', item.eventAdvertisedName),
                  _buildDetailRow('Date', item.formattedDate),
                  _buildDetailRow('Serial', item.serialNumber),
                  _buildDetailRow(
                      'Usage hrs', '${item.usageHours} hrs'),

                  if (item.features.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text('Features:',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: item.features
                          .split(', ')
                          .map((feature) => Chip(
                                label: Text(feature.trim()),
                                visualDensity: VisualDensity.compact,
                              ))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildActionButtons(context),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text('$label:',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return SizedBox.shrink();
  }

  Future<void> _shareItem(BuildContext context) async {
    try {
      final params = ShareParams(
        text: _buildShareText(),
      );

      await SharePlus.instance.share(
        params,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  String _buildShareText() {
    return '''
Check out this item on Marketplace:

${item.assetDescription}

Location: ${item.formattedLocation}
Event: ${item.eventAdvertisedName}
Date: ${item.formattedDate}
''';
  }
}
