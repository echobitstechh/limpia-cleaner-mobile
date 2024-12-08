
import 'package:limpia/core/utils/config.dart';
import 'package:limpia/core/utils/local_store_dir.dart';
import 'package:limpia/core/utils/local_stotage.dart';
import 'package:limpia/state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:limpia/app/app.bottomsheets.dart';
import 'package:limpia/app/app.dialogs.dart';
import 'package:limpia/app/app.locator.dart';
import 'package:limpia/app/app.router.dart';
import 'package:limpia/ui/common/app_colors.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:rxdart/rxdart.dart';

import 'core/data/repositories/repository.dart';
import 'core/network/api_response.dart';
import 'core/utils/enums.dart';

/// @author George David
/// email: georgequin19@gmail.com
/// Feb, 2024
///

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final repo = locator<Repository>();

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  setupDialogUi();
  setupBottomSheetUi();


  runApp(const MyApp());

}




class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    fetchUiState();
    _fetchEnums();
    super.initState();
  }

  void fetchUiState() async {
    String? savedMode =
        await locator<LocalStorage>().fetch(LocalStorageDir.uiMode);
    if (savedMode != null) {
      switch (savedMode) {
        case "light":
          uiMode.value = AppUiModes.light;
          break;
        case "dark":
          uiMode.value = AppUiModes.dark;
      }
    }
  }


  void _fetchEnums() async {
    print(' >>>>>>>>>>>> fetching enums');
    try {
      ApiResponse response = await repo.getEnums(null);
      if (response.statusCode == 200) {
        Enums.setEnums((response.data['enums'] as Map<String, dynamic>).map((key, value) => MapEntry(key, List<String>.from(value))));
        print(' >>>>>>>>>>>> fetched total of ${Enums.enums.length} enums');

      }
    }
    catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppUiModes>(
      valueListenable: uiMode,
      builder: (context, value, child) => MaterialApp(
        title: 'limpia',
        // theme: value == AppUiModes.dark ? darkTheme() : lightTheme(),
        theme: ThemeData.light(useMaterial3: true),
        darkTheme: ThemeData.dark(),
        themeMode: value == AppUiModes.dark ? ThemeMode.dark : ThemeMode.light,
        initialRoute: Routes.startupView,
        onGenerateRoute: StackedRouter().onGenerateRoute,
        navigatorKey: StackedService.navigatorKey,
        debugShowCheckedModeBanner: false,
        navigatorObservers: [
          StackedService.routeObserver,
        ],
      ),
    );
  }

  ThemeData darkTheme() {
    return ThemeData.dark().copyWith(
      appBarTheme: AppBarTheme(
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: kcWhiteColor,
        ),
        iconTheme: const IconThemeData(color: kcWhiteColor),
        toolbarTextStyle: const TextStyle(color: kcWhiteColor),
        elevation: 0,
        // systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      brightness: Brightness.dark,
      primaryColor: kcBackgroundColor,
      focusColor: kcPrimaryColor,
      textTheme: GoogleFonts.poppinsTextTheme().apply(bodyColor: kcWhiteColor),
    );
  }

  ThemeData lightTheme() {
    return ThemeData.light().copyWith(
      appBarTheme: AppBarTheme(
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: kcBlackColor,
        ),
        iconTheme: const IconThemeData(color: kcBlackColor),
        toolbarTextStyle: const TextStyle(color: kcBlackColor),
        backgroundColor: kcWhiteColor,
        elevation: 0,
        // systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      primaryColor: kcBackgroundColor,
      focusColor: kcPrimaryColor,
      textTheme: GoogleFonts.poppinsTextTheme().apply(bodyColor: kcBlackColor),
    );
  }
}
