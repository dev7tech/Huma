import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:hookup4u2/features/ads/google_ads.dart';
// import 'package:hookup4u2/features/ads/load_ads.dart';
import 'package:hookup4u2/features/auth/auth_status/bloc/registration/bloc/registration_bloc.dart';

import 'package:hookup4u2/features/match/ui/widget/match_dailog.dart';
import 'package:hookup4u2/features/user/profile/cubit/profile_visit_cubit.dart';
import 'package:provider/provider.dart';
import 'package:swipable_stack/swipable_stack.dart';

import '../../../../common/constants/colors.dart';
import '../../../../common/providers/theme_provider.dart';
import '../../../../common/utils/swiper_stack.dart';

import '../../bloc/search_user_bloc.dart';
import '../../bloc/swipe_bloc.dart';
import 'swipe_card.dart';

List userRemoved = [];

class Homepage extends StatefulWidget {
  final Map items;
  final bool isPurchased;
  const Homepage({
    super.key,
    required this.items,
    required this.isPurchased,
  });

  @override
  HomepageState createState() => HomepageState();
}

class HomepageState extends State<Homepage>
    with AutomaticKeepAliveClientMixin<Homepage> {
  // TabbarState state = TabbarState();
  bool onEnd = false;
  SwipableStackController? stackController;
  // List<UserModel> users = [];
  int swipedcount = 0;

  // InterstitialAd? interstitialAd;
  bool isInterstitialAdReady = false;

  GlobalKey<SwipeStackState> swipeKey = GlobalKey<SwipeStackState>();
  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    // interstitialAd?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // final userProvider = Provider.of<UserProvider>(context, listen: false);
    // currentUser = userProvider.currentUser!;
    final currentUser = context.read<RegistrationBloc>().state.profile;

    // fetchData();
    context.read<SearchUserBloc>().add(
          LoadUserEvent(
            currentUser: currentUser,
          ),
        );

    // _adsCheck(swipedcount);
    // InterstitialAd.load(
    //     adUnitId: AdHelper.interstitialAdUnitId,
    //     request: const AdRequest(),
    //     adLoadCallback: InterstitialAdLoadCallback(
    //       onAdLoaded: (InterstitialAd ad) {
    //         // Keep a reference to the ad so you can show it later.
    //         interstitialAd = ad;
    //       },
    //       onAdFailedToLoad: (LoadAdError error) {
    //         debugPrint('InterstitialAd failed to load: $error');
    //       },
    //     ));

    super.initState();
  }

  Future<void> fetchData() async {
    // final swipeCount = await UserSearchRepo.getSwipedCount(currentUser);
    // setState(() {
    //   swipedcount = swipeCount;
    // });
    // debugPrint(swipeCount.toString()); // Use the swipe count in your code
  }

  void _adsCheck(int count) {
    debugPrint("ads ${count.toString()}");
    if (count % 5 == 0) {
      // LoadAds.loadInterstitialAd(interstitialAd, isInterstitialAdReady);

      // interstitialAd?.show();
      // InterstitialAd.load(
      //     adUnitId: AdHelper.interstitialAdUnitId,
      //     request: const AdRequest(),
      //     adLoadCallback: InterstitialAdLoadCallback(
      //       onAdLoaded: (InterstitialAd ad) {
      //         // Keep a reference to the ad so you can show it later.
      //         interstitialAd = ad;
      //       },
      //       onAdFailedToLoad: (LoadAdError error) {
      //         debugPrint('InterstitialAd failed to load: $error');
      //       },
      //     ));
    } else {}
  }

  @override
  Future<void> didChangeDependencies() async {
    // TODO: Trigger update
    // await firebaseFireStoreInstance
    //     .collection('Users')
    //     .doc(currentUser.id)
    //     .update({'lastvisited': DateTime.now()});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: CHECK NECESSITY
    super.build(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final likedBy =
        context.select((ProfileVisitCubit cubit) => cubit.state.likedBy);
    debugPrint('swipedcount-$swipedcount-///////////////////////////////////');

    int freeSwipe = widget.items['free_swipes'] != null
        ? int.parse(widget.items['free_swipes'])
        : 10;
    bool exceedSwipes = !widget.isPurchased ? swipedcount >= freeSwipe : false;
    //
    debugPrint("swipeexceed $exceedSwipes");
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50)),
            color: Theme.of(context).primaryColor),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50), topRight: Radius.circular(50)),
          child: Stack(
            children: [
              AbsorbPointer(
                absorbing: exceedSwipes,
                child: Stack(
                  children: <Widget>[
                    BlocBuilder<SearchUserBloc, SearchUserState>(
                      builder: (context, state) {
                        if (state is SearchUserLoadingState) {
                          debugPrint("I AM IN LOADINGSTATE");
                          stackController = SwipableStackController();

                          return Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(primaryColor),
                            ),
                          );
                        }

                        if (state is SearchUserFailedState) {
                          debugPrint("I AM IN LOADUSERSFailed");
                          return Center(
                              child: Text(
                            "Error to load data.".tr().toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: themeProvider.isDarkMode
                                    ? Colors.white
                                    : Colors.black54,
                                fontStyle: FontStyle.normal,
                                letterSpacing: 1,
                                decoration: TextDecoration.none,
                                fontSize: 18),
                          ));
                        }

                        if (state is SearchUserLoadUserState) {
                          return BlocBuilder<RegistrationBloc,
                              RegistrationState>(
                            builder: (context, regState) {
                              return Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor),
                                height:
                                    MediaQuery.of(context).size.height * .78,
                                width: MediaQuery.of(context).size.width,
                                child:
                                    // //onEnd ||
                                    state.users.isEmpty
                                        ? Align(
                                            alignment: Alignment.center,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.grey[200],
                                                    radius: 50,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Image.asset(
                                                        "asset/hookup4u-Logo-BP.png",
                                                        fit: BoxFit.contain,
                                                        color: primaryColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  "There's no one new around you."
                                                      .tr()
                                                      .toString(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: themeProvider
                                                              .isDarkMode
                                                          ? Colors.white
                                                          : Colors.black54,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      letterSpacing: 1,
                                                      decoration:
                                                          TextDecoration.none,
                                                      fontSize: 20),
                                                )
                                              ],
                                            ),
                                          )
                                        : UsersList(
                                            onswiped: (int index,
                                                SwipeDirection dir) {
                                              if (dir == SwipeDirection.right) {
                                                print('swipe right');
                                                context.read<SwipeBloc>().add(
                                                      RightSwipeEvent(
                                                        currentUser:
                                                            regState.profile,
                                                        selectedUser:
                                                            state.users[index],
                                                      ),
                                                    );

                                                if (likedBy.contains(
                                                    state.users[index].id)) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (ctx) {
                                                        return MatchedPage(
                                                          name: state
                                                              .users[index]
                                                              .userName!,
                                                          currentUser:
                                                              regState.profile,
                                                        );
                                                      });
                                                }

                                                if (index <
                                                    state.users.length) {
                                                  userRemoved.clear();
                                                  setState(() {
                                                    userRemoved.add(
                                                        state.users[index]);
                                                  });
                                                }
                                              }
                                              if (dir == SwipeDirection.left) {
                                                print('swipe left');
                                                context.read<SwipeBloc>().add(
                                                      LeftSwipeEvent(
                                                        currentUser:
                                                            regState.profile,
                                                        selectedUser:
                                                            state.users[index],
                                                      ),
                                                    );

                                                // debugPrint("ankit ${state.users.length.toString()}");
                                                if (index <
                                                    state.users.length) {
                                                  userRemoved.clear();
                                                  setState(() {
                                                    userRemoved.add(
                                                        state.users[index]);
                                                  });
                                                }
                                              }
                                              swipedcount++;
                                              _adsCheck(swipedcount);
                                            },
                                            stackController: stackController,
                                            users: state.users,
                                            currentUser: regState.profile,
                                            usersList: state.users,
                                          ),
                              );
                            },
                          );
                        }
                        return Container();
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            userRemoved.isNotEmpty
                                ? FloatingActionButton(
                                    heroTag: UniqueKey(),
                                    backgroundColor: Colors.white,
                                    onPressed: () {
                                      debugPrint("rewind pressed");
                                      stackController?.rewind(
                                          duration: const Duration(
                                              milliseconds: 500));

                                      setState(() {
                                        userRemoved.clear();
                                      });
                                    },
                                    child: Icon(
                                      userRemoved.isNotEmpty
                                          ? Icons.replay
                                          : Icons.not_interested,
                                      color: userRemoved.isNotEmpty
                                          ? Colors.amber
                                          : secondaryColor,
                                      size: 20,
                                    ))
                                : FloatingActionButton(
                                    heroTag: UniqueKey(),
                                    backgroundColor: Colors.white,
                                    child: const Icon(
                                      Icons.refresh,
                                      color: Colors.green,
                                      size: 20,
                                    ),
                                    onPressed: () {},
                                  ),
                            FloatingActionButton(
                                heroTag: UniqueKey(),
                                backgroundColor: Colors.white,
                                child: const Icon(
                                  Icons.clear,
                                  color: Colors.red,
                                  size: 30,
                                ),
                                onPressed: () {
                                  stackController?.next(
                                      swipeDirection: SwipeDirection.left);
                                }),
                            FloatingActionButton(
                                heroTag: UniqueKey(),
                                backgroundColor: Colors.white,
                                child: const Icon(
                                  Icons.favorite,
                                  color: Colors.lightBlueAccent,
                                  size: 30,
                                ),
                                onPressed: () {
                                  stackController?.next(
                                      swipeDirection: SwipeDirection.right);
                                }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // TODO: UPdate exceeded
              exceedSwipes
                  ? const Text('Premeium')
                  // PremiumSwipePage(
                  //     currentUser: currentUser,
                  //   )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
