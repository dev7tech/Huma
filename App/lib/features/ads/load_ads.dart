// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:hookup4u2/features/ads/google_ads.dart';

class LoadAds {
  // static void loadInterstitialAd(
  //     InterstitialAd? interstitialAd, bool isInterstitialAdReady) {
  //   InterstitialAd.load(
  //     adUnitId: AdHelper.interstitialAdUnitId,
  //     request: const AdRequest(),
  //     adLoadCallback: InterstitialAdLoadCallback(
  //       onAdLoaded: (ad) {
  //         interstitialAd = ad;

  //         ad.fullScreenContentCallback = FullScreenContentCallback(
  //           onAdDismissedFullScreenContent: (ad) {
  //             //  _moveToHome();
  //           },
  //         );

  //         isInterstitialAdReady = true;
  //       },
  //       onAdFailedToLoad: (err) {
  //         debugPrint('Failed to load an interstitial ad: ${err.message}');
  //         isInterstitialAdReady = false;
  //       },
  //     ),
  //   );
  // }

  // static void loadAds(InterstitialAd? interstitialAd) {
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
  // }

  // final BannerAdListener listener = BannerAdListener(
  //   // Called when an ad is successfully received.
  //   onAdLoaded: (Ad ad) {
  //     debugPrint('Ad loaded.');
  //   },
  //   // Called when an ad request failed.
  //   onAdFailedToLoad: (Ad ad, LoadAdError error) {
  //     // Dispose the ad here to free resources.
  //     ad.dispose();
  //     debugPrint('Ad failed to load: $error');
  //   },
  //   // Called when an ad opens an overlay that covers the screen.
  //   onAdOpened: (Ad ad) => debugPrint('Ad opened.'),
  //   // Called when an ad removes an overlay that covers the screen.
  //   onAdClosed: (Ad ad) => debugPrint('Ad closed.'),
  //   // Called when an impression occurs on the ad.
  //   onAdImpression: (Ad ad) => debugPrint('Ad impression.'),
  // );
}
