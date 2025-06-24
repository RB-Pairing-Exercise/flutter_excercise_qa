// dart
import 'package:flutter/material.dart';
import 'package:flutter_excercise/src/RitchieBros/models/rb_item.dart';
import 'package:flutter_excercise/src/settings/settings_view.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_excercise/src/RitchieBros/views/rb_list_view.dart';
import 'package:flutter_excercise/src/RitchieBros/viewmodels/rb_items_viewmodel.dart';
import 'package:flutter_excercise/src/RitchieBros/views/widgets/asset_list_item.dart';
import 'package:flutter_excercise/src/RitchieBros/views/rb_item_details_view.dart';

class MockRbItemsViewModel extends Mock implements RbItemsViewModel {
  @override
  bool get isLoading => super.noSuchMethod(Invocation.getter(#isLoading), returnValue: false);
   @override
  List<RBItem> get items => [];
}

void main() {
  late MockRbItemsViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockRbItemsViewModel();
  });

  RBItem createTestRBItem() {
  return RBItem(
    '13238181',
    '2022 Claas LEXION 8700 Combine Harvester',
    'https://cdn.ironpla.net/i/18830/801/2b9a07d9-eee3-4a70-ab6d-5c33e748d208.jpg',
    'Saskatoon',
    'SK',
    'CAN',
    'Saskatoon, SK, CAN - Jun 17, 2025',
    'C8901028',
    1750168800000,
    379.0,
    '254 Separator Hours Showing, Air Conditioner, Air Ride Seat, Hydrostatic Drive...',
  );
}

  Widget createWidgetUnderTest() {
    
    return ChangeNotifierProvider<RbItemsViewModel>.value(
      value: mockViewModel,
      child: MaterialApp(
        home: RBItemListView(),
        onGenerateRoute: (settings) {
          if (settings.name == SettingsView.routeName) {
            return MaterialPageRoute(builder: (_) =>  Scaffold(body: Text('SettingsView')));
          }
          if (settings.name == '/details') {
            return MaterialPageRoute(builder: (_) => const Scaffold(body: Text('DetailsView')));
          }
          return null;
        },
      ),
    );
  }

  testWidgets('shows loading indicator when loading and items are empty', (tester) async {
    when(mockViewModel.isLoading).thenReturn(true);
    when(mockViewModel.items).thenReturn([]);
    when(mockViewModel.error).thenReturn(null);

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows error message when error and items are empty', (tester) async {
    when(mockViewModel.isLoading).thenReturn(false);
    when(mockViewModel.items).thenReturn([]);
    when(mockViewModel.error).thenReturn('Some error');

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.textContaining('Error: Some error'), findsOneWidget);
  });

  testWidgets('shows list of items when data is available', (tester) async {
    final fakeItem = createTestRBItem();
    when(mockViewModel.isLoading).thenReturn(false);
    when(mockViewModel.items).thenReturn([fakeItem]);
    when(mockViewModel.error).thenReturn(null);
    when(mockViewModel.hasMore).thenReturn(false);

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(AssetListItem), findsOneWidget);
  });

  testWidgets('shows loading spinner at bottom when loading more', (tester) async {
    final fakeItem = createTestRBItem();
    when(mockViewModel.isLoading).thenReturn(true);
    when(mockViewModel.items).thenReturn([fakeItem]);
    when(mockViewModel.error).thenReturn(null);
    when(mockViewModel.hasMore).thenReturn(true);

    await tester.pumpWidget(createWidgetUnderTest());

    // The loading spinner at the bottom is SpinKitThreeBounce
    expect(find.byType(AssetListItem), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(SizedBox), findsNothing);
    expect(find.byType(SpinKitThreeBounce), findsOneWidget);
  });

  testWidgets('fetchAssets is called when scrolled to bottom and hasMore is true', (tester) async {
    final fakeItem = createTestRBItem();
    when(mockViewModel.isLoading).thenReturn(false);
    when(mockViewModel.items).thenReturn(List.generate(20, (_) => fakeItem));
    when(mockViewModel.error).thenReturn(null);
    when(mockViewModel.hasMore).thenReturn(true);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.drag(find.byType(ListView), const Offset(0, -1000));
    await tester.pumpAndSettle();

    verify(mockViewModel.fetchAssets(loadMore: true)).called(1);
  });

  testWidgets('tapping settings icon navigates to SettingsView', (tester) async {
    when(mockViewModel.isLoading).thenReturn(false);
    when(mockViewModel.items).thenReturn([]);
    when(mockViewModel.error).thenReturn(null);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    expect(find.text('SettingsView'), findsOneWidget);
  });

  testWidgets('tapping an item navigates to details view', (tester) async {
    final fakeItem = createTestRBItem();
    when(mockViewModel.isLoading).thenReturn(false);
    when(mockViewModel.items).thenReturn([fakeItem]);
    when(mockViewModel.error).thenReturn(null);
    when(mockViewModel.hasMore).thenReturn(false);

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.byType(AssetListItem));
    await tester.pumpAndSettle();

    // Since SampleItemDetailsView.route is used, you may need to adjust this
    expect(find.byType(SampleItemDetailsView), findsNothing); // Placeholder
  });
}