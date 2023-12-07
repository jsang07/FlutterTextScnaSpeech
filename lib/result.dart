import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:textscanspeech/env.dart';

class Result extends StatefulWidget {
  final String Text;
  const Result({super.key, required this.Text});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  late BannerAd bannerAd;
  bool isBannerAdLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: addId,
      listener: BannerAdListener(onAdFailedToLoad: (ad, error) {
        print("Ad Failed to Load");
        ad.dispose();
      }, onAdLoaded: (ad) {
        print("Ad Loaded");
        setState(() {
          isBannerAdLoaded = true;
        });
      }),
      request: const AdRequest(),
    );
    bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                margin: const EdgeInsets.only(left: 10, right: 10, top: 30),
                padding: const EdgeInsets.all(8),
                child: SelectableText(
                  widget.Text,
                  style: const TextStyle(fontSize: 20),
                )),
            const SizedBox(
              height: 10,
            ),
            isBannerAdLoaded
                ? SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: AdWidget(
                      ad: bannerAd,
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
