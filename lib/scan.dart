import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:textscanspeech/env.dart';
import 'package:textscanspeech/result.dart';

class Scanner extends StatefulWidget {
  const Scanner({Key? key}) : super(key: key);

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
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

  bool textScanning = false;

  XFile? imageFile;

  String scannedText = "";

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: SingleChildScrollView(
        child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: height * 0.025,
                ),
                if (textScanning) const CircularProgressIndicator(),
                if (!textScanning && imageFile == null)
                  Image.asset(
                    'assets/click.png',
                    scale: 1.3,
                  ),
                if (imageFile != null)
                  Image.file(
                    File(imageFile!.path),
                    scale: 1.1,
                  ),
                SizedBox(
                  height: height * 0.04,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        getImage(ImageSource.gallery);
                      },
                      child: Container(
                          alignment: Alignment.center,
                          width: width * 0.3,
                          height: height * 0.08,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(25)),
                          child: Icon(
                            Icons.image_rounded,
                            size: width * 0.1,
                          )
                          // const Text(
                          //   '갤러리',
                          //   style: TextStyle(color: Colors.white),
                          // ),
                          ),
                    ),
                    SizedBox(
                      width: width * 0.05,
                    ),
                    InkWell(
                      onTap: () {
                        getImage(ImageSource.camera);
                      },
                      child: Container(
                          alignment: Alignment.center,
                          width: width * 0.3,
                          height: height * 0.08,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(25)),
                          child: Icon(
                            Icons.camera_alt_rounded,
                            size: width * 0.1,
                          )
                          // Text(
                          //   '카메라',
                          //   style: TextStyle(color: Colors.white),
                          // ),
                          ),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.14,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Result(Text: scannedText),
                        ));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: width * 0.5,
                    height: height * 0.06,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(15)),
                    child: Text(
                      '전송',
                      style: TextStyle(
                          fontSize: width * 0.045, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                // SelectableText(
                //   scannedText,
                //   style: TextStyle(fontSize: 20),
                // )
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
            )),
      )),
    );
  }

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        textScanning = true;
        imageFile = pickedImage;
        setState(() {});
        getRecognisedText(pickedImage);
      }
    } catch (e) {
      textScanning = false;
      imageFile = null;
      scannedText = "Error occured while scanning";
      setState(() {});
    }
  }

  void getRecognisedText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.korean);
    RecognizedText recognisedText =
        await textRecognizer.processImage(inputImage);
    await textRecognizer.close();
    scannedText = "";
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = scannedText + line.text + "\n";
      }
    }
    textScanning = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }
}
