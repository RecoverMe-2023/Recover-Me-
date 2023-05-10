import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:readmore/readmore.dart';
import 'package:recover_me/presentation/components/components.dart';
import 'package:recover_me/presentation/pages/home/patient/patient_edit_profile.dart';
import 'package:recover_me/data/models/game_model.dart';
import 'package:recover_me/data/styles/paddings.dart';
import 'package:recover_me/domain/bloc/recover/recover_cubit.dart';
import 'package:recover_me/presentation/widgets/glassy.dart';
import 'package:recover_me/presentation/widgets/my_background_designs.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../../data/styles/colors.dart';
import '../../../../../data/styles/fonts.dart';
import '../../../../../data/styles/texts.dart';
import '../../../widgets/my_loading.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({Key? key}) : super(key: key);

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  double screenHeight = 0;
  double screenWidth = 0;
  bool startAnimation = false;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  getData() async {
    setState(() {
      RecoverCubit.get(context).games.clear();
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      RecoverCubit.get(context).getGames();
      RecoverCubit.get(context).getPatientData();
    });
    refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    //getPaletteColor();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        startAnimation = true;
      });
    });
  }

  PageController pageController = PageController();
  // PaletteGenerator? paletteGenerator;
  //
  // void getPaletteColor({GameModel? gameModel}) async {
  //   paletteGenerator = await PaletteGenerator.fromImageProvider(
  //       gameModel != null
  //           ? NetworkImage(gameModel.image)
  //           : NetworkImage(RecoverCubit.get(context).games[0].image));
  //   setState(() {});
  // }
  //
  // Color paletteColor() {
  //   return paletteGenerator != null
  //       ? paletteGenerator!.dominantColor != null
  //           ? paletteGenerator!.dominantColor!.color
  //           : Colors.white
  //       : Colors.white;
  // }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return BlocConsumer<RecoverCubit, RecoverState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = RecoverCubit.get(context);
        var patientLoginModel = cubit.patientLoginModel;
        return Scaffold(
         /// backgroundColor: paletteColor(),
          body: SafeArea(
            child: SmartRefresher(
              controller: refreshController,
              header: WaterDropHeader(
                waterDropColor: RecoverColors.myColor,
                refresh: const MyLoading(),
                complete: Container(),
                completeDuration: Duration.zero,
              ),
              onRefresh: () => getData(),
              child: SingleChildScrollView(
                //physics: const BouncingScrollPhysics(),
                child: typeBackground(
                  asset: 'assets/images/rr.jpg',
                  context: context,
                  child: RecoverPaddings.recoverAuthPadding(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      //mainAxisSize: MainAxisSize.max,
                      children: [
                        const SizedBox(height: 5),
                        glassyContainer(
                          child: RecoverHeadlines(
                            headline: 'Recover sphere profile',
                            color: RecoverColors.recoverWhite,
                            fs: 20,
                          ),
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () {
                            navigateTo(context, const PatientEditProfile());
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: RecoverColors.myColor,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RecoverHeadlines(
                                      headline: 'Patient:',
                                      color: RecoverColors.recoverWhite,
                                      fs: 20,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    RecoverNormalTexts(
                                      norText: patientLoginModel!.name,
                                      color: RecoverColors.recoverWhite,
                                      fs: 16.0,
                                      maxLines: 1,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    RecoverHints(
                                      hint: patientLoginModel.disability ?? '',
                                      color: RecoverColors.recoverWhite,
                                      fs: 15.0,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                CircleAvatar(
                                  radius:
                                      MediaQuery.of(context).size.width / 10,
                                  backgroundColor: Colors.white,
                                  backgroundImage: CachedNetworkImageProvider(
                                    patientLoginModel.profileImage,
                                  ),
                                  // child: CachedNetworkImage(
                                  //   imageUrl: dLModel.profileImage!,
                                  //   progressIndicatorBuilder:
                                  //       (context, url, progress) => Center(
                                  //     child: CircularProgressIndicator(
                                  //       value: progress.progress,
                                  //     ),
                                  //   ),
                                  //   fit: BoxFit.cover,
                                  // ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        glassyContainer(
                          child: RecoverHeadlines(
                            headline: 'Recover sphere games',
                            color: RecoverColors.myColor,
                            fs: 20,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              //color: Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 15.0),
                              child: SmoothPageIndicator(
                                controller: pageController,
                                count: cubit.games.length,
                                effect: const ExpandingDotsEffect(
                                  dotWidth: 16.0,
                                  dotHeight: 16.0,
                                  dotColor: Colors.grey,
                                  activeDotColor: RecoverColors.myColor,
                                  radius: 16.0,
                                  spacing: 6,
                                  expansionFactor: 4.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child : SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: PageView.builder(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              controller: pageController,
                              onPageChanged: (value) {
                                setState(() {
                                  // getPaletteColor(gameModel: cubit.games[value]);
                                });
                              },
                              itemBuilder: (context, index) {
                                return buildGameItem(
                                  gameModel: cubit.games[index],
                                );
                              },
                              itemCount: cubit.games.length,
                            ),
                          ),
                        ),
                        const SizedBox(height: 0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget buildGameItem({required GameModel gameModel}) {
  return Column(
    children: [
      Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(152),
        ),
        elevation: 20.0,
        child: ClipRRect(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: CircleAvatar(
            radius: 152,
            backgroundColor: RecoverColors.myColor,
            child: CircleAvatar(
              radius: 150,
              backgroundImage: CachedNetworkImageProvider(gameModel.image),
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 5,
      ),
      glassyContainer(
        child: RecoverNormalTexts(
          norText: gameModel.name,
          color: RecoverColors.recoverWhite,
        ),
      ),
      Expanded(
        child : SizedBox(
          height: 500,
          child: SingleChildScrollView(
            child : glassyContainer(
              child: ReadMoreText(
                gameModel.description,
                moreStyle: RecoverTextStyles.recoverHintMontserrat(
                    color: RecoverColors.recoverWhite),
                style: RecoverTextStyles.recoverHintMontserrat(
                  color: RecoverColors.recoverWhite,
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget myContainer({required Widget child}) {
  return Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      border: Border.all(
        color: RecoverColors.myColor,
        width: 2.0,
      ),
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: child,
  );
}
