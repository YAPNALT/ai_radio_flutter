import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_radio_ai/model/radio.dart';
import 'package:flutter_radio_ai/utils/ai_util.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<MyRadio> radios = [];
  MyRadio? _selectedRadio;
  Color? _selectedColor;
  bool _isPlaying = false;
  bool _loading = false;

  final AudioPlayer _audioPlayer = AudioPlayer();

  fetchRadios() async {
    _loading = true;
    final radioJson = await rootBundle.loadString('assets/radio.json');
    radios = MyRadioList.fromJson(radioJson).radios;
    setState(() {
      _loading = false;
    });
  }

  _playMusic(String url) {
    _audioPlayer.play(url);
    _selectedRadio = radios.firstWhere((element) => element.url == url);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchRadios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      body: Stack(
        children: [
          VxAnimatedBox()
              .size(context.screenWidth, context.screenHeight)
              .withGradient(
                LinearGradient(
                  colors: [AIColors.primaryColor1, AIColors.primaryColor2],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              )
              .make(),
          AppBar(
            title: 'AI Radio'.text.xl4.bold.white.make().shimmer(
                  primaryColor: Vx.purple300,
                  secondaryColor: Colors.white,
                  duration: const Duration(
                    seconds: 2,
                  ),
                ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ).h(100).p16(),
          _loading
              ? const CircularProgressIndicator()
              : VxSwiper.builder(
                  enlargeCenterPage: true,
                  itemCount: radios.length,
                  aspectRatio: 1,
                  itemBuilder: (context, index) {
                    final rad = radios[index];
                    return VxBox(
                      child: ZStack(
                        [
                          Positioned(
                            top: 0.0,
                            right: 0.0,
                            child: VxBox(
                              child: rad.category.text.uppercase.white
                                  .make()
                                  .px16(),
                            )
                                .height(40)
                                .black
                                .alignCenter
                                .withRounded(value: 10)
                                .make(),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: VStack(
                              [
                                rad.name.text.xl3.white.bold.make(),
                                5.heightBox,
                                rad.tagline.text.sm.white.semiBold.make(),
                              ],
                              crossAlignment: CrossAxisAlignment.center,
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: [
                              const Icon(
                                Icons.play_circle_outline_outlined,
                                color: Colors.white,
                              ),
                              10.heightBox,
                              'Double tap to play'.text.gray300.make(),
                            ].vStack(),
                          ),
                        ],
                        clip: Clip.antiAlias,
                      ),
                    )
                        .clip(Clip.antiAlias)
                        .bgImage(
                          DecorationImage(
                            image: NetworkImage(rad.image),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.3),
                              BlendMode.darken,
                            ),
                          ),
                        )
                        .border(color: Colors.black, width: 5.0)
                        .withRounded(value: 60)
                        .make()
                        .onInkDoubleTap(() {})
                        .p16();
                  }).centered(),
          const Align(
            alignment: Alignment.bottomCenter,
            child: Icon(
              Icons.stop_circle_outlined,
              color: Colors.white,
              size: 50,
            ),
          ).pOnly(bottom: context.percentHeight * 12),
        ],
        fit: StackFit.expand,
        clipBehavior: Clip.antiAlias,
      ),
    );
  }
}
