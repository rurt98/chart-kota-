import 'dart:async';

import 'package:final_project_ba_char/enum/pages.dart';
import 'package:final_project_ba_char/helpers/responsive_helpers.dart';
import 'package:final_project_ba_char/models/user.dart';
import 'package:final_project_ba_char/providers/auth_provider.dart';
import 'package:final_project_ba_char/providers/bar_navigation_provider.dart';
import 'package:final_project_ba_char/screens/no_page_found.dart';
import 'package:final_project_ba_char/styles/colors.dart';
import 'package:final_project_ba_char/styles/styles.dart';
import 'package:final_project_ba_char/utilities/show_dialog.dart';
import 'package:final_project_ba_char/utilities/show_snackbar.dart';
import 'package:final_project_ba_char/widgets/perfil_widget.dart';
import 'package:final_project_ba_char/widgets/photo_letter_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// import 'dart:html' as html;

class DashboardLayout extends StatefulWidget {
  final Widget? child;
  final PageMenu? currentPage;

  const DashboardLayout({
    super.key,
    this.child,
    required this.currentPage,
  });

  @override
  State<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout>
    with WidgetsBindingObserver {
  final double itemMenuWidth = 200;
  // static const double maxWidthNavigationBar = 250;
  // static const double minWidthNavigationBar = 85;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final hoverPage = ValueNotifier<bool>(false);

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {});
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: context.screenSize != ScreenSize.small
          ? null
          : AppBar(
              title: Text(
                widget.currentPage?.baseRoute?.title ?? '-',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
      body: Selector<BarNavigationProvider, bool>(
        selector: (_, p) => p.barExpanded,
        builder: (_, barExpanded, __) {
          if (context.screenSize == ScreenSize.small) {
            return widget.child ?? const NoPageFound();
          }
          return Stack(
            children: [
              MouseRegion(
                onEnter: (event) => hoverPage.value = false,
                hitTestBehavior: HitTestBehavior.translucent,
                child: AnimatedContainer(
                  width: double.infinity,
                  height: double.infinity,
                  margin: EdgeInsets.only(
                      left: barExpanded ? itemMenuWidth + 10 : 60),
                  duration:
                      context.read<BarNavigationProvider>().drawerDuration,
                  child: Column(
                    children: [
                      _buildHeader(),
                      Expanded(
                        child: widget.child ?? const NoPageFound(),
                      )
                    ],
                  ),
                ),
              ),
              _navigationBar(),
              AnimatedContainer(
                width: 20,
                height: 20,
                duration: context.read<BarNavigationProvider>().drawerDuration,
                margin: EdgeInsets.only(
                    top: 50, left: barExpanded ? itemMenuWidth : 50),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: orangeApp,
                ),
                child: Material(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      end = false;

                      context.read<BarNavigationProvider>().barExpanded =
                          !barExpanded;
                    },
                    child: Icon(
                      barExpanded
                          ? Icons.keyboard_arrow_left
                          : Icons.keyboard_arrow_right,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      drawer: context.screenSize != ScreenSize.small ? null : drawer(),
    );
  }

  Widget drawer() {
    return Drawer(
      child: Column(
        children: [
          Selector<AuthProvider, User?>(
            selector: (_, p) => p.user,
            builder: (_, user, __) {
              return SafeArea(
                bottom: false,
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: ListTile(
                    tileColor: primaryColor[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    leading: Container(
                      decoration: BoxDecoration(
                          boxShadow: boxShadowBlack,
                          borderRadius: BorderRadius.circular(100)),
                      child: PhotoLetterWidget(
                        radius: 20,
                        letter: user?.toString(),
                        color: Colors.blue,
                      ),
                    ),
                    title: Text(
                      user?.toString() ?? '',
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: const Text(
                      'Ver perfil',
                      style: TextStyle(color: Colors.white70),
                    ),
                    onTap: () {
                      _scaffoldKey.currentState?.openEndDrawer();
                      openProfileDialog();
                    },
                  ),
                ),
              );
            },
          ),
          Divider(
            color: accentColor,
          ),
          SafeArea(
            top: false,
            child: ListTile(
              leading: Icon(
                Icons.exit_to_app_outlined,
                color: Theme.of(context)
                    .navigationRailTheme
                    .unselectedIconTheme
                    ?.color,
              ),
              title: Text(
                'Cerrar sesión',
                style: TextStyle(
                  color: Theme.of(context)
                      .navigationRailTheme
                      .unselectedIconTheme
                      ?.color,
                ),
              ),
              onTap: () => context.read<AuthProvider>().logout(
                    context,
                    onError: () => ShowSnackBar.showError(context),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    if (context.screenSize == ScreenSize.small) return const SizedBox();

    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: _buildPageTitle(),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: VerticalDivider(
              color: greyApp,
            ),
          ),
          _buildUserInfo(),
        ],
      ),
    );
  }

  Widget _buildPageTitle() {
    final selectedPage = widget.currentPage?.baseRoute;

    if (selectedPage == null) return const SizedBox();
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            padding: EdgeInsets.only(
              left: 25,
              right: context.screenSize == ScreenSize.large ? 5 : 25,
            ),
            height: double.infinity,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                selectedPage.title,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(),
              ),
            ),
          ),
        ),
        const Spacer(
          flex: 4,
        ),
      ],
    );
  }

  Widget _buildUserInfo() {
    return InkWell(
      onTap: () => openProfileDialog(),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.person,
                size: 25,
              ),
            ),
            const SizedBox(width: 10),
            Selector<AuthProvider, User?>(
              selector: (_, p) => p.user,
              builder: (_, user, __) {
                return ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 100,
                    minWidth: 100,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        user?.names ?? '-',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: darkGreyApp,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        user?.role?.nombreEs ?? '-',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: darkGreyApp,
                              fontSize: 10,
                            ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void openProfileDialog() async {
    await ShowDialog.showSimpleRightDialog(
      context,
      width: 500,
      child: const SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: PerfilWidget(),
      ),
      alignment: Alignment.topRight,
    );
  }

  bool end = true;

  Widget _navigationBar() {
    return Selector<BarNavigationProvider, bool>(
      selector: (_, p) => p.barExpanded,
      builder: (_, barExpanded, __) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AnimatedContainer(
              width: barExpanded ? itemMenuWidth + 10 : 60,
              duration: context.read<BarNavigationProvider>().drawerDuration,
              height: double.infinity,
              color: primaryColor,
              onEnd: () => setState(() {
                end = true;
              }),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => context.go(PageMenu.sales.route),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: ImageSwitcher(
                        currentImageIndex: barExpanded ? 0 : 1,
                        width: 150,
                        height: 40,
                        images: const [
                          'assets/logos/char[Kota].png',
                          'assets/logos/[Kota].png'
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(right: 5),
                      controller: ScrollController(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ...PageMenuExtension.navigationBarrancoSoft.map(
                            (e) {
                              return navigationItem(
                                pageMenu: e,
                                barExpanded: barExpanded,
                              );
                              // switch (e) {
                              //   case PageMenu.conversations:
                              //     return _chatIcon(barExpanded, e);
                              //   case PageMenu.tickets:
                              //     return _ticketIcon(barExpanded, e);
                              //   default:
                              //     return navigationItem(
                              //       pageMenu: e,
                              //       barExpanded: barExpanded,
                              //     );
                              // }
                            },
                          ).toList(),
                        ],
                      ),
                    ),
                  ),
                  navigationItem(
                    onPressed: () => context.read<AuthProvider>().logout(
                        context,
                        onError: () => ShowSnackBar.showError(context)),
                    title: 'Cerrar sesión',
                    icon: Icons.logout,
                    barExpanded: barExpanded,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future? delayHover;

  Widget navigationItem({
    VoidCallback? onPressed,
    PageMenu? pageMenu,
    String? title,
    IconData? icon,
    required bool barExpanded,
    bool isExtraItem = false,
    bool isLabelVisible = false,
    int? count,
  }) {
    final expanded = context.screenSize == ScreenSize.small || barExpanded;
    final selectedPage = widget.currentPage?.baseRoute;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        // onHover: (value) {
        //   if (onPressed != null || context.screenSize == ScreenSize.small) {
        //     return;
        //   }

        //   if (value) {
        //     final delayHover =
        //         Future.delayed(const Duration(milliseconds: 300));
        //     delayHover.then(
        //       (value) {
        //         if (this.delayHover == delayHover) {
        //           hoverPage.value = pageMenu?.hasSubPages(
        //                       context.read<AuthProvider>().user?.isAdmin ??
        //                           false) ==
        //                   true
        //               ? true
        //               : false;
        //         }
        //       },
        //     );
        //     this.delayHover = delayHover;
        //   } else {
        //     delayHover = null;
        //   }
        // },
        onTap: !isExtraItem
            ? () {
                // if (pageMenu?.hasSubPages(
                //         context.read<AuthProvider>().user?.isAdmin ?? false) ==
                //     true) hoverPage.value = true;

                if (onPressed != null) {
                  onPressed.call();

                  return;
                }

                if (selectedPage?.name == pageMenu!.name) {
                  return;
                }

                context.go(pageMenu.route);
              }
            : null,
        child: Padding(
          padding: !isExtraItem
              ? const EdgeInsets.symmetric(vertical: 8.0)
              : EdgeInsets.zero,
          child: Row(
            children: [
              AnimatedContainer(
                width: 5,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  color: selectedPage?.name == pageMenu?.name
                      ? orangeApp
                      : Colors.transparent,
                ),
                duration: context.read<BarNavigationProvider>().drawerDuration,
              ),
              const SizedBox(width: 10),
              IconTheme(
                data: selectedPage?.name == pageMenu?.name
                    ? Theme.of(context).navigationRailTheme.selectedIconTheme ??
                        const IconThemeData()
                    : Theme.of(context)
                            .navigationRailTheme
                            .unselectedIconTheme ??
                        const IconThemeData(),
                child: Badge.count(
                  isLabelVisible: isLabelVisible,
                  count: count ?? 0,
                  backgroundColor: goldApp,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Icon(
                      icon ??
                          (selectedPage?.name == pageMenu?.name
                              ? pageMenu?.icon
                              : pageMenu?.iconOutlined),
                      size: 16,
                    ),
                  ),
                ),
              ),
              if (end && expanded)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 12),
                    constraints: const BoxConstraints(
                      maxHeight: 100,
                    ),
                    child: Text(
                      title ?? pageMenu?.title ?? '',
                      maxLines: 1,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: selectedPage?.name == pageMenu?.name
                                ? orangeApp
                                : Theme.of(context)
                                    .navigationRailTheme
                                    .unselectedIconTheme
                                    ?.color,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            wordSpacing: 0.01,
                            letterSpacing: 0.01,
                          ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// TODO:
// class SearchPageWidget extends StatelessWidget {
//   const SearchPageWidget({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return CustomAutoComplete<PageMenu>(
//           optionsBuilder: (textEditingValue) async {
//             return PageMenuExtension.titles.entries
//                 .where((element) => element
//                     .value(context)
//                     .toLowerCase()
//                     .contains(textEditingValue.text.toLowerCase()))
//                 .map((e) => e.key)
//                 .toList()
//               ..removeWhere(
//                 (element) => user?.getRole == types.Role.admin
//                     ? element.route.contains(':')
//                     : element.route.contains(':') ||
//                         !PageMenuExtension.navigation(
//                               false,
//                               isCampaignSupervisor:
//                                   user?.isCampaignSupervisor ?? false,
//                             ).any((e) => e == element) &&
//                             !PageMenu.cruds
//                                 .subPagesList(true)!
//                                 .any((e) => e == element),
//               );
//           },
//           suffixIconColor: accentColor,
//           onSelected: (option) => context.go(option.route),
//           decoration: InputDecoration(
//             prefixIcon: const Icon(Icons.search, size: 15),
//             hintText: AppLocalizations.of(context)!.quickSearch,
//             contentPadding: EdgeInsets.zero,
//           ),
//         );
//   }
// }

class ImageSwitcher extends StatefulWidget {
  final int currentImageIndex;
  final List<String> images;
  final double width;
  final double height;

  const ImageSwitcher(
      {super.key,
      required this.currentImageIndex,
      required this.images,
      required this.height,
      required this.width});
  @override
  ImageSwitcherState createState() => ImageSwitcherState();
}

class ImageSwitcherState extends State<ImageSwitcher> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: SizedBox(
        key: ValueKey<int>(widget.currentImageIndex),
        width: widget.width,
        height: widget.height,
        child: Image.asset(
          widget.images[widget.currentImageIndex],
          fit: BoxFit.fitWidth,
          color: Colors.white,
        ),
      ),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}
