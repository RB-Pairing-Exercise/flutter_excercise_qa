import 'package:flutter/material.dart';
import 'package:flutter_excercise/src/RitchieBros/models/rb_item.dart';

class AssetListItem extends StatelessWidget {
  final RBItem item;
  final VoidCallback? onTap;

  const AssetListItem({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: Image.network(
                      item.imageUrl,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 120,
                        height: 120,
                        color: Colors.grey[200],
                        child: Icon(Icons.broken_image),
                      ),
                    ),
                  ),
                ),
                Text(item.formattedLocation),
                SizedBox(height: 6),
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.assetDescription,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(item.eventAdvertisedName),
                    SizedBox(height: 6),
                    Text(item.formattedDate),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
