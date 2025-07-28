import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code_sacnner_app/core/color/app_color.dart';
import 'package:qr_code_sacnner_app/core/constant/app_icons.dart';
import 'package:qr_code_sacnner_app/core/constant/app_strings.dart';
import 'package:qr_code_sacnner_app/core/extensions/context_extensions.dart';
import 'package:qr_code_sacnner_app/core/routes/app_router.dart';
import 'package:qr_code_sacnner_app/core/routes/args/show_qr_data_args.dart';
import 'package:qr_code_sacnner_app/core/services/di/di.dart';
import 'package:qr_code_sacnner_app/core/services/dialog_service.dart';
import 'package:qr_code_sacnner_app/core/utils/screen_utils.dart';
import 'package:qr_code_sacnner_app/features/generate/presentation/cubit/generate_cubit.dart';
import 'package:qr_code_sacnner_app/features/generate/presentation/screen/generate_screen.dart';
import 'package:qr_code_sacnner_app/features/history/presentation/cubit/history_cubit.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HistoryCubit>().loadHistories();
  }

  @override
  Widget build(BuildContext context) {
    final isLandScape = ScreenUtils.isLandscape(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColor.primaryColor,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              floating: true,
              snap: true,
              pinned: false,
              backgroundColor: AppColor.primaryColor,
              toolbarHeight: isLandScape
                  ? context.screenHeight * 0.20
                  : context.screenHeight * 0.12,
              title: const Text(
                AppStrings.history,
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                Container(
                  margin: EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(Icons.menu, color: AppColor.secondaryColor),
                    onPressed: () {},
                  ),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(
                  isLandScape
                      ? context.screenHeight * 0.15
                      : context.screenHeight * 0.07,
                ),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                    color: AppColor.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                      color: AppColor.secondaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white,
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    tabs: [
                      Tab(text: AppStrings.scan),
                      Tab(text: AppStrings.create),
                    ],
                  ),
                ),
              ),
            ),
          ],
          body: TabBarView(children: [HistoryTab(), GenerateTab()]),
        ),
      ),
    );
  }
}

class GenerateTab extends StatelessWidget {
  const GenerateTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GenerateCubit(),
      child: Column(
        children: [Expanded(child: GenerateScreen(isShowAppBar: false))],
      ),
    );
  }
}

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isLandScape = ScreenUtils.isLandscape(context);
    return Column(
      children: [
        Expanded(
          child: BlocConsumer<HistoryCubit, HistoryState>(
            bloc: BlocProvider.of<HistoryCubit>(context),
            listener: (context, state) {
              if (state is HistoryDeleteFailure) {
                getIt<DialogService>().showErrorDialog(
                  context: context,
                  title: AppStrings.errorDeletingHistory,
                  desc: state.message,
                  btnLabel: AppStrings.tryAgain,
                  onTap: () {
                    context.read<HistoryCubit>().deleteHistory(state.id);
                  },
                );
              } else if (state is HistoryFailure) {
                getIt<DialogService>().showErrorDialog(
                  context: context,
                  title: AppStrings.errorLoadingHistory,
                  desc: state.message,
                  btnLabel: AppStrings.tryAgain,
                  onTap: () {
                    context.read<HistoryCubit>().loadHistories();
                  },
                );
              }
            },
            builder: (context, state) {
              if (state is HistoryLoaded) {
                final histories = state.histories;
                if (histories.isEmpty) {
                  return Center(
                    child: LayoutBuilder(
                      builder: (context, constraints) => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            height: isLandScape
                                ? constraints.maxHeight * 0.65
                                : constraints.maxHeight * 0.35,
                            width: isLandScape
                                ? constraints.maxWidth * 0.65
                                : constraints.maxWidth * 0.35,
                            AppIcons.emptyBox,
                            colorFilter: ColorFilter.mode(
                              AppColor.secondaryColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          Text(
                            AppStrings.noHistoryFound,
                            style: TextStyle(
                              fontSize: context.textScaler.scale(18),
                              color: AppColor.secondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: histories.length,
                  itemBuilder: (context, index) {
                    final item = histories[index];

                    return Card(
                      elevation: 5,
                      color: AppColor.primaryColor,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),

                        leading: Icon(
                          _mapIcon(item.type),
                          color: AppColor.secondaryColor,
                          size: 35,
                        ),
                        title: Text(
                          histories[index].title,
                          style: TextStyle(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        subtitle: Text(
                          item.formattedDate,
                          style: TextStyle(color: Colors.white70),
                        ),
                        trailing: IconButton(
                          onPressed: () async {
                            await context.read<HistoryCubit>().deleteHistory(
                              histories[index].id,
                            );
                          },
                          icon: Icon(
                            Icons.delete,
                            color: AppColor.secondaryColor,
                          ),
                        ),
                        onTap: () {
                          context.push(
                            AppRouter.showQrData,
                            extra: ShowQrDataArgs(
                              qrData: item.content,
                              qrType: item.type,
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}

IconData _mapIcon(String type) {
  switch (type) {
    case 'URL':
      return Icons.link;
    case 'Text':
      return Icons.text_fields;
    case 'WiFi':
      return Icons.wifi;
    case 'Email':
      return Icons.email;
    case 'Phone':
      return Icons.phone;
    case 'SMS':
      return Icons.sms;
    case 'Location':
      return Icons.location_on;
    case 'Contact':
      return Icons.contact_page;
    default:
      return Icons.qr_code;
  }
}
