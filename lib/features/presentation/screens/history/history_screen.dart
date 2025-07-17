import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code_sacnner_app/core/color/app_color.dart';
import 'package:qr_code_sacnner_app/core/constant/app_icons.dart';
import 'package:qr_code_sacnner_app/core/utils/app_utils.dart';
import 'package:qr_code_sacnner_app/core/utils/barcode_utils.dart';
import 'package:qr_code_sacnner_app/core/utils/custom_dialogs.dart';
import 'package:qr_code_sacnner_app/features/data/models/history_model.dart';
import 'package:qr_code_sacnner_app/features/presentation/screens/generate/generate_screen.dart';
import 'package:qr_code_sacnner_app/features/presentation/screens/history/cubit/history_cubit.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    late List<HistoryModel> histories;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColor.primaryColor,
        appBar: CustomAppBar(),
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
                        CustomDialogs.showErrorDialog(
                          context: context,
                          title: "Error",
                          desc: state.message,
                          btnLabel: "Try Again",
                          onTap: () {
                            BlocProvider.of<HistoryCubit>(
                              context,
                            ).deleteHistory(state.id);
                          },
                        );
                      } else if (state is HistoryFailure) {
                        CustomDialogs.showErrorDialog(
                          context: context,
                          title: "Error Loading History",
                          desc: state.message,
                          btnLabel: "Try Again",
                          onTap: () {
                            BlocProvider.of<HistoryCubit>(
                              context,
                            ).loadHistories();
                          },
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is HistoryLoaded) {
                        histories = state.histories;
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
                                  'No History Found',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: AppColor.secondaryColor,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                      return ListView.builder(
                        itemCount: histories.length,
                        itemBuilder: (context, index) {
                          String content = histories[index].content;
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
                                BarcodeUtils.getQrCodeType(content) == 'URL'
                                    ? Icons.link
                                    : BarcodeUtils.getQrCodeType(content) ==
                                          'Text'
                                    ? Icons.text_fields
                                    : BarcodeUtils.getQrCodeType(content) ==
                                          'WiFi'
                                    ? Icons.wifi
                                    : BarcodeUtils.getQrCodeType(content) ==
                                          'Email'
                                    ? Icons.email
                                    : BarcodeUtils.getQrCodeType(content) ==
                                          'Phone'
                                    ? Icons.phone
                                    : BarcodeUtils.getQrCodeType(content) ==
                                          'SMS'
                                    ? Icons.sms
                                    : BarcodeUtils.getQrCodeType(content) ==
                                          'Geo Location'
                                    ? Icons.location_on
                                    : BarcodeUtils.getQrCodeType(content) ==
                                          'vCard (Contact)'
                                    ? Icons.contact_page
                                    : Icons.qr_code,
                                color: AppColor.secondaryColor,
                                size: 35,
                              ),
                              title: Text(
                                histories[index].title,
                                style: TextStyle(color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                histories[index].date.toLocal().toString(),
                                style: TextStyle(color: Colors.white70),
                              ),
                              trailing: IconButton(
                                onPressed: () async {
                                  await BlocProvider.of<HistoryCubit>(
                                    context,
                                  ).deleteHistory(histories[index].id);
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: AppColor.secondaryColor,
                                ),
                              ),
                              onTap: () {
                                if (BarcodeUtils.isWifiBarcode(content)) {
                                  CustomDialogs.showWifiDialog(
                                    context: context,
                                    ssid: BarcodeUtils.getWifiSsid(content)!,
                                    password: BarcodeUtils.getWifiPassword(
                                      content,
                                    )!,
                                    onOkTap: () {
                                      AppUtils.openWifiSettings();
                                    },
                                    onCancelTap: () {
                                      context.pop();
                                    },
                                  );
                                }
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            GenerateScreen(isShowAppBar: false),
          ],
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  CustomAppBar({super.key}) : preferredSize = Size.fromHeight(135);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 80,
      actionsPadding: EdgeInsets.only(right: 16),
      backgroundColor: AppColor.primaryColor,
      title: const Text('History', style: TextStyle(color: Colors.white)),
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
            onPressed: () {
              // Add your delete action here
            },
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
              Tab(text: 'Sacn'),
              Tab(text: 'Create'),
            ],
          ),
        ),
      ),
    );
  }
}
