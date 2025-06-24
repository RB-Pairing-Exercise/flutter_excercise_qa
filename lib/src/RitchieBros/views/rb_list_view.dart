import 'package:flutter/material.dart';
import 'package:flutter_excercise/src/RitchieBros/viewmodels/rb_items_viewmodel.dart';
import 'package:flutter_excercise/src/RitchieBros/views/rb_item_details_view.dart';
import 'package:flutter_excercise/src/RitchieBros/views/widgets/asset_list_item.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../settings/settings_view.dart';

class RBItemListView extends StatelessWidget {
  const RBItemListView({
    super.key,
  });

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RbItemsViewModel()..fetchAssets(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('RB Items'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.restorablePushNamed(context, SettingsView.routeName);
              },
            ),
          ],
        ),
        body: Consumer<RbItemsViewModel>(builder: (context, viewModel, _) {
          if (viewModel.isLoading && viewModel.items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.error != null && viewModel.items.isEmpty) {
            return Center(child: Text('Error: ${viewModel.error}'));
          }

          return NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollEndNotification &&
                  notification.metrics.pixels ==
                      notification.metrics.maxScrollExtent &&
                  !viewModel.isLoading &&
                  viewModel.hasMore) {
                viewModel.fetchAssets(loadMore: true);
              }
              return false;
            },
            child: ListView.builder(
              restorationId: 'sampleItemListView',
              itemCount: viewModel.items.length + (viewModel.hasMore ? 1 : 0),
              itemBuilder: (BuildContext context, int index) {
                if (index >= viewModel.items.length) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: viewModel.isLoading
                        ? SpinKitThreeBounce(
                            color: Colors.yellowAccent,
                            size: 50.0,
                          )
                        : const SizedBox.shrink(),
                  );
                }
                final item = viewModel.items[index];

                return AssetListItem(
                    item: item,
                    onTap: () => Navigator.push(
                          context,
                          SampleItemDetailsView.route(item),
                        ));
              },
            ),
          );
        }),
      ),
    );
  }
}
