import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liftday/sevices/bloc/app_bar/app_bar_bloc.dart';
import 'package:liftday/sevices/bloc/app_bar/app_bar_state.dart';
import 'package:liftday/view/pages/settings_page.dart';
import 'package:liftday/view/pages/training_page.dart';
import 'package:liftday/view/pages/plans_pages.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView>
    with SingleTickerProviderStateMixin {
  final List<Widget> _pages = [
    const TrainingPage(),
    const PlansTab(),
    /*const StatisticsPage(),*/
    const SettingsPage(),
  ];

  int _selectedIndex = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 1
          ? AppBar(
              title: Theme.of(context).brightness == Brightness.dark
                  ? Image.asset('assets/liftday_logo_dark.png', height: 25.0)
                  : Image.asset('assets/liftday_logo.png', height: 25.0),
              centerTitle: true,
              elevation: 0,
              scrolledUnderElevation: 0.0,
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: Theme.of(context).colorScheme.secondary,
                labelColor: Theme.of(context).colorScheme.secondary,
                unselectedLabelColor: Colors.grey,
                labelStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                unselectedLabelStyle: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.normal),
                tabs: [
                  Tab(
                    text: AppLocalizations.of(context)!.plan,
                  ),
                  Tab(
                    text: AppLocalizations.of(context)!.routines,
                  ),
                ],
              ),
            )
          : _selectedIndex == 0
              ? AppBar(
                  title: BlocBuilder<AppBarBloc, AppBarState>(
                    builder: (context, state) => state.title,
                  ),
                  centerTitle: true,
                  elevation: 0,
                  scrolledUnderElevation: 0.0,
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                )
              : AppBar(
                  title: Theme.of(context).brightness == Brightness.dark
                      ? Image.asset('assets/liftday_logo_dark.png',
                          height: 25.0)
                      : Image.asset('assets/liftday_logo.png', height: 25.0),
                  centerTitle: true,
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  elevation: 0,
                  scrolledUnderElevation: 0.0,
                ),

      body: _selectedIndex == 1
          ? TabBarView(
              controller: _tabController,
              children: const [
                PlansTab(),
                RoutinesTab(),
              ],
            )
          : _pages[_selectedIndex], // Inne strony

      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_month),
            label: AppLocalizations.of(context)!.training,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.description),
            label: AppLocalizations.of(context)!.plan,
          ),
          /*BottomNavigationBarItem(
            icon: const Icon(Icons.bar_chart),
            label: AppLocalizations.of(context)!.statistics,
          ),*/
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: AppLocalizations.of(context)!.settings,
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Colors.grey.withOpacity(0.5),
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
