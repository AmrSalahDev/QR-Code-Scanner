import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code_sacnner_app/core/color/app_color.dart';
import 'package:qr_code_sacnner_app/core/constant/app_icons.dart';
import 'package:qr_code_sacnner_app/core/constant/app_strings.dart';
import 'package:qr_code_sacnner_app/core/extensions/context_extensions.dart';
import 'package:qr_code_sacnner_app/core/routes/app_router.dart';
import 'package:qr_code_sacnner_app/core/services/di/di.dart';
import 'package:qr_code_sacnner_app/core/services/dialog_service.dart';
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColor.primaryColor,
        appBar: _CustomAppBar(),
        body: TabBarView(
          children: [
            Column(
              children: [
                SizedBox(height: 20),
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
                            context.read<HistoryCubit>().deleteHistory(
                              state.id,
                            );
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  height: 170,
                                  width: 170,
                                  AppIcons.emptyBox,
                                  colorFilter: ColorFilter.mode(
                                    AppColor.secondaryColor,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                Text(
                                  AppStrings.noHistoryFound,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: AppColor.secondaryColor,
                                  ),
                                ),
                              ],
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
                                    await context
                                        .read<HistoryCubit>()
                                        .deleteHistory(histories[index].id);
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: AppColor.secondaryColor,
                                  ),
                                ),
                                onTap: () {
                                  context.push(
                                    AppRouter.showQrData,
                                    extra: {
                                      'data': item.content,
                                      'type': item.type,
                                    },
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
            ),
            BlocProvider(
              create: (context) => GenerateCubit(),
              child: Column(
                children: [
                  SizedBox(height: context.screenHeight * 0.03),
                  Expanded(child: GenerateScreen(isShowAppBar: false)),
                ],
              ),
            ),
          ],
        ),
      ),
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

class _CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  _CustomAppBar() : preferredSize = Size.fromHeight(135);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 80,
      actionsPadding: EdgeInsets.only(right: 16),
      backgroundColor: AppColor.primaryColor,
      title: const Text(
        AppStrings.history,
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        Container(
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
        preferredSize: Size.fromHeight(60),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 0),

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
    );
  }
}
